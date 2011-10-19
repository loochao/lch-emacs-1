/***************************************************************/
/********** Program for invariants project.           **********/
/********** Written by L. S. Kubatko, E. S. Allman    **********/
/********** and J. Rhodes, April 2007                 **********/
/***************************************************************/

#include "main.h"

/************************/
/*** global variables ***/
/************************/

/*** general ***/
naym *psname;
int nsite, nseq, num_unique, print_data_ind=0, print_data_phylip=0, include_gaps;
int **ppBase, **ppBase_unique, *site_counter;
double **ppDistMat;
double fnorm;
FILE *tf;
FILE *outtree;

// ESA global variables, may change status later
int ctr;
int ctr_small;
double *scores;
node **scores_node;
double *scores_small;
node **scores_node_small;
// ESA temp variable
int NNIcount=1;


const int SMALL_SPLIT_SIZE=5;

//LSK added for tree storing structure
Link Head, currenttree;


/*** to make compatiable with PHYLIP code ***/
int lngths=1;
double fracchange=1.0;

/*** to compute transition probabilities ***/
double pi_A, pi_G, pi_C, pi_T, Avg_pi, Var_pi, Cov_pi;
double pi_a, pi_g, pi_c, pi_t;
double pi_R, pi_Y, pi_r, pi_y, Purines, Pyrimid;
double inv_pi_r1, inv_pi_y1;
double pi_a_r, pi_g_r, pi_c_y, pi_t_y;
double pi_a_r1, pi_g_r1, pi_c_y1, pi_t_y1;
double mu, tratio; 

double pp[4][4];

// Q rate matrix
// S 
// T
// lam's are eigenvalues of Q
double Q[4][4];
double S[4][4];
double T[4][4];
double lam0, lam1, lam2, lam3;
double K;
double rAC, rAG, rAT, rCG, rCT, rGT;

tree curtree;

/*** variables for binary encoding ***/
int nints, nfit, num_unique_bin;
unsigned int **ppBase_u_bin, *counts, *split_taxaR, *split_taxaC;


/*** Open input and output files***/

int FileSpecInit(FILESPEC* pFileSpec) {

  if ((pFileSpec->infile=fopen("infile","r"))==NULL)
    {
      printf("Can't open infile\n");
      return 0;
    }

  if ((pFileSpec->splits=fopen("splits","r"))==NULL)
    {
      printf("Can't open splits\n");
      return 0;
    }
  
  if ((pFileSpec->flat=fopen("flat.r","w"))==NULL)
    {
      printf("Can't open flat.r\n");
      return 0;
    }

  if ((pFileSpec->settings=fopen("settings","r"))==NULL)
    {
      printf("Can't open settings\n");
      return 0;
    }

  return 1;
}


/***Memory allocation for all global variables which are  pointers***/

int MemAlloc() {

  int i, j;

  // ESA
  /* Allocate memory for table to store SVD scores for internal edges    */

  scores_node = (node **)malloc((nseq-3)*sizeof(node *));
  if (scores_node==NULL)
    {
      printf("Can't memalloc scores_node\n");
      return 0;
    }

  for (i = 0; i < nseq-3; i++)
    scores_node[i] = (node *)malloc(sizeof(node));
  
  scores = (double *)malloc((nseq-3)*sizeof(double));
  if (scores==NULL)
    {
      printf("Can't memalloc scores\n");
      return 0;
    }

  scores_node_small = (node **)malloc((nseq-3)*sizeof(node *));
  if (scores_node_small==NULL)
    {
      printf("Can't memalloc scores_node_small\n");
      return 0;
    }

  for (i = 0; i < nseq-3; i++)
    scores_node_small[i] = (node *)malloc(sizeof(node));
  
  scores_small = (double *)malloc((nseq-3)*sizeof(double));
  if (scores_small==NULL)
    {
      printf("Can't memalloc scores_small\n");
      return 0;
    }

  // end ESA additions
  
  ppBase = (int**)malloc(nseq*sizeof(int*));
  if (ppBase==NULL)
    {
      printf("Can't memalloc ppBase\n");
      return 0;
    }
  
  for (i=0; i<nseq; i++)
    {
      ppBase[i]=(int*)malloc((nsite+1)*sizeof(int));
      if (ppBase[i]==NULL)
	{
	  printf("Can't memalloc ppBase[%d]\n",i);
	  return 0;
	}
    }
 
  ppBase_unique = (int**)malloc(nseq*sizeof(int*));
  if (ppBase_unique==NULL)
    {
      printf("Can't memalloc ppBase_unique\n");
      return 0;
    }
  
  for (i=0; i<nseq; i++)
    {
      ppBase_unique[i]=(int*)malloc((nsite+5)*sizeof(int));
      if (ppBase_unique[i]==NULL)
	{
	  printf("Can't memalloc ppBase_unique[%d]\n",i);
	  return 0;
	}
    }

  site_counter = (int*)malloc((nsite+1)*sizeof(int));
  if (site_counter==NULL)
    {
      printf("Can't memalloc site_counter\n");
      return 0;
    }
    
  ppDistMat = (double**)malloc(nseq*sizeof(double*));
  if (ppDistMat==NULL)
    {
      printf("Can't memalloc ppDistMat\n");
      return 0;
    }

  for (i=0; i<nseq; i++) {
    ppDistMat[i] = (double*)malloc(nseq*sizeof(double));
    if (ppDistMat[i]==NULL) 
      {
	printf("Can't memalloc ppDistMat[%d]\n",i);
	return 0;
      }
  }

  return 1;
}


/*** Transform character sequences (A,G,C,T) ****/
/*** into numerical values (0,1,2,3)         ****/

void transfer(char **cbase,int **nbase,int pres_loc, int trans_length) {

  int i, j, k=0;

  for (i=0; i<nseq; i++)  {

    for (j=0; j<trans_length; j++) {

      switch (cbase[i][j]) {
	    
      case 'A': case 'a': nbase[i][j+pres_loc] = 0;  break;
      case 'G': case 'g': nbase[i][j+pres_loc] = 1;  break;
      case 'C': case 'c': nbase[i][j+pres_loc] = 2;  break;
      case 'T': case 't': case 'U': case 'u': nbase[i][j+pres_loc] = 3;  break;
      case 'M': case 'm': nbase[i][j+pres_loc] = 5;  break;
      case 'R': case 'r': nbase[i][j+pres_loc] = 6;  break;
      case 'W': case 'w': nbase[i][j+pres_loc] = 7;  break;
      case 'S': case 's': nbase[i][j+pres_loc] = 8;  break;
      case 'Y': case 'y': nbase[i][j+pres_loc] = 9;  break;
      case 'K': case 'k': nbase[i][j+pres_loc] = 10;  break;
      case 'B': case 'b': nbase[i][j+pres_loc] = 11;  break;
      case 'D': case 'd': nbase[i][j+pres_loc] = 12;  break;
      case 'H': case 'h': nbase[i][j+pres_loc] = 13;  break;
      case 'V': case 'v': nbase[i][j+pres_loc] = 14;  break;
      case 'N': case 'n': nbase[i][j+pres_loc] = 15;  break;
      case '.':nbase[i][j+pres_loc] = nbase[0][j+pres_loc]; break;
      case '-':nbase[i][j+pres_loc]=4; break;
      case '?':nbase[i][j+pres_loc]=15; break;
      default: break;

      }
	  
    }
  }
}


/*** Input the number of sequences (nseq), number of sites (nsite)   ****/
/*** and DNA sequences of taxa from datafile.                        ****/
/*** Then transform DNA sequences into numerical sequences (ppBase)  ****/

naym* InputInit(FILESPEC *pFileSpec) {
  
  int i, k;
  char **ppDNASeq;
  int charLen;
  
  charLen=(nsite+1)*sizeof(char);
  ppDNASeq=(char**)malloc(nseq*sizeof(char*));
  if(ppDNASeq==NULL){
    return NULL;
  }
  
  for (i=0; i<nseq; i++)
    {
      ppDNASeq[i]=(char*)malloc(charLen);
      if(ppDNASeq[i]==NULL){
	return NULL;
      }
    }
  
  psname = (naym*)malloc(nseq*sizeof(naym));
  
  if(psname==NULL){
    return NULL;
  }
  
  for (i=0; i<nseq; i++)
    {
      fscanf(pFileSpec->infile, "%s %s", psname[i],ppDNASeq[i]);

      for (k=0; k<11; k++) if (psname[i][k] == 0) psname[i][k] = ' ';

    }
  
  transfer(ppDNASeq,ppBase,0,nsite);
  
  fclose(pFileSpec->infile);
  pFileSpec->infile=NULL;
  
  for (i=0; i<nseq; i++) {
    free(ppDNASeq[i]);
  }
  
  free(ppDNASeq);
  
  return psname;
  
}


/*******************************************************************/
/*** read model parameters from file "settings"                  ***/
/***   if GTR specified, also read relative rates                ***/
/***   if HKY, F84 or K2P specified, also read tratio            ***/
/*******************************************************************/

/*******************************************************************/
/***  Model selection:  1=GTR, 2=HKY, 3=F84, 4=K2P, 5=JC, 6=F81  ***/
/*******************************************************************/

int RatesInit(FILESPEC *pFileSpec) {
  int model;
  char *opt_name[18];
  
  // read in parameters as floats, then store to global doubles
  float cpy_rAC, cpy_rAG, cpy_rAT, cpy_rCG, cpy_rCT, cpy_rGT;
  float cpy_tratio;

  char garbage_str[80];
  int number_read;


  // read in model
  fscanf(pFileSpec->settings, "%18s %d", &opt_name,&model);

  if (model==1){
    // GTR
    
    // read relative rates if user chooses GTR
    fscanf(pFileSpec->settings, "%18s %f %f %f %f %f %f",
	   &opt_name, &cpy_rAC, &cpy_rAG, &cpy_rAT, &cpy_rCG, &cpy_rCT, &cpy_rGT);
  
    rAC=cpy_rAC;
    rAG=cpy_rAG;
    rAT=cpy_rAT;
    rCG=cpy_rCG;
    rCT=cpy_rCT;
    rGT=1;

    printf("\n");
  }
  else if ((model==2) || (model==3) || (model==4)){
    // HKY, F84, K2P

    // read tratio if present; otherwise set to default value of 2

    // read and ignore EOL character and line with GTR rates
    fgets(garbage_str, 80, pFileSpec->settings);
    fgets(garbage_str, 80, pFileSpec->settings);
    number_read=fscanf(pFileSpec->settings, "%18s %f", &opt_name, &cpy_tratio);

    if (number_read==2)
      tratio=cpy_tratio;
    else
      tratio=2.0;
  }
  else if ((model==5) || (model==6)){
    // JC, F81

    // Just check to see that user specified valid model
  }
  else{
    printf("Error in model specification.  Check file \'settings\'.\n   Now exiting.....   Goodbye.\n\n");
    exit(1);
  }

  fclose(pFileSpec->settings);
  pFileSpec->settings=NULL;
  
  return model;

}


/*** Search all unique sites and count them - counts  are   ***/
/*** stored in the array site_counter.                      ***/

void unique_sites(FILESPEC fspec){

  int i,ii,j,k,s,m=0;
  int num_no_gaps=0;
  int start;

  start=0;

  /* Find the first site with no gaps if include_gaps==0 */

  if (include_gaps==0) {

    for (j=0; j<nsite; j++) {      
      i=0;
      /*while (i<nseq && ppBase[i][j]!=4) { i++; }*/
      while (i<nseq && ppBase[i][j]!=4 && ppBase[i][j]!=15) { i++; }
      
      if (i==nseq) {
	start=j;
	break;
      }
      
    }

  }

  /* First remove sites with all gaps if include_gaps==1 */

  if (include_gaps==1) {

    for (j=0; j<nsite; j++) {
      i=0; 
      while (i<nseq && ppBase[i][j]==4) { i++; }
      if (i==nseq) ppBase[0][j] = 99;
    }
  }

  for (j=start; j<nsite; j++) {
    /*if ((ppBase[0][j]!=99 && include_gaps==1) || (ppBase[0][j]!=99 && include_gaps==0 && ppBase[0][j]!=4)) {*/
    if ((ppBase[0][j]!=99 && include_gaps==1) || (ppBase[0][j]!=99 && include_gaps==0 && ppBase[0][j]!=4 && ppBase[0][j]!=15)) {
      site_counter[m]=1;
      for (i=0; i<nseq; i++) {
	ppBase_unique[i][m] = ppBase[i][j];
      }
      ppBase[0][j]=99;

      for (k=j+1; k<nsite; k++) {
	i=0;
	while (i< nseq && ppBase_unique[i][m] == ppBase[i][k]) {
	  i++;
	}

	if (i==nseq) {
	  site_counter[m]++;
	  ppBase[0][k]=99;
	}

	if (i<nseq && (ppBase[i][k]==4 || ppBase[i][k]==15) && include_gaps==0) {
	  ppBase[0][k]=99;
	}

	if (i<nseq && include_gaps==0) {
	  for (s=0; s<nseq; s++) {
	    if (ppBase[s][k]==4 || ppBase[s][k]==15) ppBase[0][k]=99;
	  }
	}
      }
      m++;
    }
  }

  num_unique=m;
  printf("\n");
  printf("The number of unique site patterns is %d\n\n",num_unique);
  for (i=0; i<num_unique; i++) num_no_gaps += site_counter[i];
  if (include_gaps == 0) printf("Sites with a gap in at least one taxa have been excluded - the \n total number of sites used in the computations is %d\n\n",num_no_gaps);

}


/*************   The Main Program  *********************/


int main(){

  FILESPEC filespec;
  naym *sname;
  int i, j, jj;
  node *q, *p;
  double aa, bb, K;
  struct Node4Trees n;
 
  int model;

  struct rusage totstart, totend;
  double tottime=0;

  include_gaps=0;
  fnorm = 0.0;
  
  /*** Read data from files ***/
  if (!FileSpecInit(&filespec)) {
    printf("can't open file \n");
    exit(1);
  }
  fscanf(filespec.infile, "%d %d", &nseq, &nsite);


  /*** Allocate memory ***/
  MemAlloc();


  /*** Call the function InputInit which will read sequences  ***/
  /*** from infile and convert them to numeric using the      ***/
  /*** function transform.  Returns NULL if a problem occurs. ***/
  sname = InputInit(&filespec);
  if (sname==NULL) {
    printf("Can't allocate memory in InputInit\n");
    exit(1);
  }
  printf("\n\n%d sequences and %d sites read from infile\n",nseq,nsite);
  
  /* compute quantities needed to store splits in binary format */
  nfit = 32/2;             /*number of bases we can encode in one 32-bit integer*/
  nints = (nseq/nfit) + 1; /*number of integers needed for encoding patterns (plus at least 2 extra bits)*/


  /***  Find all unique site patterns and store them in ppBase_unique  ***/
  unique_sites(filespec);
  // print_PHYLIP();

  /*** Initialize curtree ***/
  curtree.nodep = (node **)malloc((2*nseq-2)*sizeof(node *));
  for (i = 0; i < 2*nseq-2; i++)
    curtree.nodep[i] = (node *)malloc(sizeof(node));
  for (i = nseq; i < 2*nseq-2; i++) {
    q = NULL;
    for (j = 1; j <= 3; j++) {
      p = (node *)malloc(sizeof(node));
      p->next = q;
      q = p;
    }
    p->next->next->next = p;
    curtree.nodep[i] = p;
  }

  setuptree(&curtree);

  //LSK - set up linked list to store trees
  //CreateList();

  /*** Read in tree from file ***/

  tf = fopen("treefile","r");
  treeread();
  fclose(tf);

  printf("Read tree\n");
  fflush(0);

  // Begin model setup

  // read in model and parameters from file.
  model = RatesInit(&filespec);
  
  // Get rate matrix Q and right eigenvalues and eigenvectors
  get_Q(model);
  get_eigs_S_T();

  // ESA options to print out parameter values
  //
  //  print_relative_rates(rAG, rAC, rAT, rCG, rGT, rCT);
  // print_eigs_S_T();
  // print_Q();



  /*** Get sum of squared counts, i.e. the square of the Froebenius norm ***/
  for (i=0; i<num_unique; i++) fnorm = fnorm + pow((double)site_counter[i]/(double)nsite,2);
  printf("Sum of squared counts is %f\n\n",fnorm);



  /************************************/
  /**** LSK - August 2007 *************/
  /************************************/
  /**** Example tree optimization  ****/
  /************************************/

  curtree.likelihood=getLik(curtree.nodep[0]->back);
  printf("The log-likelihood of current tree in memory before parsimony approximated lengths is %f\n",curtree.likelihood);

 
  traverseMPRSet(curtree.start->back);        //LSK
  traverseMPR(curtree.start->back);           //LSK
  traverseMPRlens(curtree.start->back,model); //LSK

  //print_PHYLIP();
  
  curtree.likelihood=getLik(curtree.nodep[0]->back);
  printf("The log-likelihood of current tree in memory after parsimony approximated lengths is %f\n",curtree.likelihood);
  printf("Now use Brent's method (as implemented in GSL) to optimize lengths in tree without using derivatives:\n");
  OptTree();
  curtree.likelihood=getLik(curtree.nodep[0]->back);
  printf("The likelihood after optimizing is %f\n",curtree.likelihood);


  exit(1);

   InitNodeLiks(); // LSK - place the correct sub-tree likelihood at each edge for each node

  // A check that InitNodeLiks works - to be removed
  localLik(curtree.nodep[10]);
  localLik(curtree.nodep[10]->next);
  localLik(curtree.nodep[10]->next->next);

  outtree = fopen("origTreePostOpt.tre","w");
  // ESA commenting out PAUP format
  //fprintf(outtree,"Begin tree;\ntree PAUP_1 = [&U]");
  treeout(curtree.start->back);
  // fprintf(outtree,"end;\n");
  fclose(outtree);

  // ESA
  printf("    *** End optimization.\n");

  /*************************************/
  /**** End optimization ***************/
  /*************************************/

  printf("\n    *** Begin SVD score traverses.\n");

  // ESA compute scores and start thinking about how to use them
  ctr = 0;
  ctr_small = 0;
  Data_Bin();

  // ESA testing possible bug fix
  //
  // Unfortunately, this code assumes that the tree is binary.
  // 
  /* moving curtree.start so that it is a node corresponding to an internal branch */
  
/*   if ((curtree.start->tip) || (curtree.start->back->tip)) { */
/*     printf("\n Going to move start from a vertex on a pendant edge.\n"); */
/*     printf(" curtree.start->number is %d and curtree.start->back->number is %d\n\n", curtree.start->number, curtree.start->back->number); */
/*     if (curtree.start->tip) { */
/*       if (curtree.start->back->next->back->tip) { */
/* 	curtree.start=curtree.start->back->next->next; */
/*       } */
/*       else { */
/* 	curtree.start=curtree.start->back->next; */
/*       } */
/*     } */
/*     else { */
/*       // curtree.start is non-tip edge of pendant edge */
/*       if (curtree.start->next->back->tip) { */
/* 	curtree.start=curtree.start->next->next; */
/*       } */
/*       else { */
/* 	curtree.start=curtree.start->next; */
/*       } */
/*     } */
/*   } */

  // ESA

  printf(" curtree.start->number is %d and curtree.start->back->number is %d\n\n", curtree.start->number, curtree.start->back->number);

  traverseSVD(curtree.start);
  traverseSVD(curtree.start->back);

  printf("\tValue of SMALL_SPLIT_SIZE is %d\n",SMALL_SPLIT_SIZE);
  printf("\tNumber of large splits is %d\n",ctr);
  printf("\tNumber of small splits is %d\n",ctr_small);
  //print_scores_data2(scores_small,scores_node_small,ctr_small);

  //  printf("entering heapSort for scores\n");
  // ESA:   ** important ** 
  // the way the heapsort is coded you need to send
  // the last index of the scores array, not the size
  heapSort(scores, scores_node, ctr-1);

  // ESA
  //  printf("Scores after heap sort \n");
  // print_scores_data2(scores,scores_node,ctr);

  // printf("entering heapSort for scores_small\n");
  // ESA:   ** important ** 
  // the way the heapsort is coded you need to send
  // the last index of the scores array, not the size
  heapSort(scores_small, scores_node_small, ctr_small-1);

  // ESA
  //printf("Scores for small splits after heap sort \n");
  //print_scores_data2(scores_small,scores_node_small,ctr_small);

  outtree = fopen("NNItrees.tre","w");
  treeoutScores(curtree.start->back);
  fclose(outtree);

  outtree = fopen("NNIlikelihoods","w");
  fprintf(outtree,"These are the log-likelihoods after NNIs.  There are duplicate trees here.  (Just a single pair.)\n\n");
  fprintf(outtree,"The log-likelihood after optimizing the original tree %d is %f\n",NNIcount,curtree.likelihood);
  // Print same message to screen.
  printf("\nThe log-likelihood after optimizing the original tree (tree %d) is %f\n\n",NNIcount,curtree.likelihood);
  NNIcount++;
  fclose(outtree);

  // to start more in middle of tree for understanding recursion
  //curtree.start=curtree.start->back->next->next->back;
  //curtree.start=curtree.start->back->next->back;
  //curtree.start=curtree.start->back;

  // 
  printf("curtree.start->number is %d and curtree.start->back->number is %d\n\n", curtree.start->number, curtree.start->back->number);

  //  printf("\n1st call to traverseNNI with curtree.start->back->number is %d and curtree.start->number is %d\n", curtree.start->back->number, curtree.start->number);
  traverseNNI(curtree.start->back);
  //printf("\n2nd call to traverseNNI with curtree.start->number is %d and curtree.start->back->number is %d\n", curtree.start->number, curtree.start->back->number);
  traverseNNI(curtree.start);

  // *****  ESA  ***** //

  exit(1);
 
  /*************************************/
  /**** Begin annealing ****************/
  /*************************************/
  
  // ESA put in exit(1) above
  //
  printf("trbldg\n");

  trbldg(1);

  printf("\n\nResults after one round of annealing:\n");

  curtree.likelihood=getLik(curtree.nodep[0]->back);
  printf("\tThe log-likelihood of current tree in memory after parsimony approximated lengths is %f\n\n",curtree.likelihood);

  printf("Start OptTree again.\n");

  printf("\tNow use Brent's method (as implemented in GSL) to optimize lengths in tree without using derivatives:\n\n");

  OptTree();

  curtree.likelihood=getLik(curtree.nodep[0]->back);
  printf("\n\n\tThe likelihood after optimizing is %f\n\n",curtree.likelihood);
  

  outtree = fopen("outtree2.tre","w");
  //  fprintf(outtree,"Begin tree;\ntree PAUP_1 = [&U]");
  treeout(curtree.start->back);
  //  fprintf(outtree,"end;\n");
  fclose(outtree);
  // */

  exit(1);

  /*************************************/
  /*** End LSK - all else skipped    ***/
  /*************************************/
  

  /* get likelihood function - appears to work for any value in [] */
  /* most intuitive call is curtree.start->back */
    
  /*   tottime=0.0; */
  /*   for (jj=0; jj<1; jj++) { */
    
  /*     getrusage(RUSAGE_SELF,&totstart); */
    
  /*     printf("\n\n"); */
  
  curtree.likelihood=getLik(curtree.nodep[0]->back);

  printf("log-likelihood of current tree in memory is %f\n",curtree.likelihood);
  printf("\n");

  outtree = fopen("outtree","w");
  treeout(curtree.start->back);
  fclose(outtree);

  /*** Optional checks that data was read in correctly ***/
  /*  if (print_data_ind==1) print_ppBase();
      if (print_data_phylip==1) print_PHYLIP();
  */


  return 1;
 
}

