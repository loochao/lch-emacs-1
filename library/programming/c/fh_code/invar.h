#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <memory.h>
#include <assert.h>

typedef char naym[11];

typedef struct {
  FILE *infile, *splits, *flat;
}FILESPEC;

extern int nsite, nseq, num_unique, print_data_ind, print_data_phylip, include_gaps;
extern int **ppBase, **ppBase_unique, *site_counter;
extern naym *psname;
extern double **ppDistMat;
extern double fnorm;

extern int FileSpecInit(FILESPEC *pFileSpec);
extern int MemAlloc();
extern naym* InputInit(FILESPEC *pFileSpec);

extern int nints, nfit;
extern unsigned int **ppBase_u_bin, *counts, *split_taxaR, *split_taxaC;




