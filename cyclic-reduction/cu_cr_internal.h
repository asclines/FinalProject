#ifndef CU_CR_INTERNAL_H
#define CU_CR_INTERNAL_H

#include <thrust/device_vector.h>
#include <thrust/device_ptr.h>

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





#endif
