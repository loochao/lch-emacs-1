#include "main.h"


/*** Estimate the frequencies of A,G, C, T in the data ***/
/*** and compute quantities which depend on these.     ***/

void est_pis() {

  int i, j, k;
  int m[5], amb_ind[4];
  double freq[4], tempfreq[4], total, xx, temp;
  double difference;

  for (k=0; k<4; k++) freq[k] = 0.25;
  do {
    for (k=0; k<4; k++) tempfreq[k] = 0.0;
    total = 0.0;
    for (i=0; i<nseq; i++) {
      for (j=0; j<num_unique; j++) {
        temp = 0.0;
        amb_ind[0] = amb_ind[1] = amb_ind[2] = amb_ind[3] = 0;
        if (ppBase_unique[i][j]==0) amb_ind[0] = 1;
        else if (ppBase_unique[i][j]==1) amb_ind[1] = 1;
        else if (ppBase_unique[i][j]==2) amb_ind[2] = 1;
        else if (ppBase_unique[i][j]==3) amb_ind[3] = 1;
        else if (ppBase_unique[i][j]==5) {
	  amb_ind[0] = 1;
	  amb_ind[2] = 1;
	}
	else if (ppBase_unique[i][j]==6) {
	  amb_ind[0] = 1;
	  amb_ind[1] = 1;
	}
	else if (ppBase_unique[i][j]==7) {
	  amb_ind[0] = 1;
	  amb_ind[3] = 1;
	}
	else if (ppBase_unique[i][j]==8) {
	  amb_ind[1] = 1;
	  amb_ind[2] = 1;
	}
	else if (ppBase_unique[i][j]==9) {
	  amb_ind[2] = 1;
	  amb_ind[3] = 1;
	}
	else if (ppBase_unique[i][j]==10) {
	  amb_ind[1] = 1;
	  amb_ind[3] = 1;
	}
	else if (ppBase_unique[i][j]==11) {
	  amb_ind[1] = 1;
	  amb_ind[2] = 1;
	  amb_ind[3] = 1;
	}
	else if (ppBase_unique[i][j]==12) {
	  amb_ind[0] = 1;
	  amb_ind[1] = 1;
	  amb_ind[3] = 1;
	}
	else if (ppBase_unique[i][j]==13) {
	  amb_ind[0] = 1;
	  amb_ind[2] = 1;
	  amb_ind[3] = 1;
	}
	else if (ppBase_unique[i][j]==14) {
	  amb_ind[0] = 1;
	  amb_ind[1] = 1;
	  amb_ind[2] = 1;
	}
	else if (ppBase_unique[i][j]==15 || ppBase_unique[i][j]==4) {
	  amb_ind[0] = 1;
	  amb_ind[1] = 1;
	  amb_ind[2] = 1;
	  amb_ind[3] = 1;
	}
        else {
          printf("error estimating empirical base frequencies\n");
          exit(1);
        }

        for (k=0; k<4; k++) temp += amb_ind[k]*freq[k];
        for (k=0; k<4; k++) {
          xx = (amb_ind[k]*(freq[k]/temp))*site_counter[j];
          tempfreq[k] += xx;
          total += xx;
        }

      }

    }

    difference = 0.0;
    for (k=0; k<4; k++) {
      difference += fabs((tempfreq[k]/total)-freq[k]);
      freq[k] = tempfreq[k]/total;
    }

  }while(difference>FTOL);

  pi_A = freq[0];
  pi_G = freq[1];
  pi_C = freq[2];
  pi_T = freq[3];

  pi_R=pi_A+pi_G;
  pi_Y=pi_C+pi_T;

  if (pi_Y <= 0 || pi_R <= 0)
    {
      printf("There are only pyrimidines or purines in your data");
      printf("\n");
      exit(1);
    }

  Purines=pi_A*pi_G/pi_R;
  Pyrimid=pi_T*pi_C/pi_Y;
  Avg_pi=Purines+Pyrimid;
  Var_pi=Purines/pi_R+Pyrimid/pi_Y;
  Cov_pi=Purines/pi_Y+Pyrimid/pi_R;

  printf("Empirical Base Frequencies:\n\n");
  printf("   A   %lf\n   G   %lf\n   C   %lf\n   T   %lf\n\n",pi_A,pi_G,pi_C,pi_T);


} /* est_pis */




/* GTR model
   Function to compute eigenvalues of Q, matrix S
   of right eigenvectors of Q, and T=inv(S).  The
   global variable lam0, lam1, lam2, lam3, S, and T
   are filled.                                       */

void get_Q(model)
     int model;
{
  // GTR
  double rGC;

  // HKY, F84
  double aa, bb;

  // HKY, K2P
  double kappa;

  // Base encoding:  A = 0  G = 1  C = 2  T = 3

  // Model  1=GTR, 2=HKY, 3=F84, 4=K2P, 5=JC, 6=F81 


  // Estimate base frequencies if model is GTR, HKY, F84, or F81

  if ((model<=3) || (model==6)){
    // est_pis() calculates the empirical frequencies  
    est_pis();
    pi_a = pi_A;
    pi_g = pi_G;
    pi_c = pi_C;
    pi_t = pi_T;
    pi_r = pi_R;
    pi_y = pi_Y;
  }
  else{
    // group-based model with equal base frequencies
    pi_a=0.25;
    pi_g=0.25;
    pi_c=0.25;
    pi_t=0.25;
  }

  switch (model){
  case 1: 

    // GTR
  
    mu = 1.0/(2*
	      (pi_a*pi_c*rAC+pi_a*pi_g*rAG+pi_a*pi_t*rAT+
	       pi_c*pi_g*rCG+pi_c*pi_t*rCT+pi_g*pi_t*rGT));

    printf("The GTR model will be used.\n\n");
    break;

  case 2:

    // HKY

    // tratio has been read from file settings or
    // set to default value of 2.0 as in PAUP* and PHYLIP */

    mu = 1.0/(2.0*pi_r*pi_y*(1.0+tratio));
    aa = tratio*pi_r*pi_y;
    bb = pi_a*pi_g + pi_c*pi_t;
    kappa = aa/bb;

    rAC = 1;
    rAG = kappa;
    rAT = 1;
    rCG = 1;
    rCT = kappa;
    rGT = 1;

    printf("The HKY model will be used.\n");
    printf(" Transition/transversion ratio = %f  (kappa = %f)\n",tratio,kappa);

    break;

  case 3: 

    // F84

    // tratio has been read from file settings or
    // set to default value of 2.0 as in PAUP* and PHYLIP */

    mu = 1.0/(2.0*pi_r*pi_y*(1.0+tratio));
    aa = tratio*pi_r*pi_y - pi_a*pi_g - pi_c*pi_t;
    bb = pi_a*pi_g/pi_r + pi_c*pi_t/pi_y;
    K = aa/bb;

    rAC = 1;
    rAG = (1+K/pi_r);
    rAT = 1;
    rCG = 1;
    rCT = (1+K/pi_y);
    rGT = 1;

    printf("The F84 model will be used.\n");
    printf(" Transition/transversion ratio = %f\n",tratio);
    printf(" Transition/transversion parameter = %f\n\n",K);
    break;

  case 4:

    // K2P

    // tratio has been read from file settings or
    // set to default value of 2.0 as in PAUP* and PHYLIP */

    kappa=2*tratio;
    mu=4/(kappa+2);

    Q[0][0] = -0.25*mu*(kappa+2);
    Q[0][1] = 0.25*mu*kappa;
    Q[0][2] = 0.25*mu;
    Q[0][3] = 0.25*mu;

    Q[1][0] = 0.25*mu*kappa;
    Q[1][1] = -0.25*mu*(kappa+2);
    Q[1][2] = 0.25*mu;
    Q[1][3] = 0.25*mu;

    Q[2][0] = 0.25*mu;
    Q[2][1] = 0.25*mu;
    Q[2][2] = -0.25*mu*(kappa+2);
    Q[2][3] = 0.25*mu*kappa;

    Q[3][0] = 0.25*mu;
    Q[3][1] = 0.25*mu;
    Q[3][2] = 0.25*mu*kappa;
    Q[3][3] = -0.25*mu*(kappa+2);

    printf("The K2P model will be used.\n");
    printf(" Transition/transversion ratio = %f  (kappa = %f)\n",tratio,kappa);

    break;

  case 5:

    // JC

    Q[0][0] = -1.0;
    Q[0][1] = 1.0/3;
    Q[0][2] = 1.0/3;
    Q[0][3] = 1.0/3;

    Q[1][0] = 1.0/3;
    Q[1][1] = -1.0;
    Q[1][2] = 1.0/3;
    Q[1][3] = 1.0/3;

    Q[2][0] = 1.0/3;
    Q[2][1] = 1.0/3;
    Q[2][2] = -1.0;
    Q[2][3] = 1.0/3;

    Q[3][0] = 1.0/3;
    Q[3][1] = 1.0/3;
    Q[3][2] = 1.0/3;
    Q[3][3] = -1.0;

    printf("The JC model will be used.\n\n");

    break;

  case 6:

    // F81

    mu = 1.0/(2.0*(pi_a*pi_g+pi_a*pi_c+pi_a*pi_t+pi_g*pi_c+pi_g*pi_t+pi_c*pi_t));

    Q[0][0] = -pi_g*mu - pi_c*mu - pi_t*mu;
    Q[0][1] = pi_g*mu;
    Q[0][2] = pi_c*mu; 
    Q[0][3] = pi_t*mu;

    Q[1][0] = pi_a*mu;
    Q[1][1] = -pi_a*mu - pi_c*mu - pi_t*mu;
    Q[1][2] = pi_c*mu; 
    Q[1][3] = pi_t*mu;

    Q[2][0] = pi_a*mu;
    Q[2][1] = pi_g*mu;
    Q[2][2] = -pi_a*mu - pi_g*mu - pi_t*mu;
    Q[2][3] = pi_t*mu;

    Q[3][0] = pi_a*mu;
    Q[3][1] = pi_g*mu;
    Q[3][2] = pi_c*mu;
    Q[3][3] = -pi_a*mu - pi_g*mu - pi_c*mu;

    printf("The F81 model will be used.\n\n");

    break;

  default:
    printf("Error in model specification.  Exiting.\n\n");
    exit(1);
    break;
  }

  // fill the Q matrix if GTR, HKY, or F84 selected.
  if (model<=3){
 
    // reorder from PAUP order
    rGC=rCG;

    Q[0][0] = mu*(-pi_g*rAG - pi_c*rAC - pi_t*rAT);
    Q[0][1] = mu*(pi_g*rAG);
    Q[0][2] = mu*(pi_c*rAC); 
    Q[0][3] = mu*(pi_t*rAT);

    Q[1][0] = mu*(pi_a*rAG);
    Q[1][1] = mu*(-pi_a*rAG - pi_c*rGC - pi_t*rGT);
    Q[1][2] = mu*(pi_c*rGC); 
    Q[1][3] = mu*(pi_t*rGT);

    Q[2][0] = mu*(pi_a*rAC);
    Q[2][1] = mu*(pi_g*rGC);
    Q[2][2] = mu*(-pi_a*rAC - pi_g*rGC - pi_t*rCT);
    Q[2][3] = mu*(pi_t*rCT);

    Q[3][0] = mu*(pi_a*rAT);
    Q[3][1] = mu*(pi_g*rGT);
    Q[3][2] = mu*(pi_c*rCT);
    Q[3][3] = mu*(-pi_a*rAT - pi_g*rGT - pi_c*rCT);

  }

} /* get_Q */


void get_eigs_S_T(){

  // define constant for accuracy of zero eigenvalue  
  const double ZERO_EIGEN_ACC = 10e-12;

  // define variables for sqrt(base frequency)
  double sqrt_pi_a=sqrt(pi_a), sqrt_pi_g=sqrt(pi_g);
  double sqrt_pi_c=sqrt(pi_c), sqrt_pi_t=sqrt(pi_t);

  /* Define symmetric matrix diag(PI)^(1/2)*Q*diag(PI)^(-1/2)
     for finding eigenvalues since eigen routines more stable
     on symmetric matrices.                                   */

  // Allocate memory for eigenvalue/vector computations
  gsl_matrix * pQp = gsl_matrix_alloc (4,4);
  gsl_vector *eval = gsl_vector_alloc (4);
  gsl_matrix *evec = gsl_matrix_alloc (4,4);
  gsl_eigen_symmv_workspace * w = gsl_eigen_symmv_alloc (4);

  // pQp = diag(PI)^(1/2)*Q*diag(PI)^(-1/2)
  gsl_matrix_set(pQp,0,0,Q[0][0] );
  gsl_matrix_set(pQp,0,1,sqrt_pi_a*Q[0][1]/sqrt_pi_g);
  gsl_matrix_set(pQp,0,2,sqrt_pi_a*Q[0][2]/sqrt_pi_c);
  gsl_matrix_set(pQp,0,3,sqrt_pi_a*Q[0][3]/sqrt_pi_t);

  gsl_matrix_set(pQp,1,0,sqrt_pi_g*Q[1][0]/sqrt_pi_a);
  gsl_matrix_set(pQp,1,1,Q[1][1]);
  gsl_matrix_set(pQp,1,2,sqrt_pi_g*Q[1][2]/sqrt_pi_c);
  gsl_matrix_set(pQp,1,3,sqrt_pi_g*Q[1][3]/sqrt_pi_t);

  gsl_matrix_set(pQp,2,0,sqrt_pi_c*Q[2][0]/sqrt_pi_a);
  gsl_matrix_set(pQp,2,1,sqrt_pi_c*Q[2][1]/sqrt_pi_g);
  gsl_matrix_set(pQp,2,2,Q[2][2]);
  gsl_matrix_set(pQp,2,3,sqrt_pi_c*Q[2][3]/sqrt_pi_t);

  gsl_matrix_set(pQp,3,0,sqrt_pi_t*Q[3][0]/sqrt_pi_a);
  gsl_matrix_set(pQp,3,1,sqrt_pi_t*Q[3][1]/sqrt_pi_g);
  gsl_matrix_set(pQp,3,2,sqrt_pi_t*Q[3][2]/sqrt_pi_c);
  gsl_matrix_set(pQp,3,3,Q[3][3]);
       
  gsl_eigen_symmv (pQp, eval, evec, w);
     
  gsl_eigen_symmv_free (w);
     
  gsl_eigen_symmv_sort (eval, evec, GSL_EIGEN_SORT_ABS_ASC);
 
  lam0 = gsl_vector_get (eval, 0);
  lam1 = gsl_vector_get (eval, 1);
  lam2 = gsl_vector_get (eval, 2);
  lam3 = gsl_vector_get (eval, 3);

  if ( (lam0 < ZERO_EIGEN_ACC) && (lam0 > -ZERO_EIGEN_ACC) )
    lam0 = 0;
  else 
    printf("ERROR: The smallest eigenvalue is not zero.");

  /* Let U = evec, the matrix of eigenvectors of pQp, 
     then the matrices S and T=inv(S) are:
  
     S = right eigenvectors of Q = diag(PI)^(-1/2)*U
     T = inv(S) = U^T*diag(PI)^(1/2)                       */

  S[0][0] = gsl_matrix_get(evec,0,0)/sqrt_pi_a;
  S[0][1] = gsl_matrix_get(evec,0,1)/sqrt_pi_a;
  S[0][2] = gsl_matrix_get(evec,0,2)/sqrt_pi_a;
  S[0][3] = gsl_matrix_get(evec,0,3)/sqrt_pi_a;
  S[1][0] = gsl_matrix_get(evec,1,0)/sqrt_pi_g;
  S[1][1] = gsl_matrix_get(evec,1,1)/sqrt_pi_g;
  S[1][2] = gsl_matrix_get(evec,1,2)/sqrt_pi_g;
  S[1][3] = gsl_matrix_get(evec,1,3)/sqrt_pi_g;
  S[2][0] = gsl_matrix_get(evec,2,0)/sqrt_pi_c;
  S[2][1] = gsl_matrix_get(evec,2,1)/sqrt_pi_c;
  S[2][2] = gsl_matrix_get(evec,2,2)/sqrt_pi_c;
  S[2][3] = gsl_matrix_get(evec,2,3)/sqrt_pi_c;
  S[3][0] = gsl_matrix_get(evec,3,0)/sqrt_pi_t;
  S[3][1] = gsl_matrix_get(evec,3,1)/sqrt_pi_t;
  S[3][2] = gsl_matrix_get(evec,3,2)/sqrt_pi_t;
  S[3][3] = gsl_matrix_get(evec,3,3)/sqrt_pi_t;

  T[0][0] = gsl_matrix_get(evec,0,0)*sqrt_pi_a;
  T[0][1] = gsl_matrix_get(evec,1,0)*sqrt_pi_g;
  T[0][2] = gsl_matrix_get(evec,2,0)*sqrt_pi_c;
  T[0][3] = gsl_matrix_get(evec,3,0)*sqrt_pi_t;
  T[1][0] = gsl_matrix_get(evec,0,1)*sqrt_pi_a;
  T[1][1] = gsl_matrix_get(evec,1,1)*sqrt_pi_g;
  T[1][2] = gsl_matrix_get(evec,2,1)*sqrt_pi_c;
  T[1][3] = gsl_matrix_get(evec,3,1)*sqrt_pi_t;
  T[2][0] = gsl_matrix_get(evec,0,2)*sqrt_pi_a;
  T[2][1] = gsl_matrix_get(evec,1,2)*sqrt_pi_g;
  T[2][2] = gsl_matrix_get(evec,2,2)*sqrt_pi_c;
  T[2][3] = gsl_matrix_get(evec,3,2)*sqrt_pi_t;
  T[3][0] = gsl_matrix_get(evec,0,3)*sqrt_pi_a;
  T[3][1] = gsl_matrix_get(evec,1,3)*sqrt_pi_g;
  T[3][2] = gsl_matrix_get(evec,2,3)*sqrt_pi_c;
  T[3][3] = gsl_matrix_get(evec,3,3)*sqrt_pi_t;

  gsl_matrix_free (pQp);     
  gsl_vector_free (eval);
  gsl_matrix_free (evec);

}   /* get_eigs_S_T() */




void trans_probGTR(double t, double ppt[4][4]) {

  // variables to hold exp(lami*t)
  double exp_lam1_t, exp_lam2_t, exp_lam3_t;

  exp_lam1_t = exp(lam1*t);
  exp_lam2_t = exp(lam2*t);
  exp_lam3_t = exp(lam3*t);

  /*** transition probabilities from A (0) to A, G (1), C (2), T (3) ***/

  ppt[0][0] = 
    S[0][0]*T[0][0] + 
    S[0][1]*exp_lam1_t*T[1][0] + 
    S[0][2]*exp_lam2_t*T[2][0] + 
    S[0][3]*exp_lam3_t*T[3][0];

  ppt[0][1] = 
    S[0][0]*T[0][1] + 
    S[0][1]*exp_lam1_t*T[1][1] + 
    S[0][2]*exp_lam2_t*T[2][1] + 
    S[0][3]*exp_lam3_t*T[3][1];

  ppt[0][2] = 
    S[0][0]*T[0][2] + 
    S[0][1]*exp_lam1_t*T[1][2] + 
    S[0][2]*exp_lam2_t*T[2][2] + 
    S[0][3]*exp_lam3_t*T[3][2];

  ppt[0][3] = 
    S[0][0]*T[0][3] + 
    S[0][1]*exp_lam1_t*T[1][3] + 
    S[0][2]*exp_lam2_t*T[2][3] + 
    S[0][3]*exp_lam3_t*T[3][3];

  /*** transition probabilities from G to A, G, C, T  ***/

  ppt[1][0] = 
    S[1][0]*T[0][0] + 
    S[1][1]*exp_lam1_t*T[1][0] + 
    S[1][2]*exp_lam2_t*T[2][0] + 
    S[1][3]*exp_lam3_t*T[3][0];

  ppt[1][1] = 
    S[1][0]*T[0][1] + 
    S[1][1]*exp_lam1_t*T[1][1] + 
    S[1][2]*exp_lam2_t*T[2][1] + 
    S[1][3]*exp_lam3_t*T[3][1];

  ppt[1][2] = 
    S[1][0]*T[0][2] + 
    S[1][1]*exp_lam1_t*T[1][2] + 
    S[1][2]*exp_lam2_t*T[2][2] + 
    S[1][3]*exp_lam3_t*T[3][2];

  ppt[1][3] = 
    S[1][0]*T[0][3] + 
    S[1][1]*exp_lam1_t*T[1][3] + 
    S[1][2]*exp_lam2_t*T[2][3] + 
    S[1][3]*exp_lam3_t*T[3][3];

  /*** transition probabilities from C to A, G, C, T  ***/

  ppt[2][0] = 
    S[2][0]*T[0][0] + 
    S[2][1]*exp_lam1_t*T[1][0] + 
    S[2][2]*exp_lam2_t*T[2][0] + 
    S[2][3]*exp_lam3_t*T[3][0];

  ppt[2][1] = 
    S[2][0]*T[0][1] + 
    S[2][1]*exp_lam1_t*T[1][1] + 
    S[2][2]*exp_lam2_t*T[2][1] + 
    S[2][3]*exp_lam3_t*T[3][1];

  ppt[2][2] = 
    S[2][0]*T[0][2] + 
    S[2][1]*exp_lam1_t*T[1][2] + 
    S[2][2]*exp_lam2_t*T[2][2] + 
    S[2][3]*exp_lam3_t*T[3][2];

  ppt[2][3] = 
    S[2][0]*T[0][3] + 
    S[2][1]*exp_lam1_t*T[1][3] + 
    S[2][2]*exp_lam2_t*T[2][3] + 
    S[2][3]*exp_lam3_t*T[3][3];

  /*** transition probabilities from T to A, C, G, T  ***/

  ppt[3][0] = 
    S[3][0]*T[0][0] + 
    S[3][1]*exp_lam1_t*T[1][0] + 
    S[3][2]*exp_lam2_t*T[2][0] + 
    S[3][3]*exp_lam3_t*T[3][0];

  ppt[3][1] = 
    S[3][0]*T[0][1] + 
    S[3][1]*exp_lam1_t*T[1][1] + 
    S[3][2]*exp_lam2_t*T[2][1] + 
    S[3][3]*exp_lam3_t*T[3][1];

  ppt[3][2] = 
    S[3][0]*T[0][2] + 
    S[3][1]*exp_lam1_t*T[1][2] + 
    S[3][2]*exp_lam2_t*T[2][2] + 
    S[3][3]*exp_lam3_t*T[3][2];

  ppt[3][3] = 
    S[3][0]*T[0][3] + 
    S[3][1]*exp_lam1_t*T[1][3] + 
    S[3][2]*exp_lam2_t*T[2][3] + 
    S[3][3]*exp_lam3_t*T[3][3];


  // ESA print Markov matrix for edge
  /*
    printf("The edge length is %g    Markov matrix for edge is \n",t);
    for (i=0; i<4; i++)
    for (j=0; j <4; j++){
    printf(" %g ",ppt[i][j]);
    if (j==3)
    printf("\n");
    }
  */

}  /* trans_probGTR */


/* print relative rates (user input).  This is primarily for debugging. */

void print_relative_rates(rAG, rAC, rAT, rGC, rGT, rCT)
     double rAG, rAC, rAT, rGC, rGT, rCT;                 
{

  printf("*** parameter values:\n   mu is %g\n",mu);

  printf("   PAUP order\n");
  printf("-     rAC     rAG     rAT          %g      %g      %g   \n",rAC,rAG,rAT);
  printf("              rCG     rCT                   %g      %g   \n",rGC,rCT);
  printf("                      rGT                            %g   \n",rGT    );

  printf("   OUR order\n");
  printf("-     rAG     rAC     rAT          %g      %g      %g   \n",rAG,rAC,rAT);
  printf("              rGC     rGT                   %g      %g   \n",rGC,rGT);
  printf("                      rCT                            %g   \n",rCT    );

} /* print_relative_rates */


void print_eigs_S_T(){
  int i, j;

  printf("\n");

  printf(" lam0 is %g  lam1 is %g  lam2 is %g  lam3 is %g\n\n",lam0,lam1,lam2,lam3);

  for (i=0; i<4; i++)
    for (j=0; j<4; j++){
      printf(" S[%d][%d] %g", i,j,S[i][j]);
      if (j==3)
	printf("\n");
    }

  printf("\n");

  for (i=0; i<4; i++)
    for (j=0; j<4; j++){
      printf(" T[%d][%d] %g", i,j,T[i][j]);
      if (j==3)
	printf("\n");
    }
}  /* print_eigs_S_T() */


/*** Print Q matrix.  ***/

void print_Q(){
  int i, j;
  double wSum;

  printf("\n");

  // print Q matrix
  printf("Q matrix\n");
  for (i=0; i<4; i++)
    for (j=0; j<4; j++){
      printf(" Q[%d][%d] %f    ",i,j,Q[i][j]);
      if (j==3)
  	printf("\n");
    }

  printf("\n");

  wSum = pi_a*(Q[0][1]+Q[0][2]+Q[0][3])+
    pi_g*(Q[1][0]+       +Q[1][2]+Q[1][3])+
    pi_c*(Q[2][0]+Q[2][1]        +Q[2][3])+
    pi_t*(Q[3][0]+Q[3][1]+Q[3][2]         );

  printf("Weighted sum of off-diagonal entries is %g\n",wSum);

  printf("\n");

}  /* print_Q() */
