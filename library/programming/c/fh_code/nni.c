#include "main.h"
#include <gsl/gsl_math.h>
#include <gsl/gsl_eigen.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

// This is a temporary name and temporary file in order to
// do all NNIs in tree.


/* 
   swap_cladesNNI:  a function to swap clades that updates the scores.  Once initialization
   is done for ndesc and split_taxa, these can be updated too.

   updateNodes:     a function that recomputes ndesc, score, and split-taxa for the two nodes
   indicating the edge under scrutiny

   traverseNNI:     a function that sequentially goes through a tree performs every NNI,
   computes the likelihood and writes the likelihood and the tree out to file.
*/


/*************************************/
/*  swap clades NNI:           *******/
/*  swap p->back and q->back   *******/
/*************************************/

void swap_cladesNNI(node *p, node *q) 
{
  node *tmp_node;
  int tmp_ndesc;
  double tmp_score;
  unsigned int *tmp_split_taxa;

  const gsl_rng_type * T;
  gsl_rng * r;

  // LSK - modify lengths of three affected branches
  // OptNode function in optbranch.c will find optimal value of length
  // During search, may not want to set lengths to exact optimum
  // Thus, include option to add randomness to lengths, but using info from optimization

  // ESA temporary check: do not swap clades if p or q is tip

  if (p->tip || q->tip)
    {
      printf("You called swap_cladesNNI with a tip!  Oh no!\n");
      printf("  p->number %d p->tip %d and q->number %d q->tip %d\n\n",
	     p->number,p->tip,q->number,q->tip);
      printf("       Exiting early .....\n\n");
      exit(1);
    }

  // ESA We can not exchange ndesc and split_taxa yet.  We need
  //     to initialize them or have them saved at all nodes of tree 
  //     structure.

  // Exchange ndesc, split_taxa and score for nodes p and q
  /*   tmp_ndesc = p->ndesc; */
  tmp_score = p->score;
  /*   tmp_split_taxa = tmp_split_taxa; */

  /*   p->ndesc = q->ndesc; */
  p->score = q->score;
  /*   p->split_taxa = q->split_taxa; */

  /*   q->ndesc = tmp_ndesc; */
  q->score = tmp_score;
  /*   q->split_taxa = tmp_split_taxa; */

  // Make clade p->back point to q and clade q->back point to p 
  p->back->back = q;
  q->back->back = p;

  // Exchange the back pointers for p and q
  tmp_node=p->back; 
  p->back = q->back;
  q->back = tmp_node;

  //LSK commented out ---- don't need this - just for testing ----- curtree.likelihood=getLik(curtree.nodep[0]->back);
  //printf("\n\tlog-likelihood after swap before optimization is %f\n",curtree.likelihood);


  /** The code below will get optimal branch lengths for three branches **/
  /** in neighborhood of NNI.                                           **/

  OptNode(p);
  p->back->v = p->v;
  OptNode(q);
  q->back->v = q->v;

  OptNode(p->next->next);
  q->next->next->v = p->next->next->v;

  /** To do annealing, it's better to randomly perturb neighboring branches **/
  /** multiple by gamma dist RV with mean 1.                                **/
  /*
  gsl_rng_env_setup();
     
  T = gsl_rng_default;
  r = gsl_rng_alloc (T); 

  p->v = p->back->v = gsl_ran_gamma(r,350.0,(1.0/350.0))*p->v;
  q->v = q->back->v = gsl_ran_gamma(r,350.0,(1.0/350.0))*q->v;
  q->next->next->v = p->next->next->v = gsl_ran_gamma(r,350.0,(1.0/350.0))*p->next->next->v;
  */
} /* swap_cladesNNI */



/**********************************************************************************/
/* updateNodes                                                                    */
/* updateNodes will recompute split_taxa, ndesc, and score for nodes p and p->back*/
/*             It should be called after a call to swap_cladesNNI                 */
/**********************************************************************************/

void updateNodes(p)
     node *p;
{
  int k;

  //  printf("\nAssigning split_taxa for node %2d ",p->number);
  //  printf("   node->back is %2d \n",p->back->number);

  /* The first node that requires updating is p */

  for (k=0; k<nints; k++) {
    p->split_taxa[k] = (p->next->back->split_taxa[k] | p->next->next->back->split_taxa[k]);
    //    printf("for k=%d, %d \n",k,p->split_taxa[k]);
  }
    
  //LSK - compute number of taxa in split - stored at p->ndesc for each node p
  p->ndesc = p->next->back->ndesc + p->next->next->back->ndesc;
  printf("   number of taxa in split is %d\n",p->ndesc); //LSK check
  printf("   descendants are %d and %d\n",p->next->back->number,p->next->next->back->number);

  getSVD(p);

  /* The second node that requires updating for the edge is p->back */

  // Store the score just computed to the other end of the edge
  p->back->score = p->score;

  // Now recompute split_taxa and ndesc for p->back

  for (k=0; k<nints; k++) {
    p->back->split_taxa[k] = (p->back->next->back->split_taxa[k] | p->back->next->next->back->split_taxa[k]);
    //    printf("for k=%d, %d \n",k,p->back->split_taxa[k]);
  }

  // This can be improved using numtaxa-what was just computed.    
  //LSK - compute number of taxa in split - stored at p->ndesc for each node p
  p->back->ndesc = p->back->next->back->ndesc + p->back->next->next->back->ndesc;
  printf("   number of taxa in split is %d\n",p->back->ndesc); //LSK check
  printf("   descendants are %d and %d\n",p->back->next->back->number,p->back->next->next->back->number);

}  /* updateNodes */



/*********************************************************************/
/*  traverseNNI                                                      */
/*     This function will traverse a tree doing all NNIs on this     */
/*     tree.  This is a first step towards a PAUP* NNI search        */
/*********************************************************************/

void traverseNNI(p)
     node *p;
{
  int k;

  // until this code moves
  int model=3;

  if (p->tip) {
    //printf(" Tip %d with name ",p->number);
    //for (k=0; k<11; k++) printf("%c",p->nayme[k]);
    //printf("\n");
    //    printf("     Tip %d ->back has number %d\n",p->number,p->back->number);
  }  
  else {

    if (p->back->tip) {
      // ESA This will eventually be erased.  It is to remind me that I put in this special
      // check whether p->back is a tip or not.
      printf("         *** LOOK HERE ***\n");
      printf("     p->back->tip is %d\n",p->back->tip); 
      printf("Node %d with length %f\n",p->number,p->v);
      printf("     Node %d ->back has number %d\n",p->number,p->back->number);
      printf("         *** END LOOK HERE ***\n\n");
    }

    else {      

      // Do first NNI for edge

      // This NNI swaps p->next->back and p->back->next->back

      ///* ESA
      printf("  Going to swap clades on current edge...\n");
      printf("     The edge joins node %d and node %d\n",p->number,p->back->number);
      printf("     The clades to be swapped are %d and %d\n",p->next->back->number,p->back->next->back->number);
      printf("     The score for this edge is %f and %f\n",p->score,p->back->score);
      //*/

      printf("Before swap:  p->next->: score is %f ndesc is %d  number is %d\n", p->next->score, p->next->ndesc, p->next->number);
      printf("        p->back->next->: score is %f ndesc is %d  number is %d\n", p->back->next->score, p->back->next->ndesc, p->back->next->number);

      swap_cladesNNI(p->next,p->back->next);

      /* Now reassign score, split_taxa, and ndesc to the two nodes determining the edge under scrutiny    */

      /* The two nodes that require updating are p and p->back */
      /* This function call will update both nodes.            */
      updateNodes(p);

      printf("After swap:   p->next->: score is %f ndesc is %d  number is %d\n", p->next->score, p->next->ndesc, p->next->number);
      printf("        p->back->next->: score is %f ndesc is %d  number is %d\n", p->back->next->score, p->back->next->ndesc, p->back->next->number);

      //     curtree.likelihood=getLik(curtree.nodep[0]->back); ----- LSK commented out - call localLik function instead??
      //printf("Now use Brent's method (as implemented in GSL) to optimize lengths in tree without using derivatives:\n\n");
      OptTree();
      curtree.likelihood=getLik(curtree.nodep[0]->back);
      //printf("The log-likelihood after optimizing tree %d is %f\n\n",NNIcount,curtree.likelihood);
      //Can't get rid of these likelihood calls when trying all NNIs because we need to optimize each tree

      outtree = fopen("NNItrees.tre","a");
      // printf("curtree.start->back->number is %d and curtree.start->number is %d\n",curtree.start->back->number, curtree.start->number);
      treeoutScores(curtree.start->back);
      fclose(outtree);

      /*       // This is not working. */
      /*       if (curtree.start->back->tip) { */
      /* 	printf("curtree.start->number is %d argument to treeoutScores\n", curtree.start->number); */
      /* 	treeoutScores(curtree.start); */
      /*       } */
      /*       else */
      /* 	treeoutScores(curtree.start->back); */
      /*       fclose(outtree); */

      outtree = fopen("NNIlikelihoods","a");
      fprintf(outtree,"\nThe likelihood after optimizing tree %d is %f\n",NNIcount,curtree.likelihood);
      fclose(outtree);

      NNIcount++;

      // return to original tree
      swap_cladesNNI(p->next,p->back->next);

      //When returning to original tree, it will be best to just replace the current branch lengths with the old branch lengths
      //to avoid doing the optimization again - START HERE - then will just need to recompute likelihood (in all directions)

      /* Now reassign score, split_taxa, and ndesc to the two nodes determining the edge under scrutiny    */

      /* The two nodes that require updating are p and p->back */
      /* This function call will update both nodes.            */
      updateNodes(p); 


      // Do second NNI for edge

      //  This NNI swaps p->next->back and p->back->next->next->back

      printf("\n");
      printf("  Going to swap clades on current edge...\n");
      printf("     The edge joins node %d and node %d\n",p->number,p->back->number);
      printf("     The clades to be swapped are %d and %d\n",p->next->back->number,p->back->next->next->back->number);
      printf("     The score for this edge is %f and %f\n",p->score,p->back->score);

      printf("Before swap:  p->next->: score is %f ndesc is %d  number is %d\n", p->next->score, p->next->ndesc, p->next->number);
      printf("        p->back->next->next->: score is %f ndesc is %d  number is %d\n", p->back->next->next->score, p->back->next->next->ndesc, p->back->next->next->number);

      swap_cladesNNI(p->next,p->back->next->next);

      /* Now reassign score, split_taxa, and ndesc to the two nodes determining the edge under scrutiny    */

      /* The two nodes that require updating are p and p->back */
      /* This function call will update both nodes.            */
      updateNodes(p);

      curtree.likelihood=getLik(curtree.nodep[0]->back);
      //printf("Now use Brent's method (as implemented in GSL) to optimize lengths in tree without using derivatives:\n\n");
      OptTree();
      curtree.likelihood=getLik(curtree.nodep[0]->back);
      //printf("The log-likelihood after optimizing tree %d is %f\n\n",NNIcount,curtree.likelihood);

      outtree = fopen("NNItrees.tre","a");
      // printf("curtree.start->back->number is %d and curtree.start->number is %d\n",curtree.start->back->number, curtree.start->number);
      treeoutScores(curtree.start->back);
      fclose(outtree);

      /*       // This is not working. */
      /*       if (curtree.start->back->tip) { */
      /* 	printf("curtree.start->number is %d argument to treeoutScores\n", curtree.start->number); */
      /* 	treeoutScores(curtree.start); */
      /*       } */
      /*       else */
      /* 	treeoutScores(curtree.start->back); */
      /*       fclose(outtree); */

      outtree = fopen("NNIlikelihoods","a");
      fprintf(outtree,"\nThe likelihood after optimizing tree %d is %f\n",NNIcount,curtree.likelihood);
      fclose(outtree);

      NNIcount++;

      //printf("Before swap back:  p->next->score is %f and p->back->next->next->score is %f\n", p->next->score, p->back->next->next->score);

      // return to original tree
      swap_cladesNNI(p->next,p->back->next->next);

      /* After swap_cladesNNI it is necessary to reassign the scores to p->next and p->back->next->next
	 that were involved in the swap.                                                              */
      p->next->score = p->next->back->score;
      p->back->next->next->score = p->back->next->next->back->score;
      //printf("After swap back:   p->next->score is %f and p->back->next->next->score is %f\n", p->next->score, p->back->next->next->score);

      /* Now reassign score, split_taxa, and ndesc to the two nodes determining the edge under scrutiny    */

      /* The two nodes that require updating are p and p->back */
      /* This function call will update both nodes.            */
      updateNodes(p);

    }

    traverseNNI(p->next->back);
    traverseNNI(p->next->next->back);

  }
}  /* traverseNNI */
