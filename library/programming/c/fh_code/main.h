#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <memory.h>
#include <assert.h>
#include <sys/resource.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_eigen.h>

#define FTOL 0.001

typedef char naym[11];

typedef struct {
  FILE *infile, *splits, *flat, *settings;
}FILESPEC;


/* structure to store tree nodes - from PHYLIP */
typedef struct node {
  struct node *next, *back;
  int tip, iter;
  short number;
  double v;
  double **lik;
  int **MPRSet;    //LSK
  int **MPR;       //LSK
  int ndesc;       //LSK
  unsigned int *split_taxa;
  double score;    //ESA
  naym nayme;
  /*phenotype x;*/
  short xcoord, ycoord, ymin, ymax;
} node;

typedef struct tree {
  node **nodep;
  double likelihood;
  node *start;
} tree;


//LSK - added structure to store linked list of trees

struct Node4Trees {
  tree *iTree;
  int first_hit;
  int first_anneal;
  double max_lik;
  int times_hit;
  struct Node4Trees *Next;
};

typedef struct Node4Trees *Link;

extern Link Head, currenttree;

//End LSK added structures



extern int nsite, nseq, num_unique, print_data_ind, print_data_phylip, include_gaps;
extern int **ppBase, **ppBase_unique, *site_counter;
extern naym *psname;
extern double **ppDistMat;
extern double fnorm;
extern FILE *tf;
extern FILE *outtree;

extern int lngths;
extern double fracchange;

extern double pi_A, pi_G, pi_C, pi_T, Avg_pi, Var_pi, Cov_pi;
extern double pi_a, pi_g, pi_c, pi_t;
extern double pi_R, pi_Y, pi_r, pi_y, Purines, Pyrimid;
extern double inv_pi_r1, inv_pi_y1;
extern double pi_a_r, pi_g_r, pi_c_y, pi_t_y;
extern double pi_a_r1, pi_g_r1, pi_c_y1, pi_t_y1;
extern double mu, tratio; 

extern double pp[4][4];
extern double Q[4][4];
extern double S[4][4];
extern double T[4][4];
extern double lam0, lam1, lam2, lam3;
extern double K;
extern double rAC, rAG, rAT, rCG, rCT, rGT;

extern tree curtree;
extern int nints,nfit,num_unique_bin;
extern unsigned int **ppBase_u_bin, *counts, *split_taxaR, *split_taxaC;

extern int FileSpecInit(FILESPEC *pFileSpec);
extern int MemAlloc();
extern naym* InputInit(FILESPEC *pFileSpec);
extern void trans_probGTR(double t, double ppt[4][4]);

extern double timediff (struct rusage *rstart, struct rusage *rend);

// function prototypes (not a complete list)
extern double localLik(node *q);  //LSK
extern double getLik(node *q);
extern double getLikNode(double len, void *qq); //LSK
extern void InitNodeLiks();
extern void trbldg(int version);
extern void heapSort(double numbers[], node *vertices[], int array_size);
extern void siftDown(double numbers[], node *vertices[], int root, int bottom);


// ESA other global variables
//     still need counteres for now
extern int ctr;
extern int ctr_small;
// below is temporary
extern int NNIcount;

// scores:        array of doubles with scores
// node_scores:   array of pointers to nodes with scores saved in array scores

// ESA for large split sizes
extern double *scores;
extern node **scores_node;

// ESA for small split sizes
extern double *scores_small;
extern node **scores_node_small;

// ESA I couldn't get this macro to work so just defined a global constant
// #define SMALL_SPLIT_SIZE 5;
extern const int SMALL_SPLIT_SIZE;

