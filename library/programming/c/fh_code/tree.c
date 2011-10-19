#include "main.h"
#include <gsl/gsl_math.h>
#include <gsl/gsl_eigen.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>

#define false 0
#define true 1

/* Local variables for maketree, propagated globally for c version: */
short k, nextsp, numtrees, which, maxwhich;
double dummy, tdelta, lnlike, slope, curv, maxlogl;
double x[3], lnl[3];
char ch;
short col;

treeoutScores(node *p)
{
  /* write out file with representation of final tree */
  short i, n, w;
  char c;
  double x;

  if (p->tip) {
    n = 0;
    for (i = 1; i <= 11; i++) {
      if (p->nayme[i - 1] != ' ')
	n = i;
    }
    for (i = 0; i < n; i++) {
      c = p->nayme[i];
      if (c == ' ')
	c = '_';
      putc(c, outtree);
    }
    col += n;
  } else {
    putc('(', outtree);
    col++;
    treeoutScores(p->next->back);
    putc(',', outtree);
    col++;
    if (col > 45) {
      putc('\n', outtree);
      col = 0;
    }
    treeoutScores(p->next->next->back);
    if (p == curtree.start->back) {
      putc(',', outtree);
      col++;
      if (col > 45) {
	putc('\n', outtree);
	col = 0;
      }
      treeoutScores(p->back);
    }
    putc(')', outtree);
    col++;
  }
  x = p->v * fracchange;
  if (x > 0.0)
    w = (short)(0.43429448222 * log(x));
  else if (x == 0.0)
    w = 0;
  else
    w = (short)(0.43429448222 * log(-x)) + 1;
  if (w < 0)
    w = 0;
  if (p == curtree.start->back)
    fprintf(outtree, ";\n");
  else {
    fprintf(outtree, ":%*.5f", (int)(w + 7), x);
    col += w + 8;
    // ESA
    // printf("p->score is %f\n",p->score);
    if (p->score > 0) {
      fprintf(outtree,"[");
      fprintf(outtree, "%f", p->score);
      fprintf(outtree,"]");
    }
  }

}  /* treeoutScores */


void setuptree(a)
     tree *a;
{
  short i, j, jj, k, kk;
  node *p;

  for (i = 1; i <= nseq; i++) {
    a->nodep[i - 1]->tip = true;
    a->nodep[i - 1]->iter = true;
    a->nodep[i - 1]->number = i;
    a->nodep[i - 1]->ndesc=1;         //LSK
    a->nodep[i - 1]->score=0.0;       //ESA
    for (k=0; k<11; k++) {
      a->nodep[i - 1]->nayme[k] = psname[i-1][k];
    }
    /* allocate memory for storing conditional likelihoods and MPR Sets*/ // LSK
    a->nodep[i-1]->lik = (double**)malloc((num_unique)*sizeof(double*));
    a->nodep[i-1]->MPRSet = (int**)malloc((num_unique)*sizeof(int*));
    for (j = 0; j < num_unique; j++){
      a->nodep[i - 1]->lik[j] = (double*)malloc(4*sizeof(double));
      a->nodep[i - 1]->MPRSet[j] = (int*)malloc(4*sizeof(int));
      for (k=0; k<4; k++){
	if (k == ppBase_unique[i-1][j]){
	  a->nodep[i - 1]->lik[j][k]=1.0;
	  a->nodep[i - 1]->MPRSet[j][k]=1;
	}
	else {
	  a->nodep[i - 1]->lik[j][k]=0.0;
	  a->nodep[i - 1]->MPRSet[j][k]=0;
	}
      }
      if (ppBase_unique[i-1][j]==5) {
	a->nodep[i-1]->lik[j][0] = a->nodep[i-1]->lik[j][2] = 1.0;
	a->nodep[i-1]->MPRSet[j][0] = a->nodep[i-1]->MPRSet[j][2] = 1;
	a->nodep[i-1]->lik[j][1] = a->nodep[i-1]->lik[j][3] = 0.0;
	a->nodep[i-1]->MPRSet[j][1] = a->nodep[i-1]->MPRSet[j][3] = 0;
      }
      else if (ppBase_unique[i-1][j]==6) {
	a->nodep[i-1]->lik[j][0] = a->nodep[i-1]->lik[j][1] = 1.0;
	a->nodep[i-1]->MPRSet[j][0] = a->nodep[i-1]->MPRSet[j][1] = 1;
	a->nodep[i-1]->lik[j][2] = a->nodep[i-1]->lik[j][3] = 0.0;
	a->nodep[i-1]->MPRSet[j][2] = a->nodep[i-1]->MPRSet[j][3] = 0;
      }
      else if (ppBase_unique[i-1][j]==7) {
	a->nodep[i-1]->lik[j][0] = a->nodep[i-1]->lik[j][3] = 1.0;
	a->nodep[i-1]->MPRSet[j][0] = a->nodep[i-1]->MPRSet[j][3] = 1;
	a->nodep[i-1]->lik[j][1] = a->nodep[i-1]->lik[j][2] = 0.0;
	a->nodep[i-1]->MPRSet[j][1] = a->nodep[i-1]->MPRSet[j][2] = 0;
      }
      else if (ppBase_unique[i-1][j]==8) {
	a->nodep[i-1]->lik[j][1] = a->nodep[i-1]->lik[j][2] = 1.0;
	a->nodep[i-1]->MPRSet[j][1] = a->nodep[i-1]->MPRSet[j][2] = 1;
	a->nodep[i-1]->lik[j][0] = a->nodep[i-1]->lik[j][3] = 0.0;
	a->nodep[i-1]->MPRSet[j][0] = a->nodep[i-1]->MPRSet[j][3] = 0;
      }
      else if (ppBase_unique[i-1][j]==9) {
	a->nodep[i-1]->lik[j][2] = a->nodep[i-1]->lik[j][3] = 1.0;
	a->nodep[i-1]->MPRSet[j][2] = a->nodep[i-1]->MPRSet[j][3] = 1;
	a->nodep[i-1]->lik[j][0] = a->nodep[i-1]->lik[j][1] = 0.0;
	a->nodep[i-1]->MPRSet[j][0] = a->nodep[i-1]->MPRSet[j][1] = 0;
      }
      else if (ppBase_unique[i-1][j]==10) {
	a->nodep[i-1]->lik[j][1] = a->nodep[i-1]->lik[j][3] = 1.0;
	a->nodep[i-1]->MPRSet[j][1] = a->nodep[i-1]->MPRSet[j][3] = 1;
	a->nodep[i-1]->lik[j][0] = a->nodep[i-1]->lik[j][2] = 0.0;
	a->nodep[i-1]->MPRSet[j][0] = a->nodep[i-1]->MPRSet[j][2] = 0;
      }
      else if (ppBase_unique[i-1][j]==11) {
	a->nodep[i-1]->lik[j][1] = a->nodep[i-1]->lik[j][2] = a->nodep[i-1]->lik[j][3] = 1.0;
	a->nodep[i-1]->MPRSet[j][1] = a->nodep[i-1]->MPRSet[j][2] = a->nodep[i-1]->MPRSet[j][3] = 1;
	a->nodep[i-1]->lik[j][0] = 0.0;
	a->nodep[i-1]->MPRSet[j][0] = 0;
      }
      else if (ppBase_unique[i-1][j]==12) {
	a->nodep[i-1]->lik[j][0] = a->nodep[i-1]->lik[j][1] = a->nodep[i-1]->lik[j][3] = 1.0;
	a->nodep[i-1]->MPRSet[j][0] = a->nodep[i-1]->MPRSet[j][1] = a->nodep[i-1]->MPRSet[j][3] = 1;
	a->nodep[i-1]->lik[j][2] = 0.0;
	a->nodep[i-1]->MPRSet[j][2] = 0;
      }
      else if (ppBase_unique[i-1][j]==13) {
	a->nodep[i-1]->lik[j][0] = a->nodep[i-1]->lik[j][2]  = a->nodep[i-1]->lik[j][3] = 1.0;
	a->nodep[i-1]->MPRSet[j][0] = a->nodep[i-1]->MPRSet[j][2]  = a->nodep[i-1]->MPRSet[j][3] = 1;
	a->nodep[i-1]->lik[j][1] = 0.0;
	a->nodep[i-1]->MPRSet[j][1] = 0;
      }
      else if (ppBase_unique[i-1][j]==14) {
	a->nodep[i-1]->lik[j][0] = a->nodep[i-1]->lik[j][1] = a->nodep[i-1]->lik[j][2] = 1.0;
	a->nodep[i-1]->MPRSet[j][0] = a->nodep[i-1]->MPRSet[j][1] = a->nodep[i-1]->MPRSet[j][2] = 1;
	a->nodep[i-1]->lik[j][3] = 0.0;
	a->nodep[i-1]->MPRSet[j][3] = 0;
      }
      else if (ppBase_unique[i-1][j]==15) {
	a->nodep[i-1]->lik[j][0] = a->nodep[i-1]->lik[j][1] = a->nodep[i-1]->lik[j][2] = a->nodep[i-1]->lik[j][3] = 1.0;
	a->nodep[i-1]->MPRSet[j][0] = a->nodep[i-1]->MPRSet[j][1] = a->nodep[i-1]->MPRSet[j][2] = a->nodep[i-1]->MPRSet[j][3] = 1;
      }
    }

    printf("In setting up tree, assigned node %d name %s\n",
        a->nodep[i - 1]->number,a->nodep[i - 1]->nayme); 

    /* allocate memory for storing splits */
    a->nodep[i-1]->split_taxa = (unsigned int*)malloc((nints)*sizeof(unsigned int));
    for (j=0; j<nints; j++) a->nodep[i-1]->split_taxa[j] = 0;
    kk=(a->nodep[i-1]->number-1)/nfit;
    k=a->nodep[i-1]->number-1-kk*nfit;
    a->nodep[i-1]->split_taxa[kk] ^= (3 << 2*k);/*flip 2 bits for mask for this taxon*/
    // printf("for node %d, split_taxa[%d] is %u\n",a->nodep[i-1]->number,kk,a->nodep[i-1]->split_taxa[kk]);
  }

  for (i = nseq+1; i <= 2*nseq-2; i++) {
    p = a->nodep[i - 1];
    for (j = 1; j <= 3; j++) {
      p->tip = false;
      p->iter = true;
      p->number = i;
      p->ndesc=0;    //LSK
      p->score=0.0;  //ESA

      p->lik = (double **)malloc((num_unique)*sizeof(double *));
      p->MPRSet = (int **)malloc((num_unique)*sizeof(int *));
      for (jj=0; jj<num_unique; jj++) {
	p->lik[jj] = (double *)malloc(4*sizeof(double));
	p->MPRSet[jj] = (int *)malloc(4*sizeof(int));
      }
      p->split_taxa = (unsigned int*)malloc((nints)*sizeof(unsigned int));
      for (k=0; k<nints; k++) p->split_taxa[k] = 0;

      p = p->next;
    }
  }
  a->likelihood = -999999.0;
  a->start = a->nodep[0];
}  /* setuptree */



void hookup(p, q)
     node *p, *q;
{

  //  printf("hooking up %d and %d\n",p->number,q->number);
  p->back = q;
  q->back = p;
}  /* hookup */


int eoln(f)
     FILE *f;
{
  register int ch;

  ch = getc(f);
  if (ch == EOF)
    return 1;
  ungetc(ch, f);
  return (ch == '\n');
}


void getch(char *c)
{
  /* get next nonblank character */
  do {
    if (eoln(tf)) {
      fscanf(tf, "%*[^\n]");
      getc(tf);
    }
    *c = getc(tf);
    if (*c == '\n')
      *c = ' ';
  } while (*c == ' ');
}  /* getch */


void findch(c,lparens,rparens)
     char c;
     short *lparens,*rparens;
{
  /* scan forward until find character c */
  int done;

  done = false;
  while (!(done)) {
    if (c == ',') {
      if (ch == '(' || ch == ')' || ch == ':' ||
	  ch == ';') {
	printf("\nERROR IN USER TREE: UNMATCHED PARENTHESIS");
        printf(" OR MISSING COMMA\n OR NOT TRIFURCATED BASE\n");
	exit(-1);
      } else if (ch == ',')
	done = true;
    } else if (c == ')') {
      if (ch == '(' || ch == ',' || ch == ':' || ch == ';') {
	printf("\nERROR IN USER TREE: UNMATCHED PARENTHESIS OR NOT BIFURCATED NODE\n");
	exit(-1);
      } else if (ch == ')') {
	(*rparens)++;
	if ((*lparens) > 0 && (*lparens) == (*rparens)) {
	  if ((*lparens) == nseq - 2) {
	    getch(&ch);
	    if (ch != ';') {
	      printf("\nERROR IN USER TREE:");
	      printf(" UNMATCHED PARENTHESIS OR MISSING SEMICOLON\n");
	      exit(-1);
	    }
	  }
	}
	done = true;
      }
    }
    if (ch == ')')
      getch(&ch);
  }

}  /* findch */



void processlength(p)
     node *p;
{
  short digit, ordzero;
  double valyew, divisor;
  int pointread;


  ordzero = '0';
  pointread = false;
  valyew = 0.0;
  divisor = 1.0;
  getch(&ch);
  digit = ch - ordzero;
  while ( (unsigned short)digit <=9 || ch == '.') {
    if (ch == '.' )
      pointread = true;
    else {
      valyew = valyew * 10.0 + digit;
      if (pointread)
	divisor *= 10.0;
    }
    getch(&ch);
    digit = ch - ordzero;
  }
  

  if (lngths) {
    
    p->v = valyew / divisor / fracchange;
    p->back->v = p->v;
    p->iter = false;
    p->back->iter = false;
  }

}  /* processlength */


void addelement(p, nextnode,lparens,rparens,names,nolengths)
     node *p;
     short *nextnode,*lparens,*rparens;
     int *names, *nolengths;
{
  node *q;
  short i, n;
  int found;
  char str[11];

  int k;
  
  getch(&ch);

  if (ch == '(') {
    (*lparens)++;
    if ((*lparens) > nseq - 2) {
      printf("\nERROR IN USER TREE: TOO MANY LEFT PARENTHESES\n");
      exit(-1);
    } else {
      (*nextnode)++;
      q = curtree.nodep[(*nextnode) - 1];
      hookup(p, q);
      addelement(q->next,nextnode,lparens,rparens,names,nolengths);
      findch(',',lparens,rparens);
      addelement(q->next->next,nextnode,lparens,rparens,names,nolengths);
      findch(')',lparens,rparens);
    }
  } else {
    for (i = 0; i < 11; i++)
      str[i] = ' ';
    n = 1;
    do {
      if (ch == '_')
	ch = ' ';
      str[n - 1] = ch;
      if (eoln(tf)) {
	fscanf(tf, "%*[^\n]");
	getc(tf);
      }
      ch = getc(tf);
      if (ch == '\n')
	ch = ' ';
      n++;
    } while (ch != ':' && ch != ',' && ch != ')' && n <= 11);
    n = 1;
    do {
      found = true;
      for (i = 0; i < 11; i++)

	{
	  found = (found && str[i] == curtree.nodep[n - 1]->nayme[i]);
	}

      if (found) {
	if (names[n - 1] == false)
	  names[n - 1] = true;
	else {
	  printf("\nERROR IN USER TREE: DUPLICATE NAME FOUND -- ");
	  for (i = 0; i < 11; i++)
	    putchar(curtree.nodep[n - 1]->nayme[i]);
	  putchar('\n');
	  exit(-1);
	}
      } else
	n++;
    } while (!(n > nseq || found));
    if (n > nseq) {
      printf("Cannot find species: ");
      for (i = 0; i < 11; i++)
	putchar(str[i]);
      putchar('\n');
    }

    hookup(curtree.nodep[n - 1], p);
    if (curtree.start->number > n)
      curtree.start = curtree.nodep[n - 1];
  }
  if (ch == ':') {
    processlength(p);
    *nolengths = false;
  }

}  /* addelement */

void treeread()
{
  short nextnode, lparens, rparens;
  int *names, nolengths;
  node *p;
  short i;

  curtree.start = curtree.nodep[nseq - 1];

  getch(&ch);
  if (ch != '(')
    return;
  nextnode = nseq + 1;
  p = curtree.nodep[nextnode - 1];
  names = (int *)malloc(nseq*sizeof(int));
  for (i = 0; i < nseq; i++)
    names[i] = false;
  lparens = 1;
  rparens = 0;
  nolengths = true;
  for (i = 1; i <= 2; i++) {
    addelement(p, &nextnode,&lparens,&rparens,names,&nolengths);
    p = p->next;
    findch(',',&lparens,&rparens);
  }
  addelement(p, &nextnode,&lparens,&rparens,names,&nolengths);
  if (nolengths && lngths)
    printf("\nNO LENGTHS FOUND IN INPUT FILE WITH LENGTH OPTION CHOSEN\n");
  findch(')',&lparens,&rparens);
  fscanf(tf, "%*[^\n]");
  getc(tf);
  free(names);
}  /* treeread */

/*
  void nodeinit(p)
  node *p;
  {
  node *q, *r;
  short i, j;
  base b;

  if (p->tip)
  return;
  q = p->next->back;
  r = p->next->next->back;
  nodeinit(q);
  nodeinit(r);
  for (i = 0; i < endsite; i++) {
  for (j = 0; j < categs; j++) {
  for (b = A; (short)b <= (short)T; b = (base)((short)b + 1))
  p->x[i][j]
  [(short)b - (short)A] = 0.5 * (q->x[i][j][(short)b - (short)A] + r->x[i]
  [j][(short)b - (short)A]);
  }
  }
  if (p->iter)
  p->v = 0.1;
  if (p->back->iter)
  p->back->v = 0.1;
  } (/ /* nodeinit */


void traverse(p)
     node *p;
{

  int k;

  if (p->tip) {
    printf(" Tip %d with name ",p->number);
    for (k=0; k<11; k++) printf("%c",p->nayme[k]);
    printf("\n");
  }

  else {
    printf("Node %d with length %f\n",p->number,p->v);
    traverse(p->next->back);
    traverse(p->next->next->back);
  }
}  /* traverse */


treeout(node *p)
{
  /* write out file with representation of final tree */
  short i, n, w;
  char c;
  double x;

  if (p->tip) {
    n = 0;
    for (i = 1; i <= 11; i++) {
      if (p->nayme[i - 1] != ' ')
	n = i;
    }
    for (i = 0; i < n; i++) {
      c = p->nayme[i];
      if (c == ' ')
	c = '_';
      putc(c, outtree);
    }
    col += n;
  } else {
    putc('(', outtree);
    col++;
    treeout(p->next->back);
    putc(',', outtree);
    col++;
    if (col > 45) {
      putc('\n', outtree);
      col = 0;
    }
    treeout(p->next->next->back);
    if (p == curtree.start->back) {
      putc(',', outtree);
      col++;
      if (col > 45) {
	putc('\n', outtree);
	col = 0;
      }
      treeout(p->back);
    }
    putc(')', outtree);
    col++;
  }
  x = p->v * fracchange;
  if (x > 0.0)
    w = (short)(0.43429448222 * log(x));
  else if (x == 0.0)
    w = 0;
  else
    w = (short)(0.43429448222 * log(-x)) + 1;
  if (w < 0)
    w = 0;
  if (p == curtree.start->back)
    fprintf(outtree, ";\n");
  else {
    fprintf(outtree, ":%*.5f", (int)(w + 7), x);
    col += w + 8;
  }

}  /* treeout */


void traverseL(p)
     node *p;
{

int j, k, i;
double outl=0.0, outr=0.0, ppl[4][4], ppr[4][4]; 

if (p->tip) {
  printf("Tip number %d  \n",p->number);
}
else {
  printf("Node number %d \n",p->number);
traverseL(p->next->back);
traverseL(p->next->next->back);

printf("Assigning liks for node %d with descendants %d and %d\n",p->number,p->next->back->number,p->next->next->back->number);
trans_probGTR(p->next->v,ppl);
trans_probGTR(p->next->next->v,ppr);
     
for (j=0; j<num_unique; j++) {
for (k=0; k<4; k++) {
for (i=0; i<4; i++) {
//printf(" for j=%d, for k=%d and i=%d,ppl is %f, lik is %f\n",j,k,i,ppl[k][i],p->next->back->lik[j][i]);
//printf("                             ppr is %f, lik is %f\n",ppr[k][i],p->next->next->back->lik[j][i]);
outl = outl + ppl[k][i]*p->next->back->lik[j][i];
outr = outr + ppr[k][i]*p->next->next->back->lik[j][i];
}

p->lik[j][k] = outl*outr;

//printf("for j=%d and k=%d, lik is assigned to node %d as %2.20f \t %2.20f \t %2.20f\n",j,k,p->number,p->lik[j][k],p->next->lik[j][k],p->next->next->lik[j][k]);

outl = 0.0;
outr = 0.0;
}
}

}
}  /* traverseL */



// LSK added 22 Apr 08
// Function to compute likelihood assuming that each node already
// contains the correct conditional likelihood (e.g., doesn't traverse)

double localLik(node *q) {

  int mym;
  double myoutt1=0.0, myoutt2=0.0, myouta=0.0, myoutg=0.0, myoutc=0.0, myoutt=0.0;
  double ppb[4][4];

  printf("\t Node is %d with children %d and %d\n",q->number,q->back->number,q->next->back->number);

  trans_probGTR(q->back->v,ppb);

  for (mym=0; mym<num_unique; mym++) {
    
    /* compute liks along branch to q->back*/
    /* writing out sums rather than looping improves speed*/
    
    myouta = q->back->lik[mym][0]*ppb[0][0] + q->back->lik[mym][1]*ppb[0][1] + q->back->lik[mym][2]*ppb[0][2] + q->back->lik[mym][3]*ppb[0][3];
    myoutg = q->back->lik[mym][0]*ppb[1][0] + q->back->lik[mym][1]*ppb[1][1] + q->back->lik[mym][2]*ppb[1][2] + q->back->lik[mym][3]*ppb[1][3];
    myoutc = q->back->lik[mym][0]*ppb[2][0] + q->back->lik[mym][1]*ppb[2][1] + q->back->lik[mym][2]*ppb[2][2] + q->back->lik[mym][3]*ppb[2][3];
    myoutt = q->back->lik[mym][0]*ppb[3][0] + q->back->lik[mym][1]*ppb[3][1] + q->back->lik[mym][2]*ppb[3][2] + q->back->lik[mym][3]*ppb[3][3];
    
    /* now put root at p and compute tree likelihood */
    myoutt1 = (q->lik[mym][0])*myouta*pi_a + (q->lik[mym][1])*myoutg*pi_g + (q->lik[mym][2])*myoutc*pi_c + (q->lik[mym][3])*myoutt*pi_t;
    //printf("for site %d, lik is %f, outs are %f %f %f %f, liks are %f %f %f %f\n",mym,log(myoutt1),log(myouta),log(myoutc),log(myoutg),log(myoutt),log(q->lik[mym][0]),log(q->lik[mym][1]),log(q->lik[mym][2]),log(q->lik[mym][3]));
    
    /* now sum over sites */
    myoutt2 = myoutt2 + site_counter[mym]*log(myoutt1);
    //printf("\t\t cum for site %d is %f %f\n",mym,log(myoutt1),myoutt2);
  }
    
  printf("The log likelihood computed locally is %f\n",myoutt2);
  return myoutt2;
 
}



double getLik(node *q) {

  int i, j, jjj, k, kkk;
  double outt1=0.0, outt2=0.0, outa=0.0, outg=0.0, outc=0.0, outt=0.0;
  double ppb[4][4];
  
  //  double temp1, temp2;
  
  //printf("\n----- starting first traverse ------\n");
  
  traverseL(q);
  
  //printf("\n----- done first traverse ------\n");
  
  traverseL(q->back);
  
  //printf("\n----- done second traverse ------\n\n");
  
  trans_probGTR(q->back->v,ppb);
  
  for (jjj=0; jjj<num_unique; jjj++) {
    
    /* compute liks along branch to p->back*/
    /* writing out sums rather than looping improves speed*/
    
    outa = q->back->lik[jjj][0]*ppb[0][0] + q->back->lik[jjj][1]*ppb[0][1] + q->back->lik[jjj][2]*ppb[0][2] + q->back->lik[jjj][3]*ppb[0][3];
    outg = q->back->lik[jjj][0]*ppb[1][0] + q->back->lik[jjj][1]*ppb[1][1] + q->back->lik[jjj][2]*ppb[1][2] + q->back->lik[jjj][3]*ppb[1][3];
    outc = q->back->lik[jjj][0]*ppb[2][0] + q->back->lik[jjj][1]*ppb[2][1] + q->back->lik[jjj][2]*ppb[2][2] + q->back->lik[jjj][3]*ppb[2][3];
    outt = q->back->lik[jjj][0]*ppb[3][0] + q->back->lik[jjj][1]*ppb[3][1] + q->back->lik[jjj][2]*ppb[3][2] + q->back->lik[jjj][3]*ppb[3][3];
    
    /* now put root at p and compute tree likelihood */
    outt1 = (q->lik[jjj][0])*outa*pi_a + (q->lik[jjj][1])*outg*pi_g + (q->lik[jjj][2])*outc*pi_c + (q->lik[jjj][3])*outt*pi_t;
    // printf("for site %d, lik is %f, outs are %f %f %f %f, liks are %f %f %f %f\n",jjj,log(outt1),log(outa),log(outc),log(outg),log(outt),log(q->lik[jjj][0]),log(q->lik[jjj][1]),log(q->lik[jjj][2]),log(q->lik[jjj][3]));
    
    /* now sum over sites */
    outt2 = outt2 + site_counter[jjj]*log(outt1);
    
  }
  
  printf("The log likelihood using traverse is %f\n",outt2);
  return outt2;
  
}


void InitNodeLiks() {

  int i;

  for (i=nseq; i<2*nseq-2; i++) {

    traverseL(curtree.nodep[i]);
    traverseL(curtree.nodep[i]->next);
    traverseL(curtree.nodep[i]->next->next);
    
  }

}

void unhook(node *p, node *q)
{
  p->back=NULL;
  q->back=NULL;
}


/*************************************/
/*  swap clades:               *******/
/*  swap p->back and q->back   *******/
/*************************************/

void swap_clades(node *p, node *q) 
{
  node *tmp_node;
  //node *r;

  const gsl_rng_type * T;
  gsl_rng * r;

  // ESA
  //printf("\tswap_clades called with ");
  //printf("\tp->number %d and q->number = %d\n",p->number,q->number);
  //printf("  \tp->back->number = %d\n",p->back->number);
  //printf("  \tq->back->number = %d\n\n",q->back->number);
  

  // ESA need to decide what to do about lengths
  // t->nodep[i]->v = 0;

  // LSK - modify lengths of three affected branches
  // OptNode function in optbranch.c will find optimal value of length
  // During search, may not want to set lengths to exact optimum
  // Thus, include option to add randomness to lengths, but using info from optimization

  //printf("\tbefore swap, branch lengths are:\n");
  //printf("\tp->v is %f, p->back->v is %f\n",p->v,p->back->v);
  //printf("\tq->v is %f, q->back->v is %f\n",q->v,q->back->v);
  //printf("\tp->next->next->v is %f, q->next->next->v is %f\n",p->next->next->v,q->next->next->v);
  //printf("\tand likelihood is %f\n",getLik(curtree.nodep[0]->back));

  // ESA temporary check: do not swap clades if p or q is tip

  if (p->tip || q->tip)
    {
      printf("You called swap_clades with a tip!  Oh no!\n");
      printf("  p->number %d p->tip %d and q->number %d q->tip %d\n\n",
                p->number,p->tip,q->number,q->tip);
      printf("       Exiting early .....\n\n");
      exit(1);
    }

  p->back->back = q;
  q->back->back = p;

  tmp_node=p->back; 
  p->back = q->back;
  q->back = tmp_node;


  curtree.likelihood=getLik(curtree.nodep[0]->back);
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
  //printf("\n\tafter swap, branch lengths are:\n");
  //printf("\tp->v is %f, p->back->v is %f\n",p->v,p->back->v);
  //printf("\tq->v is %f, q->back->v is %f\n",q->v,q->back->v);
  //printf("\tp->next->next->v is %f, q->next->next->v is %f\n",p->next->next->v,q->next->next->v);
  //printf("\tand likelihood is %f\n",getLik(curtree.nodep[0]->back));



  /*
  // ESA
  printf("At end of swap_clades: \n");
  printf("  p->back->number = %d\n",p->back->number);
  printf("  p->back->back->number = %d\n\n",p->back->back->number);
  printf("  q->back->number = %d\n",q->back->number);
  printf("  q->back->back->number = %d\n\n",q->back->back->number);

  //  printf("tmp_node->number = %d\n",tmp_node->number);
  */

} /* swap_clades */



// ESA these two functions do not work yet, but have been copied 
// from contml.c because they contain the right framework for copying trees.

/* make a copy of a node */

void copynode(node *c, node *d)
{ 
  // ESA must lookup memcopy

  // *next *back
  //  memcpy(d->view, c->view, totalleles*sizeof(double));
  d->tip = c->tip;
  d->iter = c->iter;
  d->number = c->number;
  d->v = c->v;
  // ESA must figure out how to copy **lik
  //   and nayme
  //  d->nayme = c->nayme;
  d->xcoord = c->xcoord;
  d->ycoord = c->ycoord;
  d->ymin = c->ymin;
  d->ymax = c->ymax;
}  /* copynode */


/* make a copy of tree a to tree b */

/*
void copytree(tree *a, tree *b)
{ 
  long i, j;
  node *p, *q;

  for (i = 0; i < spp; i++) {
    copynode(a->nodep[i], b->nodep[i]);
    if (a->nodep[i]->back) {
      if (a->nodep[i]->back == a->nodep[a->nodep[i]->back->index - 1])
        b->nodep[i]->back = b->nodep[a->nodep[i]->back->index - 1];
      else if (a->nodep[i]->back == a->nodep[a->nodep[i]->back->index - 1]->next)
        b->nodep[i]->back = b->nodep[a->nodep[i]->back->index - 1]->next;
      else
        b->nodep[i]->back = b->nodep[a->nodep[i]->back->index - 1]->next->next;
    }
    else b->nodep[i]->back = NULL;
  }
  for (i = spp; i < nonodes2; i++) {
    p = a->nodep[i];
    q = b->nodep[i];
    for (j = 1; j <= 3; j++) {
      copynode(p, q);
      if (p->back) {
        if (p->back == a->nodep[p->back->index - 1])
          q->back = b->nodep[p->back->index - 1];
        else if (p->back == a->nodep[p->back->index - 1]->next)
          q->back = b->nodep[p->back->index - 1]->next;
        else
          q->back = b->nodep[p->back->index - 1]->next->next;
      }
      else
        q->back = NULL;
      p = p->next;
      q = q->next;
    }
  }
  b->likelihood = a->likelihood;
  b->start = a->start;
} */ /* copytree */













