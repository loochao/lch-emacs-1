#include "main.h"
#include <gsl/gsl_errno.h>
#include <gsl/gsl_math.h>
#include <gsl/gsl_min.h>

#define GSL_FN_EVAL(F,x) (*((F)->function))(x,(F)->params)


/*** Get approximate branch lengths using Rogers-Swofford Algorithm ***/
/*** Syst. Biol. 47(1): 77-89, 1998                                 ***/

/*** To get approximate branch lengths, run: (1) traverseMPRSet;   ***/
/*** (2) traverseMPR; and then (3) traverseMPRlens.                ***/



/*** This version of traverse fills a 4D vector at each node with  ***/
/*** 1s and 0s corresponding to bases which are in *some* MPR Set  ***/

void traverseMPRSet(node *p)
{

  int j, k, i;

  if (p->tip) {
    //printf("Tip number %d  \n",p->number);
    //printf("MPRSet at site %d is %d %d %d %d\n\n",10,p->MPRSet[10][0],p->MPRSet[10][1],p->MPRSet[10][2],p->MPRSet[10][3]);
  }
  else {
    //printf("Node number %2d\n",p->number);
    // printf("   Node->back number %2d \n",p->back->number);
    traverseMPRSet(p->next->back);
    traverseMPRSet(p->next->next->back);

    for (j=0; j<num_unique; j++) {
      for (k=0; k<4; k++) {
	p->MPRSet[j][k] = p->next->back->MPRSet[j][k]*p->next->next->back->MPRSet[j][k];
	p->next->MPRSet[j][k] =  p->next->back->MPRSet[j][k]*p->next->next->back->MPRSet[j][k];
	p->next->next->MPRSet[j][k] =  p->next->back->MPRSet[j][k]*p->next->next->back->MPRSet[j][k];
      }
      if (p->MPRSet[j][0] + p->MPRSet[j][1] + p->MPRSet[j][2] + p->MPRSet[j][3] == 0) {
	for (k=0; k<4; k++) {
	  p->MPRSet[j][k] = p->next->back->MPRSet[j][k] + p->next->next->back->MPRSet[j][k];
	  p->next->MPRSet[j][k] = p->next->back->MPRSet[j][k] + p->next->next->back->MPRSet[j][k];
	  p->next->next->MPRSet[j][k] = p->next->back->MPRSet[j][k] + p->next->next->back->MPRSet[j][k];
	}
	/*increase length by one*/
      }
    }

    //printf("For node %d with descendants %d and %d and site %d, MPRSet is %d %d %d %d\n\n",p->number,p->next->back->number,p->next->next->back->number,10,p->MPRSet[10][0],p->MPRSet[10][1],p->MPRSet[10][2],p->MPRSet[10][3]);


  }
}  /* traverseMPRSet */


/*** This function does a pre-order traversal to find a single MPR.   ***/

void traverseMPR(node *p)
{
  
  int j;

  //printf("     in traverse - called for node %d with parent %d, parent MPR is %d %d %d %d\n",p->number,p->back->number,p->back->MPRSet[10][0],p->back->MPRSet[10][1],p->back->MPRSet[10][2],p->back->MPRSet[10][3]);
  
  if (p->tip) {

    //printf("      Tip number %d  \n\n",p->number);
  }
  else {

     for (j=0; j<num_unique; j++) {

      if ((p->MPRSet[j][0]==1) && (p->back->MPRSet[j][0]==1)) {
	p->MPRSet[j][1] = p->MPRSet[j][2] = p->MPRSet[j][3] = 0;
        p->next->MPRSet[j][1] = p->next->MPRSet[j][2] = p->next->MPRSet[j][3] = 0;
	p->next->next->MPRSet[j][1] = p->next->next->MPRSet[j][2] = p->next->next->MPRSet[j][3] = 0;
      }
      else if ((p->MPRSet[j][1]==1) && (p->back->MPRSet[j][1]==1)) {
	p->MPRSet[j][0] = p->MPRSet[j][2] = p->MPRSet[j][3] = 0;
	p->next->MPRSet[j][0] = p->next->MPRSet[j][2] = p->next->MPRSet[j][3] = 0;
	p->next->next->MPRSet[j][0] = p->next->next->MPRSet[j][2] = p->next->next->MPRSet[j][3] = 0;
      }
      else if ((p->MPRSet[j][2]==1) && (p->back->MPRSet[j][2]==1)) {
	p->MPRSet[j][0] = p->MPRSet[j][1] = p->MPRSet[j][3] = 0;
	p->next->MPRSet[j][0] = p->next->MPRSet[j][1] = p->next->MPRSet[j][3] = 0;
	p->next->next->MPRSet[j][0] = p->next->next->MPRSet[j][1] = p->next->next->MPRSet[j][3] = 0;
      }
      else if ((p->MPRSet[j][3]==1) && (p->back->MPRSet[j][3]==1)) {
	p->MPRSet[j][0] = p->MPRSet[j][1] = p->MPRSet[j][2] = 0;
	p->next->MPRSet[j][0] = p->next->MPRSet[j][1] = p->next->MPRSet[j][2] = 0;
	p->next->next->MPRSet[j][0] = p->next->next->MPRSet[j][1] = p->next->next->MPRSet[j][2] = 0;
      }
      else {
	if (p->MPRSet[j][0] == 1) {
	  p->MPRSet[j][1] = p->MPRSet[j][2] = p->MPRSet[j][3] = 0;
	  p->next->MPRSet[j][1] = p->next->MPRSet[j][2] = p->next->MPRSet[j][3] = 0;
	  p->next->next->MPRSet[j][1] = p->next->next->MPRSet[j][2] = p->next->next->MPRSet[j][3] = 0;
	}
	else if (p->MPRSet[j][1] == 1) {
	  p->MPRSet[j][0] = p->MPRSet[j][2] = p->MPRSet[j][3] = 0;
	  p->next->MPRSet[j][0] = p->next->MPRSet[j][2] = p->next->MPRSet[j][3] = 0;
	  p->next->next->MPRSet[j][0] = p->next->next->MPRSet[j][2] = p->next->next->MPRSet[j][3] = 0;
	}
	else if (p->MPRSet[j][2] == 1) {
	  p->MPRSet[j][0] = p->MPRSet[j][1] = p->MPRSet[j][3] = 0;
	  p->next->MPRSet[j][0] = p->next->MPRSet[j][1] = p->next->MPRSet[j][3] = 0;
	  p->next->next->MPRSet[j][0] = p->next->next->MPRSet[j][1] = p->next->next->MPRSet[j][3] = 0;
	}
	else {
	  p->MPRSet[j][0] = p->MPRSet[j][1] = p->MPRSet[j][2] = 0;
	  p->next->MPRSet[j][0] = p->next->MPRSet[j][1] = p->next->MPRSet[j][2] = 0;
	  p->next->next->MPRSet[j][0] = p->next->next->MPRSet[j][1] = p->next->next->MPRSet[j][2] = 0;
	}
      }
    }

     //printf("     2 - For node %d with parent %d and descendants %d and %d and site %d, MPRSet is %d %d %d %d\n\n",p->number,p->back->number,p->next->back->number,p->next->next->back->number,10,p->MPRSet[10][0],p->MPRSet[10][1],p->MPRSet[10][2],p->MPRSet[10][3]);

    traverseMPR(p->next->back);
    traverseMPR(p->next->next->back);

  }

}




/*** This function computes branch lengths based on the MPR just found. ***/

void traverseMPRlens(node *p,int mod)
{

  int i, j, k, m;
  int brlen;
  int transitions=0, transversions=0;
  double ts, tv;
  double A, B, C;
  
  if (mod<=3) {
    A = pi_c*pi_t/pi_y + pi_a*pi_g/pi_r;
    B = pi_c*pi_t + pi_a*pi_g;
    C = pi_r*pi_y;
  }


  if (p->tip) {

    for (j=0; j<num_unique; j++) {

      if (p->MPRSet[j][0]*p->back->MPRSet[j][1] == 1) transitions = transitions+1;
      if (p->MPRSet[j][1]*p->back->MPRSet[j][0] == 1) transitions = transitions+1;
      if (p->MPRSet[j][2]*p->back->MPRSet[j][3] == 1) transitions = transitions+1;
      if (p->MPRSet[j][3]*p->back->MPRSet[j][2] == 1) transitions = transitions+1;

      if (p->MPRSet[j][0]*p->back->MPRSet[j][2] == 1) transversions = transversions+1;
      if (p->MPRSet[j][2]*p->back->MPRSet[j][0] == 1) transversions = transversions+1;
      if (p->MPRSet[j][0]*p->back->MPRSet[j][3] == 1) transversions = transversions+1;
      if (p->MPRSet[j][3]*p->back->MPRSet[j][0] == 1) transversions = transversions+1;
      if (p->MPRSet[j][1]*p->back->MPRSet[j][2] == 1) transversions = transversions+1;
      if (p->MPRSet[j][2]*p->back->MPRSet[j][1] == 1) transversions = transversions+1;
      if (p->MPRSet[j][1]*p->back->MPRSet[j][3] == 1) transversions = transversions+1;
      if (p->MPRSet[j][3]*p->back->MPRSet[j][1] == 1) transversions = transversions+1;

    }

    //printf("For tip %d,",p->number);

    brlen = transitions + transversions;
    ts = (double)transitions/(double)nsite;
    tv = (double)transversions/(double)nsite;

    if (mod<=3) p->v = p->back->v = -2.0*A*log(1.0-(ts/(2.0*A))-((A-B)*tv/(2.0*A*C)))+2.0*(A-B-C)*log(1.0-tv/(2.0*C));
    else if (mod==5) p->v = p->back->v = (-3.0/4.0)*log(1.0-(4.0/3.0)*((double)brlen/(double)nsite));
    else if (mod>=4) p->v = p->back->v = (1.0/2.0)*log(1.0/(1.0-2.0*ts-tv))+(1.0/4.0)*log(1.0/(1.0-2.0*tv));
    if (p->v <= 0.0) p->v = p->back->v = 0.0001;

    //printf(" Assigned branch length %f\n",p->v);
  }


  else {

    traverseMPRlens(p->next->back,mod);
    traverseMPRlens(p->next->next->back,mod);

    for (j=0; j<num_unique; j++) {

      if (p->MPRSet[j][0]*p->back->MPRSet[j][1] == 1) transitions = transitions+1;
      if (p->MPRSet[j][1]*p->back->MPRSet[j][0] == 1) transitions = transitions+1;
      if (p->MPRSet[j][2]*p->back->MPRSet[j][3] == 1) transitions = transitions+1;
      if (p->MPRSet[j][3]*p->back->MPRSet[j][2] == 1) transitions = transitions+1;

      if (p->MPRSet[j][0]*p->back->MPRSet[j][2] == 1) transversions = transversions+1;
      if (p->MPRSet[j][2]*p->back->MPRSet[j][0] == 1) transversions = transversions+1;
      if (p->MPRSet[j][0]*p->back->MPRSet[j][3] == 1) transversions = transversions+1;
      if (p->MPRSet[j][3]*p->back->MPRSet[j][0] == 1) transversions = transversions+1;
      if (p->MPRSet[j][1]*p->back->MPRSet[j][2] == 1) transversions = transversions+1;
      if (p->MPRSet[j][2]*p->back->MPRSet[j][1] == 1) transversions = transversions+1;
      if (p->MPRSet[j][1]*p->back->MPRSet[j][3] == 1) transversions = transversions+1;
      if (p->MPRSet[j][3]*p->back->MPRSet[j][1] == 1) transversions = transversions+1;

    }

    brlen = transitions + transversions;
    ts = (double)transitions/(double)nsite;
    tv = (double)transversions/(double)nsite;

    if (mod<=3) p->v = p->back->v = -2.0*A*log(1.0-(ts/(2.0*A))-((A-B)*tv/(2.0*A*C)))+2.0*(A-B-C)*log(1.0-tv/(2.0*C));
    else if (mod==5) p->v = p->back->v = (-3.0/4.0)*log(1.0-(4.0/3.0)*((double)brlen/(double)nsite));
    else if (mod>=4) p->v = p->back->v = (1.0/2.0)*log(1.0/(1.0-2.0*ts-tv))+(1.0/4.0)*log(1.0/(1.0-2.0*tv));
    if (p->v <= 0.0) p->v = p->back->v = 0.0001;

    //printf("For branch connecting %d and %d, assigned length %f\n",p->number,p->back->number,p->v);

  }
}  /* traverseMPRlens */



/*** Optimization routines ***/


// For testing purposes, just use a traverse function that evaluates the entire likelihood
// For actual version, only recalculate nodes that need to be updated (only call traverse in one direction)

/*** *params is a pointer to the node to be optimized ***/

struct my_f_params { node q; };

double getLikNode(double len, void *qq) {

  int i, j, jjj, k;
  double outt1=0.0, outt2=0.0, outa=0.0, outg=0.0, outc=0.0, outt=0.0;
  double ppb[4][4];

  struct my_f_params *params = (struct my_f_params *)qq;

  params->q.v = params->q.back->v = len;
  
  trans_probGTR(params->q.back->v,ppb);
  
  for (jjj=0; jjj<num_unique; jjj++) {
    
    /* compute liks along branch to p->back*/
    /* writing out sums rather than looping improves speed*/
    
    outa = params->q.back->lik[jjj][0]*ppb[0][0] + params->q.back->lik[jjj][1]*ppb[0][1] + params->q.back->lik[jjj][2]*ppb[0][2] + params->q.back->lik[jjj][3]*ppb[0][3];
    outg = params->q.back->lik[jjj][0]*ppb[1][0] + params->q.back->lik[jjj][1]*ppb[1][1] + params->q.back->lik[jjj][2]*ppb[1][2] + params->q.back->lik[jjj][3]*ppb[1][3];
    outc = params->q.back->lik[jjj][0]*ppb[2][0] + params->q.back->lik[jjj][1]*ppb[2][1] + params->q.back->lik[jjj][2]*ppb[2][2] + params->q.back->lik[jjj][3]*ppb[2][3];
    outt = params->q.back->lik[jjj][0]*ppb[3][0] + params->q.back->lik[jjj][1]*ppb[3][1] + params->q.back->lik[jjj][2]*ppb[3][2] + params->q.back->lik[jjj][3]*ppb[3][3];
    
    /* now put root at p and compute tree likelihood */
    outt1 = (params->q.lik[jjj][0])*outa*pi_a + (params->q.lik[jjj][1])*outg*pi_g + (params->q.lik[jjj][2])*outc*pi_c + (params->q.lik[jjj][3])*outt*pi_t;


    /* now sum over sites */
    outt2 = outt2 + site_counter[jjj]*log(outt1);
    
  }
  
  //printf("returning %f\n\n",outt2);

  return -outt2;
  
}





void OptNode(node *p) {

  int status;
  int iter = 0, max_iter = 100;
  const gsl_min_fminimizer_type *T;
  gsl_min_fminimizer *s;
  double m, Fm;
  double a, b, Fa, Fb;
  gsl_function F;
  struct my_f_params params = { *p };

  double k;

   int i, j, jjj;
  double outt1=0.0, outt2=0.0, outa=0.0, outg=0.0, outc=0.0, outt=0.0;
  double ppb[4][4];

  // Set up likelihoods on either end of branch to be optimized - should already be done
  //traverseL(p);
  //traverseL(p->back);

  F.function = &getLikNode;
  F.params = &params;

  T = gsl_min_fminimizer_brent;
  s = gsl_min_fminimizer_alloc (T);

  a = 0.00001;
  b = 4.0;
  m = p->v;

  //printf("a is %f and F(a) is %f, b is %f and F(b) is %f, m is %f and F(m) is %f\n",a,GSL_FN_EVAL(&F,a),b,GSL_FN_EVAL(&F,b),m,GSL_FN_EVAL(&F,m));
 
  /** need to make sure that the interval (a,b) brackets a min - so Fm<Fa and Fm<Fb **/
  /** if not satisfied for current length, try a length close to 0                  **/

  Fa = GSL_FN_EVAL(&F,a);
  Fb = GSL_FN_EVAL(&F,b);
  Fm = GSL_FN_EVAL(&F,m);

  if (Fm>Fa || Fm>Fb) {
    m = 0.00011;
    Fm = GSL_FN_EVAL(&F,m);
  }

  if (Fm<Fa && Fm<Fb) {   /** found appropriate min in interval - if not, don't optimize this branch right now **/

    //for (k=a; k<b; k=k+0.01){p->v = k;printf("   %f %f\n",k,getLik(curtree.nodep[0]->back));}
    
    gsl_min_fminimizer_set (s, &F, m, a, b);
    
    status = gsl_min_test_interval (a, b, 0.001, 0.0);
    
    //   printf("   IT LEP         UEP        MIN       WIDTH\n");
    //printf("   -- ----------- ---------- --------- -----------\n");
    
    while (iter<50 && status==GSL_CONTINUE) {
      
      status = gsl_min_fminimizer_iterate (s);
      
      m = gsl_min_fminimizer_x_minimum (s);
      a = gsl_min_fminimizer_x_lower (s);
      b = gsl_min_fminimizer_x_upper (s);
      
      status = gsl_min_test_interval (a, b, 0.000001, 0.0);
      
      //if (status == GSL_SUCCESS) printf ("Converged:\n");
      
      //printf ("%5d [%.7f, %.7f] "
      //"%.7f %.7f\n",
      //    iter, a, b,
      //    m, b - a);
      
      iter++;
      
    }
    
    p->v = m;
    gsl_min_fminimizer_free (s);

  }
    
}



/*** This recursively-called function makes a single pass through the tree, ***/
/*** optimizing nodes one-by-one in a post-order traversal.                 ***/

void traverseOptTree(node *p) {

 int j, k, i;
 double old_pv;

  if (p->tip) {
    //printf("Tip number %d  \n",p->number);
    OptNode(p);
  }
  else {

    traverseOptTree(p->next->back);
    traverseOptTree(p->next->next->back);

    OptNode(p);

  }

}


/*** This function will iterate single passes through the ***/
/*** tree optimizing each branch until convergence.       ***/


//LSK ned to make the tol variables global - also a tol variable in OptNode for branch length precision

void OptTree(){

  int pass_tol=20, npass=0;
  double tol=0.0000001, diff=1.0; //tol = 0.000001
  double curr_lik, new_lik;


  //printf("Pass \t Current Lik \t New Lik \t Difference\n");

  while (diff>tol && npass<pass_tol) {
    
    curr_lik = getLik(curtree.nodep[0]->back);
    traverseOptTree(curtree.nodep[0]->back);
    new_lik = getLik(curtree.nodep[0]->back);
    diff = new_lik-curr_lik;

    //printf("%d \t %f \t %f \t %f\n",npass,curr_lik,new_lik,diff);

    npass++;
    
  }


}
