#include "las2.c"
#include "svdutil.c"
#include "svdlib.c"
#include "main.h"
#include <string.h>

#include <sys/resource.h>


/* timing function --- eliminates spurious negative elapsed time due to sec/millisec issues*/
/*  this is necessary on UAF unix machine, needs to be checked for linux on a laptop*/

double timediff (struct rusage *rstart, struct rusage *rend) {
    return rend->ru_utime.tv_sec - rstart->ru_utime.tv_sec
      + (rend->ru_utime.tv_usec-rstart->ru_utime.tv_usec)*1e-6;
}


/*********************************************************/
/****** Functions to compute the flattened matrix ********/
/*********************************************************/


/* Quicksort function on binary encoding of characters --- should we write our own? 
   void bin_qsort(unsigned int **bin_array, int nentries, int entrylength, int *mask) 
   {
   qsort(bin_array, num_unique_bin, nints, bin_comp);
   }
*/

/************************************************************************************/
/* Compare binary vectors encoding patterns, using a mask for split */
/* This has both row and column versions*/

int bin_compC(const void *n1, const void *n2)
{  
  int i;
  unsigned int a,b;

  const unsigned int *num1 =(const unsigned int *)n1;
  const unsigned int *num2 =(const unsigned int *)n2;

  for (i=0; i<nints; i++)
    {
      a=(num1[i] & split_taxaC[i]);
      b=(num2[i] & split_taxaC[i]);
      if ( a<b ) return -1;
      else if ( a>b ) return  1;
    }
  return 0;
}


int bin_compR(const void *n1, const void *n2)
{
  int i;
  unsigned int a,b;

  const unsigned int *num1 =(const unsigned int *)n1;
  const unsigned int *num2 =(const unsigned int *)n2;

  for (i=0; i<nints; i++)
    {
      a=(num1[i] & split_taxaR[i]);
      b=(num2[i] & split_taxaR[i]);
      if ( a<b ) return -1;
      else if ( a>b ) return  1;
    }
  return 0;
}


/*****************************************************************************************/

/** Create binary encoding of patterns for use in flattening **/
int Data_Bin()
{

  /*Note: we remove any sites with any characters other than ATCG*/

  int  badBase, i, j, jj, k, m;
  unsigned int *pArr_u_bin;


  nfit = 32/2; /*number of bases we can encode in one 32-bit integer*/
  nints = (nseq/nfit) + 1; /*number of integers needed for encoding patterns (p\
			     lus at least 2 extra bits)*/


  /*Allocate array for unique site patterns*/
  /*Note: we allocate as contiguous block for use in qsort*/
  /*      Sorting will also use 2 extra ints in each column*/
  pArr_u_bin = (unsigned int*)malloc(num_unique*(nints+2)*sizeof(unsigned int)
				     );
  if (pArr_u_bin==NULL)
    {
      printf("Can't memalloc pArr_u_bin\n");
      return 0;
    }
  /*now allocate for pointers to patterns(rows of array)*/
  ppBase_u_bin=malloc(num_unique*sizeof(unsigned int*));
  if (ppBase_u_bin==NULL)
    {
      printf("Can't memalloc ppBase_u_bin\n");
      return 0;
    }
  /*complete allocation by pointing ppBase_u_bin to pArr_u_bin*/
  for (jj=0; jj<num_unique; jj++)
    {
      ppBase_u_bin[jj]=pArr_u_bin+jj*(nints+2);
    }


  /*Encode unique patterns with ONLY ATCG in binary format*/
  jj=0; //initialize pattern number in ppBase_u_bin                                                         
  for (j=0; j<num_unique; j++) //loop on unique sites                                                       
    {
      badBase=0; /*initialize flag,  1 will indicate non-ATCG*/
      for (i=0; i<nseq; i++)  /*loop on sequences*/
        {
          if (ppBase_unique[i][j]<4) /* make sure we have a ATCG*/
            {
              k=i/nfit; //compute word to cose this taxon in                                                
              m=i-k*nfit;//   and location in word, sort of                                                 
              if ( m == 0 ) /*  if beginning new word*/
                {
                  ppBase_u_bin[jj][k]=ppBase_unique[i][j];/*...just store*/
                }
              else
                {
                  ppBase_u_bin[jj][k] ^= ( ppBase_unique[i][j] << (2*m) ); /*... otherwise, shift base and \
									     combine*/
                }
            }
          else badBase=1; // a non-ATCG popped up --- this site will be ignored eventually                  
        }

      if ( badBase==0 ) // if this site had only ATCG                                                       
        {
          ppBase_u_bin[jj][nints-1] ^= (1 << 30);//set high bit so all patterns giveso non-zero encoding    
          ppBase_u_bin[jj][nints]=site_counter[j];// copy counts                                            
          jj++; //don't overwrite binary encoded pattern                                                    
        }
    }
  num_unique_bin=jj;// number of unique patterns in binary encoding                                         

}


/*******************************************************************************************/

/*** Read splits of interest from file, compute svd and scores ***/
/***      store scores to scores and scores_nodes              ***/

void getSVD(node *qq)
{  
  int i, j, k, p, q, jj, kk;
  int nsplits, num_in_split, splittax;
  int num_unique_rows, num_unique_cols;
  float exetime,rsorttime,csorttime;
  long int* firstnz; //, rowindex;

  int cur_split_size;
 
  // ESA temporary variables for development
  double score1=-44.4;
  // ESA

  struct rusage flatstart, flatend, SVDend;
  double flattimeTot=0;
  double SVDtimeTot=0; 

  SMat S;
  SVDRec R;

  /*allocate space for binary encoding of splits*/  
  split_taxaR = (unsigned int*)malloc((nints)*sizeof(unsigned int));
  split_taxaC = (unsigned int*)malloc((nints)*sizeof(unsigned int));

  getrusage(RUSAGE_SELF, &flatstart);

  /* initialize split_taxa vector */
  for (j=0; j<nints; j++) {
    split_taxaR[j] = 0;
    split_taxaC[j] = 0;
  }
  
  for (j=0; j<nints; j++) split_taxaR[j] = qq->split_taxa[j]; /*transfer split stored at node of interest*/
  for (j=0; j<nints; j++) split_taxaC[j] =~ split_taxaR[j]; /*complementary mask*/
 
  // printf("for node %d, splitR is %u and splitC is %u\n",qq->number,split_taxaR[0],split_taxaC[0]);

  /*sort on rows, to get row indices, then on columns, to get sparse encoding of flattening*/
  
  /*sort for rows*/
  qsort(*ppBase_u_bin, num_unique_bin, (nints+2)*sizeof(unsigned int), bin_compR);
  
  /*Enter row numbers into array*/
  jj=0;//initialize row number
  ppBase_u_bin[0][nints+1]=0; // this is always in first row
  for (j=1; j<num_unique_bin; j++)
    {	   	  
      if (bin_compR(ppBase_u_bin[j],ppBase_u_bin[j-1])==1) jj++;
      ppBase_u_bin[j][nints+1]=jj; // record row number
    }
  num_unique_rows=jj+1;
  
  /*sort for columns*/
  qsort(*ppBase_u_bin, num_unique_bin, (nints+2)*sizeof(unsigned int), bin_compC);
  
  
  /*allocate space for sparse matrix encoding*/
  long int* rowindex = (long int*) calloc(num_unique_bin,sizeof(long int));
  double* values  = (double*) calloc(num_unique_bin,sizeof(double));

  /* create vector encoding column numbers */
  jj=0; // first column number
  values[0]=(double)ppBase_u_bin[0][nints]/(double)nsite;// copy value of first non-zero for SVD
  
  rowindex[0]=ppBase_u_bin[0][nints+1];/*copy row index of first entry for SVD*/
  ppBase_u_bin[0][nints+1]=0; /*first entry is always in first column*/
  /*Note: we're reusing this space to store column info as we remove row info*/
  for (j=1; j<num_unique_bin; j++)
    { 
      values[j]=(double)(ppBase_u_bin[j][nints])/(double)nsite;/* copy non-zeros for SVD */
      rowindex[j]=ppBase_u_bin[j][nints+1];/* copy row indices for SVD*/
      if (bin_compC(ppBase_u_bin[j],ppBase_u_bin[j-1])==1)/* if new column...*/
	{ 
          jj++;      
	  ppBase_u_bin[jj][nints+1]=j;/*save column coding here temporarily*/
	}
    }
  num_unique_cols=jj+1;

  /*allocate final space for sparse matrix encoding*/
  firstnz = (long int*) calloc( num_unique_cols+1 , sizeof(long int));

  for (j=0; j<num_unique_cols; j++)
    {
      firstnz[j]=ppBase_u_bin[j][nints+1];
    }

  /* copy over column coding for SVD */
  firstnz[j]=num_unique_bin;/* sparse format requires this too*/
  
  /* Create Smat object to use in SVD routines */
  S = svdNewSMat(num_unique_rows,num_unique_cols,num_unique_bin);
  R = svdNewSVDRec();
  
  S->pointr = firstnz;
  S->rowind = rowindex;
  S->value = values;
  
 
  getrusage(RUSAGE_SELF, &flatend);
  //printf("Flattening time %g\n", timediff(&flatstart, &flatend));
  flattimeTot += timediff(&flatstart, &flatend);
  
  /* Compute SVD */
  extern long SVDVerbosity;
  SVDVerbosity=0; // print nothing from SVD routine
  //SVDVerbosity=1;        

  R = svdLAS2A(S,4);

  //printf("the singular values are %f %f %f %f %f %f %f %f %f %f %f %f\n",R->S[0],R->S[1],R->S[2],R->S[3],R->S[4],R->S[5],R->S[6],R->S[7],R->S[8],R->S[9],R->S[10],R->S[11]);
  //
  // ESA save current scoring mechanism to score1
  //  score1 = (pow(R->S[0],2)+pow(R->S[1],2)+pow(R->S[2],2)+pow(R->S[3],2))/fnorm;
  score1 = 1-sqrt((pow(R->S[0],2)+pow(R->S[1],2)+pow(R->S[2],2)+pow(R->S[3],2))/fnorm);
 
  // ESA
  //  printf("For node %2d, Score is %f\n\n",qq->number,score1);

  // ESA
  if (qq->tip || qq->back->tip)
  {
    printf("Mistake!  We don't want to store scores for terminal edges.\n");
    printf("  Trying to assign score for edge joining nodes %d ",qq->number);
    printf("and %d \n\n",qq->back->number);
  }
  else
  {
    // ESA saving score to two nodes that determine an edge
    //     perhaps temporary
    qq->score = score1;
    qq->back->score = score1;
    // printf("\t qq-> score is %f   and qq->back->score is %f \n",qq->score, qq->back->score);

    // Determine whether the current split is a "small" split or a "big" split
    //
    if (qq->ndesc < nseq-qq->ndesc)
      cur_split_size = qq->ndesc;
    else
      cur_split_size = nseq-qq->ndesc;

    // ESA
    // printf("cur_split_size is %d\n",cur_split_size);

    // storing score and pointer to node with score in appropriate array


    if (cur_split_size <= SMALL_SPLIT_SIZE)

      {
	//	printf("ndesc is %d and ctr_small is %d\n",qq->ndesc,ctr_small);

	scores_node_small[ctr_small] = qq;

	// printf("    scores_node_small[%d]->score = %f\n", ctr_small, scores_node_small[ctr_small]->score);
	scores_small[ctr_small] = score1;
	// printf("    scores_small[%d]->score = %f  and ndesc is %d \n\n", ctr_small, scores_small[ctr_small],scores_node_small[ctr_small]->ndesc);
	ctr_small ++;
      }
    else
      {
	// printf("ndesc is %d and ctr is %d\n",qq->ndesc,ctr);
	scores_node[ctr] = qq;
	// printf("    scores_node[%d]->score = %f\n", ctr, scores_node[ctr]->score);
	scores[ctr] = score1;
	// printf("    scores[%d]->score = %f  and ndesc is %d \n\n", ctr, scores[ctr],scores_node[ctr]->ndesc);
	ctr ++;
      }

  }

  fflush(0);

  
  free(firstnz);    
  free(rowindex);   
  free(values);
  
  S->pointr = NULL;
  S->rowind = NULL;
  S->value = NULL;
  
  svdFreeSMat(S);
  svdFreeSVDRec(R);
  
  
  getrusage(RUSAGE_SELF, &SVDend);
  // printf("SVD time %g\n", timediff(&flatend, &SVDend));
  SVDtimeTot += timediff(&flatend, &SVDend);
  
  num_unique_rows=0;
  num_unique_cols=0;
  
  //printf("\n");
 
  nsplits=1;
  //printf("Total time for %d flattenings: %g\n",nsplits,flattimeTot); 
  //printf("Total time for %d SVDs: %g\n\n\n",nsplits,SVDtimeTot); 
}


void traverseSVD(node *p)
{

  int j, k, i;
  double outl=0.0, outr=0.0, ppl[4][4], ppr[4][4];
 
  if (p->tip) {
    //printf("Tip number %d  \n",p->number);
  }
  else {
    //printf("Node number %2d ",p->number);
    // printf("   Node->back number %2d \n",p->back->number);
    traverseSVD(p->next->back);
    traverseSVD(p->next->next->back);

    // LSK commented back off 
    //printf("\nAssigning split_taxa for node %2d ",p->number);
    //printf("   node->back is %2d \n",p->back->number);

    for (k=0; k<nints; k++) {
      p->split_taxa[k] = (p->next->back->split_taxa[k] | p->next->next->back->split_taxa[k]);
      //printf("for k=%d, %d \n",k,p->split_taxa[k]);
    }
    
    //LSK - compute number of taxa in split - stored at p->ndesc for each node p
    p->ndesc = p->next->back->ndesc + p->next->next->back->ndesc;
    //printf("   number of taxa in split is %d\n",p->ndesc); //LSK check
    //printf("   descendants are %d and %d\n",p->next->back->number,p->next->next->back->number);

    getSVD(p);

  }
}  /* traverseSVD */


    
