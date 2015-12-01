#include <cyclic-reduction/cu_cr_solver.h>
#include <cyclic-reduction/cu_cr_internal.h>
#include <cyclic-reduction/cu_cr_functors.cu>

#include <cuda.h>
#include <math.h>

#include <thrust/copy.h>
#include <thrust/functional.h>

/*
* For method documentation see cu_cr_internal.h unless otherwise specified.
*/


namespace cyclic_reduction{


void LowerAlphaBeta(int n, int level, DPtrD d_ptr_a, DPtrD d_ptr_a_prime, DPtrD d_ptr_b){

	InitDPtrD(n,d_ptr_a_prime);
	thrust::transform(
		d_ptr_a + level, d_ptr_a + n,
		d_ptr_b,
		d_ptr_a_prime + level,
		AlphaBeta()
	);
		
}

void UpperAlphaBeta(int n, int level, DPtrD d_ptr_b, DPtrD d_ptr_c, DPtrD d_ptr_c_prime){

	InitDPtrD(n,d_ptr_c_prime);	
	thrust::transform(
		d_ptr_c , d_ptr_c + (n-level),
		d_ptr_b + level,
		d_ptr_c_prime,
		AlphaBeta()
	);

}

//(rank - span >= 0)
void MainFront(int n, int level, DPtrD d_ptr_a_prime, DPtrD d_ptr_b, DPtrD d_ptr_c){

	DVectorD d_vect_temp(n); //TODO see about freeing this memory, and condensing space
	InitDPtrD(n, d_vect_temp.data());
	
	thrust::transform(
		d_ptr_a_prime + level, d_ptr_a_prime + n,
		d_ptr_c,
		d_vect_temp.begin(),
		thrust::multiplies<double>()
	);

	thrust::transform(
		d_ptr_b + level, d_ptr_b + n,
		d_vect_temp.begin(),
		d_ptr_b + level,
		thrust::plus<double>()
	);

}


void SolutionFront(int n, int level, DPtrD d_ptr_a_prime, DPtrD d_ptr_d, DPtrD d_ptr_x ){
	DVectorD d_vect_temp(n);

	thrust::transform(
		d_ptr_a_prime + level, d_ptr_a_prime + n,
		d_ptr_d + level,
		d_vect_temp.begin(),
		thrust::multiplies<double>()
	);

	thrust::transform(
		d_ptr_x + level, d_ptr_x + n,
		d_vect_temp.begin(),
		d_ptr_x + level,
		thrust::plus<double>()
	);

}


void LowerFront(int n, int level, DPtrD d_ptr_a, DPtrD d_ptr_a_prime){

	thrust::transform(
		d_ptr_a_prime + level, d_ptr_a_prime + n,
		d_ptr_a_prime + level,
		d_ptr_a,
		thrust::multiplies<double>()
	);	
}



//(rank + span < n)
void MainBack(int n, int level, DPtrD d_ptr_a, DPtrD d_ptr_c_prime, DPtrD d_ptr_b){

	DVectorD d_vect_temp(n);
	InitDPtrD(n, d_vect_temp.data());
	
	thrust::transform(
		d_ptr_c_prime , d_ptr_c_prime + (n - level),
		d_ptr_a + level,
		d_vect_temp.begin(),
		thrust::multiplies<double>()
	);

	thrust::transform(
		d_ptr_b , d_ptr_b + (n - level),
		d_vect_temp.begin(),
		d_ptr_b,
		thrust::plus<double>()
	);
}

void SolutionBack(int n, int level, DPtrD d_ptr_c_prime, DPtrD d_ptr_d, DPtrD d_ptr_x){
	DVectorD d_vect_temp(n); 
	
	thrust::transform(
		d_ptr_c_prime, d_ptr_c_prime + (n-level),
		d_ptr_d + level,
		d_vect_temp.begin(),
		thrust::multiplies<double>()
	);

	thrust::transform(
		d_ptr_x + level, d_ptr_x + n,
		d_vect_temp.begin(),
		d_ptr_x + level,
		thrust::plus<double>()
	);

}


void UpperBack(){
//TODO
}



/*
*	Utility Methods
*/

void InitDPtrD(int n, DPtrD d_ptr){
	thrust::fill(
		d_ptr, d_ptr + n,
		0.00
	);				
}

void InitSolutionDPtrD(int n, DPtrD d_ptr_d, DPtrD d_ptr_x){
	thrust::copy_n(d_ptr_d, n, d_ptr_x);	
}

}//END - namespace

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
		cyclic_reduction::AlphaBeta()
	);

	thrust::transform(
		d_vect_alpha.begin(),d_vect_alpha.end(),	
		d_ptr_a,
		d_vect_a_prime.begin(),
		thrust::multiplies<double>()
	);
}


