#include "main.h"
#include <gsl/gsl_errno.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

/*****************************************************************************/
/************************** Tree search **************************************/
/***** This does both rearrangement and iteration in SSA algorithm.      *****/
/***** Version is a switch for how nodes for rearrangement are selected: *****/
/***** version = 1 is regular annealing                                  *****/
/***** version = 2 puts probability distribution on nodes based on SVD score**/
/*****************************************************************************/
/*****************************************************************************/

void trbldg(int version) {

  node *nodeA_NNI, *nodeB_NNI;     // pointers to nodes at ends of edge for NNI
  int stype;
  int node_number;

  long int seed=12345;
  int anneal_counter=1;
  double prev_lik;
  double ranunif;

  int max_iter = 10;               /*** move this to be global and read from settings file ***/
  int burnin = 100;
  int bound_last_unique, num_last_unique=0;
  double p_bound_unique = 0.05;
  double max_change = 0.0, deltaL;
  double co =28500.0*0.25;
  double ci, beta=0.05;
  
  const gsl_rng_type * T;
  gsl_rng * r;
  

  /* create a generator chosen by the 
     environment variable GSL_RNG_TYPE */
     
  gsl_rng_env_setup();
     
  T = gsl_rng_default;
  r = gsl_rng_alloc (T);
  gsl_rng_set(r,seed);

  ci=co/(1+beta);

  bound_last_unique = 3*nseq*((int)ceil(log(p_bound_unique)/(nseq*log(1.0-(1.0/nseq)))));
  printf("Annealing will be terminated when %d consecutive iterations fail to result in a move to a unique topology.\n",bound_last_unique);


  /*********************************************************/
  /****Burnin - to estimate U= upper bound on delta lnL ****/
  /*********************************************************/
  
  while (anneal_counter < burnin) {

    //printf("\n\n\n BURNIN ITERATION %d\n\n",anneal_counter);

    prev_lik = curtree.likelihood;
    
    //printf("\tChoosing an edge at random for the NNI moves (for now).\n");
    node_number = (int)(gsl_ran_flat(r,0,1)*(nseq-3))+nseq+1;
    //printf("\tselected node number %d, which corresponds to node %d\n",node_number,curtree.nodep[node_number]->number);
 
    if (curtree.nodep[node_number]->back->number > nseq)  {
      nodeB_NNI = curtree.nodep[node_number]->back;
      nodeA_NNI = curtree.nodep[node_number];
    }
    else if (curtree.nodep[node_number]->next->back->number > nseq) {
      nodeB_NNI = curtree.nodep[node_number]->next->back;
      nodeA_NNI = curtree.nodep[node_number]->next;
    }
    else {
      nodeB_NNI = curtree.nodep[node_number]->next->next->back;
      nodeA_NNI = curtree.nodep[node_number]->next->next;
    }

    //printf("  \tnodeA_NNI = %d     nodeB_NNI = %d\n\n",nodeA_NNI->number,nodeB_NNI->number);
    //printf("\tBefore swap, A has pointers to nodes %d, %d, and %d; and B has pointers to %d, %d, and %d\n",nodeA_NNI->back->number,nodeA_NNI->next->back->number,nodeA_NNI->next->next->back->number,nodeB_NNI->back->number,nodeB_NNI->next->back->number,nodeB_NNI->next->next->back->number);
    
    /*** Determine which NNI move to make ***/
    if (gsl_ran_flat(r,0,1)<0.5) {
      //printf("\tpicked first type\n");
      stype=1;
      swap_clades(nodeA_NNI->next,nodeB_NNI->next);
    }
    else {
      //printf("\tpicked second type\n");
      stype=2;
      swap_clades(nodeB_NNI->next,nodeA_NNI->next);
    }
    
    //printf("\tAfter swap, A has pointers to nodes %d, %d, and %d; and B has pointers to %d, %d, and %d\n",nodeA_NNI->back->number,nodeA_NNI->next->back->number,nodeA_NNI->next->next->back->number,nodeB_NNI->back->number,nodeB_NNI->next->back->number,nodeB_NNI->next->next->back->number);
    
    curtree.likelihood=getLik(curtree.nodep[0]->back);
    
    /** determine whether or not to accept NNI move **/
    
    if (curtree.likelihood < prev_lik) {
      ranunif = gsl_ran_flat(r,0,1);
      //printf("\n\t Random number is %f, comparing with prob %f\n",ranunif,exp((curtree.likelihood-prev_lik)/ci));
     if (ranunif>exp((curtree.likelihood-prev_lik)/ci)) { /* Don't keep new tree - put stuff back */
	//printf("\n\t Don't keep new tree - put stuff back\n");
	if (stype==1) swap_clades(nodeA_NNI->next,nodeB_NNI->next);
	else swap_clades(nodeB_NNI->next,nodeA_NNI->next);
	//printf("\t After swap back, A has pointers to nodes %d, %d, and %d; and B has pointers to %d, %d, and %d\n",nodeA_NNI->back->number,nodeA_NNI->next->back->number,nodeA_NNI->next->next->back->number,nodeB_NNI->back->number,nodeB_NNI->next->back->number,nodeB_NNI->next->next->back->number);
      }
      
    }

    deltaL = curtree.likelihood - prev_lik;
    if (deltaL<0) deltaL = -deltaL;
    if (deltaL > max_change) max_change=deltaL;
   
    ci = co/(1.0+anneal_counter*beta);
    anneal_counter++;

  }

  printf("After burnin, max_change is %f\n",max_change);


  /*********************************************************/
  /****************** End Burnin ***************************/
  /*********************************************************/
  /****************** Start Annealing **********************/
  /*********************************************************/

  anneal_counter = 1;
  co = max_change;
  ci = co/(1.0+anneal_counter*beta);

  while (anneal_counter < max_iter && num_last_unique < bound_last_unique) {

    //printf("\n\n\n ANNEALING ITERATION %d\n\n",anneal_counter);

    prev_lik = curtree.likelihood;
    
    node_number = (int)(gsl_ran_flat(r,0,1)*(nseq-3))+nseq+1;
    // printf("\tselected node number %d, which corresponds to node %d\n",node_number,curtree.nodep[node_number]->number);
 
    if (curtree.nodep[node_number]->back->number > nseq)  {
      nodeB_NNI = curtree.nodep[node_number]->back;
      nodeA_NNI = curtree.nodep[node_number];
    }
    else if (curtree.nodep[node_number]->next->back->number > nseq) {
      nodeB_NNI = curtree.nodep[node_number]->next->back;
      nodeA_NNI = curtree.nodep[node_number]->next;
    }
    else {
      nodeB_NNI = curtree.nodep[node_number]->next->next->back;
      nodeA_NNI = curtree.nodep[node_number]->next->next;
    }

    // printf("  \tnodeA_NNI = %d     nodeB_NNI = %d\n\n",nodeA_NNI->number,nodeB_NNI->number);
    
    // printf("\tBefore swap, A has pointers to nodes %d, %d, and %d; and B has pointers to %d, %d, and %d\n",nodeA_NNI->back->number,nodeA_NNI->next->back->number,nodeA_NNI->next->next->back->number,nodeB_NNI->back->number,nodeB_NNI->next->back->number,nodeB_NNI->next->next->back->number);
    
    
    /*** Determine which NNI move to make ***/
    if (gsl_ran_flat(r,0,1)<0.5) {
      // printf("\tpicked first type\n");
      stype=1;
      swap_clades(nodeA_NNI->next,nodeB_NNI->next);
    }
    else {
      // printf("\tpicked second type\n");
      stype=2;
      swap_clades(nodeB_NNI->next,nodeA_NNI->next);
    }
    
    // printf("\tAfter swap, A has pointers to nodes %d, %d, and %d; and B has pointers to %d, %d, and %d\n",nodeA_NNI->back->number,nodeA_NNI->next->back->number,nodeA_NNI->next->next->back->number,nodeB_NNI->back->number,nodeB_NNI->next->back->number,nodeB_NNI->next->next->back->number);
    
    curtree.likelihood=getLik(curtree.nodep[0]->back);
    
    /** determine whether or not to accept NNI move **/
    
    if (curtree.likelihood < prev_lik) {
      ranunif = gsl_ran_flat(r,0,1);
      // printf("\n\t Random number is %f, comparing with prob %f\n",ranunif,exp((curtree.likelihood-prev_lik)/ci));
      if (ranunif>exp((curtree.likelihood-prev_lik)/ci)) { /* Don't keep new tree - put stuff back */
	// printf("\n\t Don't keep new tree - put stuff back\n");
	if (stype==1) swap_clades(nodeA_NNI->next,nodeB_NNI->next);
	else swap_clades(nodeB_NNI->next,nodeA_NNI->next);
	// printf("\t After swap back, A has pointers to nodes %d, %d, and %d; and B has pointers to %d, %d, and %d\n",nodeA_NNI->back->number,nodeA_NNI->next->back->number,nodeA_NNI->next->next->back->number,nodeB_NNI->back->number,nodeB_NNI->next->back->number,nodeB_NNI->next->next->back->number);
	curtree.likelihood=getLik(curtree.nodep[0]->back);
      }
      
    }

    printf("%d %f %f\n",anneal_counter,curtree.likelihood,prev_lik);
   
    ci = co/(1.0+anneal_counter*beta);
    anneal_counter++;

  }

  gsl_rng_free(r);


}


