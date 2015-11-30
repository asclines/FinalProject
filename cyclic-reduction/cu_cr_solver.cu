#include "cu_cr_solver.h"
#include "cu_cr_internal.h"
#include "cu_cr_functors.cu"

#include <math.h>

/**
* Main method to call in order to solve a tridiagonal matrix using Cyclic-Reduction
*
* Params:
*	n - size of diagonals
* 	vect_* - see diagrams
**/
thrust::host_vector<double>  crSolve(int n, thrust::host_vector<double> vect_a, thrust::host_vector<double> vect_b, thrust::host_vector<double> vect_c, thrust::host_vector<double> vect_d){

	n--; //Cause vectors start at 0
	
	int q = calc_q(n); //Max reduction level
}


/**
* Method used to solve for q when:
* n = 2^q when n is even and
* n = 2^q-1 when n is odd
**/
int calc_q(int n_){
	double n = n_;
	int q = log2(n);
	/*
	if(n_%2==0){
		//q = log2(n);
	} else{
		//q = log2(n)-1;
	}
	*/
	return q;
}


/**
* Method used to calculate the first reduction iteration as it is different
**/
void calc_init(int n,
	thrust::device_ptr<double> d_ptr_a, 
	thrust::device_ptr<double> d_ptr_b, 
	thrust::device_ptr<double> d_ptr_c,
	thrust::device_ptr<double> d_ptr_d){
	
	thrust::device_vector<double> d_vect_alpha(n-1);
	thrust::device_vector<double> d_vect_a_prime(n-1);

	thrust::transform(
		d_ptr_a + 1, d_ptr_a + n,
		d_ptr_b, 
		d_vect_alpha.begin(),
		AlphaBeta()
	);

	thrust::transform(
		d_vect_alpha.begin(),d_vect_alpha.end(),	
		d_ptr_a,
		d_vect_a_prime.begin(),
		thrust::multiplies<double>()
	);
}


