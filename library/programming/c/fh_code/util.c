#include "main.h"

/**********************************************/
/***  This file contains utility functions. ***/
/**********************************************/


/* print scores_data2 */
void print_scores_data2(double numbers[],node *vertices[], int counter)
{
  int i;

  // printf("The value of counter is %d\n",counter);

  printf("\n Printing values of scores and node number.\n");
  for (i=0; i<counter; i++)
    {
      printf("  scores[%3d] = %f     scores_nodes[%3d]->number = %d\n",
	     i,numbers[i],i,vertices[i]->number);
      // ESA for a shorter version, use the line below and comment out the one above
      //printf("  scores[%3d] = %f   \n",i,numbers[i]);
    }
  printf("\n");
}


// This program will probably become obsolete, once we discuss
// various options.  It lives on, because I thought we should
// discuss the options....
//
//
/* ESA warning there are no precautions programmed yet.
   Watch value of ctr                                 */

/* print scores_data */
void print_scores_data(void)
{
  int i;

  // printf("The value of ctr is %d\n",ctr);

  printf("\n Printing values of scores and scores_nodes->score.\n");
  for (i=0; i<ctr; i++)
    {
      printf("  scores[%3d] = %f     scores_nodes[%3d]->scores = %f\n",
	     i,scores[i],i,scores_node[i]->score);
      // ESA for a shorter version, use the line below and comment out the one above
      //printf("  scores[%3d] = %f   \n",i,scores[i]);
    }
  printf("\n");
}



/******************************************/
/* heap sort for scores data              */
/*                                        */
/* modifed from web download for our data */
/* Sept 21, 2007                          */
/******************************************/

/* This program is based on a heap sort algorithm from    */
/*       http://linux.wku.edu/~lamonml/kb.html            */


// ESA
/*********************************************/
/*  implement a minHeap rather than maxHeap  */
/*                                           */
/*  October 23, 2007                         */
/*********************************************/

/****************************************************/
/*                                                  */
/* Warning:  this code assumes arrays are indexed   */
/*           from 0 to array_size                   */
/*           (Thus array_size is actually one less  */
/*                 than the number of elements.)    */
/****************************************************/

void heapSort(double numbers[], node *vertices[], int array_size)
{
  int i;
  double temp;
  node *tmp_node_ptr;

  for (i = (array_size / 2)-1; i >= 0; i--)
    siftDown(numbers, vertices, i, array_size);

  for (i = array_size; i >= 1; i--)
    {
      temp = numbers[0];
      numbers[0] = numbers[i];
      numbers[i] = temp;

      tmp_node_ptr = vertices[0];
      vertices[0] = vertices[i];
      vertices[i] = tmp_node_ptr;

      siftDown(numbers, vertices, 0, i-1);
    }
}


void siftDown(double numbers[], node *vertices[], int root, int bottom)
{
  int done, minChild;
  double temp;
  node *tmp_node_ptr;
 
  done = 0;
  while ((root*2 + 1 <= bottom) && (!done))
    {
      if (root*2+1 == bottom)
	minChild = root * 2 + 1;
       else if (numbers[root * 2 + 1] < numbers[root * 2 + 2])
        minChild = root * 2 + 1;
      else
	minChild = root * 2 + 2;

      if (numbers[root] > numbers[minChild])
 	{
	  temp = numbers[root];
	  numbers[root] = numbers[minChild];
	  numbers[minChild] = temp;

	  tmp_node_ptr = vertices[root];
	  vertices[root] = vertices[minChild];
	  vertices[minChild] = tmp_node_ptr;

	  root = minChild;
	}
      else
	done = 1;
    }
}



/*** Function to print data in infile in PHYLIP format ***/


void print_PHYLIP() {

  int i, j, k, rr;
  FILE *data;

  data=fopen("data","w");

   for (i=0; i<nseq; i++) {

      for (k=0; k<11; k++){
       fprintf(data,"%c",psname[i][k]);
     }

     for (j=0; j<num_unique; j++){

       for (rr=0; rr<site_counter[j]; rr++) {

	 if (ppBase_unique[i][j]==0) fprintf(data,"A");
	 if (ppBase_unique[i][j]==1) fprintf(data,"G");
	 if (ppBase_unique[i][j]==2) fprintf(data,"C");
	 if (ppBase_unique[i][j]==3) fprintf(data,"T");
	 if (ppBase_unique[i][j]==4) fprintf(data,"-");
	 if (ppBase_unique[i][j]==5) fprintf(data,"M");
	 if (ppBase_unique[i][j]==6) fprintf(data,"R");
	 if (ppBase_unique[i][j]==7) fprintf(data,"W");
	 if (ppBase_unique[i][j]==8) fprintf(data,"S");
	 if (ppBase_unique[i][j]==9) fprintf(data,"Y");
	 if (ppBase_unique[i][j]==10) fprintf(data,"K");
	 if (ppBase_unique[i][j]==11) fprintf(data,"B");
	 if (ppBase_unique[i][j]==12) fprintf(data,"D");
	 if (ppBase_unique[i][j]==13) fprintf(data,"H");
	 if (ppBase_unique[i][j]==14) fprintf(data,"V");
	 if (ppBase_unique[i][j]==15) fprintf(data,"N");	
		      
       }

     }

     fprintf(data,"\n");

   }

   fclose(data);
   
}



/*** Function to print initialized ppBase_unique matrix ***/

void print_ppBase() {

  int i, j;

  printf("ppBase_unique:\n");
  
  for (i=0; i<nseq; i++) {
    
    printf("Sequence %d",i+1);
    printf(":  ");
    printf(" %s\n",psname[i]);
    
    for (j=0; j<num_unique; j++){
      
      printf("%d",ppBase_unique[i][j]);
      
    }
    
    printf("\n");
    
  }
  
  printf("\n\n");
  for (i=0; i<num_unique; i++) {
    printf("Counter %d %d", i, site_counter[i]);
    printf("\n");
  }
  
  printf("\n\n");
  
}



/*** Compute pairwise distance matrix ***/

void CompDist() {

  int j, k, p;
  int num_diff=0;

  for (j=0; j<nseq; j++) {

    for (k=j+1; k<nseq; k++) {

      for (p=0; p<num_unique; p++) if (ppBase_unique[j][p] != ppBase_unique[k][p]) num_diff = num_diff + site_counter[p];
      ppDistMat[j][k] = ppDistMat[k][j] = (double)num_diff/(double)nsite;
      num_diff = 0;
	
    }

  }

  /* check */

  for (j=0; j<nseq; j++) {
    for (k=0; k<nseq; k++) {
      printf("%f ",ppDistMat[j][k]);
    }
    printf("\n");
  }


}
