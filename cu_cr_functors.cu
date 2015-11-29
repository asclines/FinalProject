#include <cuda.h>


/**
* Calculates:
*	alpha_i = -a_i/b_(i-2^(l-i))
*	where:
*		x = a_i
*		y = b_(i-2^(l-i))
*
*	beta_i = -c_i/b_(i+2^(l-i))
*	where:
*		x = c_i
*		y = b_(i+2^(l-i))	
**/
struct AlphaBeta{
	__host__ __device__
	double operator()(double x, double y){
		return (-x)/y;
	}
};


