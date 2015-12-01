#ifndef CU_CR_INTERNAL_H
#define CU_CR_INTERNAL_H

#include <thrust/device_ptr.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/iterator/counting_iterator.h>

/*
 * 	This header file contains all foward declarations of methods used internall by
 * 	cu_cr_solver.cu
 *	This file also serves as an interface to be used by testing.
 *	For method documentation see cu_cr_solver.cu
 */

int calc_q(int n);

void calc_init(int n,
	thrust::device_ptr<double> d_vect_a, 
	thrust::device_ptr<double> d_vect_b, 
	thrust::device_ptr<double> d_vect_c,
	thrust::device_ptr<double> d_vect_d);


namespace cyclic_reduction{

/*
 * 	TYPEDEFS
 */
	typedef thrust::device_ptr<double> DPtrD; //Device Ptr Double 
	typedef thrust::device_vector<double> DVectorD; //Device Vector Double
	typedef thrust::host_vector<double> HVectorD; //Host Vector Double
	typedef thrust::tuple<int, double> TupleID; //Tuple Integer Double
	typedef thrust::tuple<thrust::counting_iterator<int>, DVectorD::iterator> TupleCiDvi; //Tuple Counting iterator Device vector iterator
	typedef thrust::zip_iterator<TupleCiDvi> ZipIteratorTCD; //Zip Iterator TupleCiDvi

/*
 * 	FOWARD DECLARATIONS
 */

//Calculation Methods
	void LowerAlphaBeta(int n, int level, DPtrD d_ptr_a, DPtrD d_ptr_a_prime, DPtrD d_ptr_b);
	void UpperAlphaBeta(int n, int level, DPtrD d_ptr_b, DPtrD d_ptr_c, DPtrD d_ptr_c_prime);
	void MainFront(int n, int level, DPtrD d_ptr_a_prime, DPtrD d_ptr_b, DPtrD d_ptr_c);
	void MainBack(int n, int level, DPtrD d_ptr_a, DPtrD d_ptr_c_prime, DPtrD d_ptr_b);


//Utility Methods
	void InitDPtrD(int n, DPtrD d_ptr);
	

}


#endif
