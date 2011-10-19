#include "main.h"

/********************************************************************/
/***  Functions to compare newly generated trees to the k saved   ***/
/***  and determine whether the newly generated tree has already  ***/
/***  been found.                                                 ***/       
/********************************************************************/



/***  Free memory after added a node  ***/

void FreeNode(Link n) {

  free(n->iTree);
  free(n);

}




/***  Find tree with smallest likelihood in the current      ***/
/***  list of num_saved_trees trees and delete it from list  ***/

int DeleteMin() {

  int location;
  Link curr_min, prev_min;
  struct Node4Trees dummy_min;
  double mini_lik=0.0;

  dummy_min.Next = Head;
  prev_min = &dummy_min;
  curr_min = Head;
  
  /* find tree with minimum likelihood */

  for (;; prev_min=curr_min, curr_min=curr_min->Next) {

    if (curr_min == NULL) break;
    if (curr_min->max_lik < mini_lik) mini_lik = curr_min->max_lik;

  }

  /* loop again, but stop when you find min */

  for (prev_min = NULL, curr_min = Head;  
       curr_min != NULL && curr_min->max_lik != mini_lik;  
       prev_min = curr_min, curr_min = curr_min->Next);

  /* delete tree with minimum likelihood */

  location = curr_min->loc_ppTR;
  if (prev_min != NULL) prev_min->Next = curr_min->Next;
  else  Head = curr_min->Next;
 
  FreeNode(curr_min);
  NodeCount = NodeCount-1;
  if (first_annealing_pass==0) NodeCount2 = NodeCount2-1;

  return location;

}


/***  Add a tree to the linked list of trees that have been  ***/
/***  accepted                                               ***/

Link AddNodeAscend(Link to_add, double new_lik, FILE *res) {

  Link pn, prev, curr;
  struct Node4Trees dummy;
  int i, s;
  int tree_loc, tree_loc2;


  pn = (Link)malloc(sizeof(struct Node));
  if (pn == NULL)
    return 0;
  memcpy(pn,to_add,sizeof(struct Node));

  if (NodeCount>num_saved_trees) tree_loc = DeleteMin();
  else tree_loc = NodeCount;

  if (use_last) tree_loc = last_delete;

  dummy.Next = Head;
  prev = &dummy;
  curr = Head;

  for (;; prev=curr, curr=curr->Next) {

    if (curr == NULL) break;
    i = strcmp(pn->iTree,curr->iTree);
    if (i<=0) break; /* prev should go before curr */

  }

  if (curr && i==0) { /* new tree is the same as one on the list */

    if (NodeCount+1>num_saved_trees) {

      use_last = 1;
      last_delete = tree_loc;

    }

    tree_loc2 = curr->loc_ppTR;
    for (s=0; s<nspecies+1; s++) {

      pppTRS[tree_loc2][0][s] = ppTwoRowS[0][s];
      pppTRS[tree_loc2][1][s] = ppTwoRowS[1][s];
      ppTimeVecS[tree_loc2][s+1] = TimeVecS[s+1];
      ppTimeVecS[tree_loc2][s+nspecies] = TimeVecS[s+nspecies];
    
      }
    
    curr->times_hit++;
    if (curr->times_hit < bound_un) no_last_un = 1;
      
    FreeNode(pn);
    return curr;

  }

  /* otherwise add the new tree to the list */

  if (NodeCount+1>num_saved_trees) use_last=0;

   no_last_un=1;

  pn->first_hit = counteri;
  pn->max_lik = new_lik;
  pn->times_hit=1;
  pn->first_anneal = first_annealing_pass;
  pn->loc_ppTR = tree_loc;

  for (s=0; s<nspecies+1; s++) {

    pppTRS[tree_loc][0][s] = ppTwoRowS[0][s];
    pppTRS[tree_loc][1][s] = ppTwoRowS[1][s];
    ppTimeVecS[tree_loc][s+1] = TimeVecS[s+1];
    ppTimeVecS[tree_loc][s+nspecies] = TimeVecS[s+nspecies];

  }

  prev->Next = pn;
  pn->Next=curr;

  NodeCount++;
  Head = dummy.Next;
  return pn;

}





/***  Create a new linked list  ***/

void CreateList(void) {

  Head = NULL;
  NodeCount = 0;

}





void PrintTiedTrees(FILE *resu) {

  Link pn;
  int i;
  int counter=0, place;
  double best_lik=-99999.0;
  pn = Head;
  FILE *treefile;

  treefile = fopen("treefile.phy","w");

  fprintf(resu,">> The %d trees with the best likelihoods were:\n\n\n",NodeCount);

  /* Find best tree to write it first to treefile.phy */
  for (i=0; i<NodeCount; i++) {
    if (pn->max_lik>best_lik) {
      place = pn->loc_ppTR;
      best_lik = pn->max_lik;
    }
    pn = pn->Next;
  }

  pn = Head;
  for (i=0; i<NodeCount; i++) {
    if (pn->max_lik == best_lik) break;
    pn = pn->Next;
  }

  fprintf(treefile,"%f\t",-1.0*best_lik);
  //now write tree
  fprintf(treefile,";\n");

  pn = Head;

  for (i=0; i<NodeCount; i++) {
    
    if (pn->max_lik>best_lik) {
      place = pn->loc_ppTR;
      best_lik = pn->max_lik;
    }
    
    /* Now print tree info and tree */
    
    fprintf(resu,"Tree Number %d\n\n",i+1);
    fprintf(resu,"First visited at iteration:  %d\n",pn->first_hit);
    fprintf(resu,"Max ln L for tree:  %f\n",pn->max_lik);
    fprintf(resu,"Number of times visited:  %d\n",pn->times_hit);
    fflush(0);
    
    fprintf(treefile,"%f \t",-1.0*(pn->max_lik));
    write_tree_root_saved(nspecies+1,nspecies+1,pn,treefile);
    fprintf(treefile,";\n");
    
    write_tree_root_saved(nspecies+1,nspecies+1,pn,resu);
    fprintf(resu,";\n");
    /*     write_tree_root_saved_nolens(nspecies+1,nspecies+1,pn,res);
	   fprintf(res,";\n\n");
    */
    /*   for (j=1; j<ntaxa+1; j++) {	  
	 for (k=j+1; k<ntaxa+1; k++) {
	 fprintf(res,"%d",pn->iTree[counter]-48);
	 fprintf(res,"%d",pn->iTree[counter+1]-48);
	 fprintf(res,"%d ",pn->iTree[counter+2]-48);
	 counter = counter+3;
	 }
	 fprintf(res,"\n");
	 }*/
    
    counter=0;
    
    fprintf(resu,"\n\n");
    
    pn = pn->Next;
    
  }
  
  /*printf("best tree is %f, stored in %d\n",best_lik,place);*/
  
  /*printf("\n   The ML tree is ");
    write_tree_root_place(nspecies+1,nspecies+1,place,res);
    printf(" with log likelihood %f. See the file 'results' for complete information.\n\n",best_lik);
  */
  fprintf(resu,">> The ML tree has log likelihood %f.\n",best_lik);
  fprintf(resu,"\n\n");
  
  fclose(treefile);
  
}


/***  Reduce the linked list to the k best trees  ***/
/***  after it had been expanded to the 2k best   ***/

void FindBest() {

  while (NodeCount>num_saved_trees/2) DeleteMin();
  num_saved_trees = num_saved_trees/2;

}



