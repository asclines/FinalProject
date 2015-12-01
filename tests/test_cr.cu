#include "gtest/gtest.h"
#include <cyclic-reduction/cu_cr_internal.h>


#define CRCTEST(name) \
	TEST(CyclicReductionCalculationTest,name)	

#define CRUTEST(name) \
	TEST(CyclicReductionUtilityTest,name)



using namespace cyclic_reduction;


/**
*	This test file holds all tests for unit testing methods for the cyclic-reduction method of
*	solving tridiagonal matricies
**/



/*
*	Calculation Method Tests
*/

CRCTEST(LowerAlphaBeta){
//Declarations
	int n = 5;
	int level = 3;
	
	HVectorD h_vect_a(n),
		h_vect_a_prime(n),
		h_vect_b(n),
		h_vect_results(n);
	
	DVectorD d_vect_a(n),
		d_vect_a_prime(n),
		d_vect_b(n);

//Initialize
	for(int i =0; i <n; i++){
		//Fill a
		h_vect_a[i] = i;
	
		//Fill a_prime, this is done so there is nonzero data in before
		h_vect_a_prime[i] = 1000+i;
	
		//Fill b
		if(i%2 == 0){
			h_vect_b[i] = 0.00;
		} else{
			h_vect_b[i] = 2.00;
		}

		//Fill results
		if(i-level < 0){
			h_vect_results[i] = 0.00;
		} else if(h_vect_b[i-level] == 0.00){
			h_vect_results[i] = 0.00;
		} else{
			h_vect_results[i] = (-h_vect_a[i] / h_vect_b[i-level]);
		}

		/*
		//Print TODO for debugging the test
		std::cout << "a[" << i << "]= " << h_vect_a[i] << std::endl
			<< "b[" << i << "]= " << h_vect_b[i] << std::endl
			<< "results[" << i << "]= " << h_vect_results[i] << std::endl;
		*/
	}

		
//Copy from host to device
	d_vect_a = h_vect_a;
	d_vect_a_prime = h_vect_a_prime;
	d_vect_b = h_vect_b;

//Call method to be tested
	LowerAlphaBeta(n,level,
		d_vect_a.data(),
		d_vect_a_prime.data(),
		d_vect_b.data()
	);

//Copy from device to host 
	h_vect_a_prime = d_vect_a_prime;

//Check results
	for(int i=0; i <n; i++){
		EXPECT_EQ(h_vect_results[i],  h_vect_a_prime[i]);
	}

}	









/*
*		Utility Method Tests
*/

CRUTEST(InitDPtrD){
	int n = 10;
	DVectorD vect_test(n);
	
	//Fill vector with data not equal to 0
	for(int i = 0; i<n; i++){
		vect_test[i] = 5;
	}

	InitDPtrD(n,vect_test.data());

	//Now check to make sure each element is 0.00
	for(int i = 0; i <n; i++){
		EXPECT_EQ(0.00,vect_test[i]);
	}
}
	
CRUTEST(InitSolutionDPtrD){
	int n = 10;
	
	HVectorD h_vect_test(n),
		h_vect_results(n);

	DVectorD d_vect_test(n),
		d_vect_results(n);


	//Setup vector initial values
	for(int i = 0; i < n; i++){
		h_vect_results[i] = 1000 + i;
		h_vect_test[i] = 0.00;
	}

	//Copy from host to device
	d_vect_test = h_vect_test;
	d_vect_results = h_vect_results;

	//Call method to be tested
	InitSolutionDPtrD(n, d_vect_results.data(), d_vect_test.data());

	//Copy from device to host
	h_vect_test = d_vect_test;
	h_vect_results = d_vect_results;

	//Check results 
	for(int i = 0; i < n; i++){
		EXPECT_EQ(h_vect_results[i],d_vect_test[i]);
	}

}

CRUTEST(QCalc){
	//Test even and odd numbers where ouput IS NOT a whole number
	EXPECT_EQ(2,calc_q(5));
	EXPECT_EQ(3,calc_q(12));

	//Test even and odd numbers where output IS a whole number
	EXPECT_EQ(2,calc_q(4));
	EXPECT_EQ(2,calc_q(7));
}





