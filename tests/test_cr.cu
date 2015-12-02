#include "gtest/gtest.h"
#include <cyclic-reduction/cu_cr_internal.h>
#include <cyclic-reduction/cu_cr_solver.h>
#include <utils/utils.h>

#define CRCTEST(name) \
	TEST(CyclicReductionCalculationTest,name)	

#define CRUTEST(name) \
	TEST(CyclicReductionUtilityTest,name)



using namespace cyclic_reduction;


/**
*	This test file holds all tests for unit testing methods for the cyclic-reduction method of
*	solving tridiagonal matricies.
* 	Methods are tested in same order they are declared in header files.
**/

/*
*	System Test
*/


/*
*           T *  X   =  D      
* | 2 3 0 0 |   |x1|   |2|            |-0.909|
* | 1 3 2 0 | * |x2| = |4|   ==> X ~= | 1.273|
* | 0 2 4 1 |   |x3|   |6|            | 0.545|
* | 0 0 3 5 |   |x4|   |8|            | 1.273|
*/
TEST(CyclicReductionSystemTest,GeneralCase1){
	int size = 4;

	HVectorD h_vect_a(size),
		h_vect_b(size),
		h_vect_c(size),
		h_vect_d(size),
		h_vect_results_actual(size),
		h_vect_results_expected(size);

	for(int i=0; i<size; i++){
		h_vect_a[i] = i;
		h_vect_b[i] = i+2;
		h_vect_c[i] = size-i-1;
		h_vect_d[i] = (i+1)*2;	
	}

	h_vect_results_actual = Solve(size,
					h_vect_a,
					h_vect_b,
					h_vect_c,
					h_vect_d
				);
/*
	utils::PrintVector(true,"A",h_vect_a);
	utils::PrintVector(true,"B",h_vect_b);
	utils::PrintVector(true,"C",h_vect_c);
	utils::PrintVector(true,"D",h_vect_d);
	utils::PrintVector(true,"X",h_vect_results_actual);
*/

}

TEST(CyclicReductionSystemTest, GeneralCase2){
	int size = 4;

	HVectorD h_vect_a(size),
		h_vect_b(size),
		h_vect_c(size),
		h_vect_d(size),
		h_vect_results_actual(size),
		h_vect_results_expected(size);

	for(int i=0; i<size; i++){
		h_vect_a[i] = 1;
		h_vect_b[i] = 1;
		h_vect_c[i] = 1;
		h_vect_d[i] = 1;	
	}
	h_vect_results_actual = Solve(size,
					h_vect_a,
					h_vect_b,
					h_vect_c,
					h_vect_d
				);
/*
	utils::PrintVector(true,"A",h_vect_a);
	utils::PrintVector(true,"B",h_vect_b);
	utils::PrintVector(true,"C",h_vect_c);
	utils::PrintVector(true,"D",h_vect_d);
	utils::PrintVector(true,"X",h_vect_results_actual);

*/
	
}



/*
*	Calculation Method Tests
*/

CRCTEST(LowerAlphaBeta){
//Declarations
	int n = 10;
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
		h_vect_a[i] = i+1;
	
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



CRCTEST(UpperAlphaBeta){
//Declarations
	int n = 10;
	int level = 2;
	
	HVectorD h_vect_c(n),
		h_vect_c_prime(n),
		h_vect_b(n),
		h_vect_results(n);
	
	DVectorD d_vect_c(n),
		d_vect_c_prime(n),
		d_vect_b(n);

//Initialize
	for(int i =0; i <n; i++){
		//Fill c
		h_vect_c[i] = i+2;
	
		//Fill a_prime, this is done so there is nonzero data in before
		h_vect_c_prime[i] = 1000+i;
	
		//Fill b
		if(i%2 == 0){
			h_vect_b[i] = 0.00;
		} else{
			h_vect_b[i] = 3.00;
		}
	}
	for(int i = 0; i < n; i++){
		//Fill results
		if(i+level >= n){
			h_vect_results[i] = 0.00;
		} else if(h_vect_b[i+level] == 0.00){
			h_vect_results[i] = 0.00;
		} else{
			h_vect_results[i] = (-h_vect_c[i] / h_vect_b[i+level]);
		}

/*		
		//Print TODO for debugging the test
		std::cout << "a[" << i << "]= " << h_vect_c[i] << std::endl
			<< "b[" << i << "]= " << h_vect_b[i] << std::endl
			<< "results[" << i << "]= " << h_vect_results[i] << std::endl;
*/		
	}

		
//Copy from host to device
	d_vect_c = h_vect_c;
	d_vect_c_prime = h_vect_c_prime;
	d_vect_b = h_vect_b;

//Call method to be tested
	UpperAlphaBeta(n,level,
		d_vect_b.data(),
		d_vect_c.data(),
		d_vect_c_prime.data()
	);

//Copy from device to host 
	h_vect_c_prime = d_vect_c_prime;

//Check results
	for(int i=0; i <n; i++){
		EXPECT_EQ(h_vect_results[i],  h_vect_c_prime[i]);
	}


}


CRCTEST(MainFront){
	//Declarations
	int n = 10;
	int level = 4;
	
	HVectorD h_vect_a_prime(n),
		h_vect_b(n),
		h_vect_c(n),
		h_vect_results(n);
	
	DVectorD d_vect_a_prime(n),
		d_vect_b(n),
		d_vect_c(n);

//Initialize
	for(int i =0; i <n; i++){
		//Fill a_prime
		h_vect_a_prime[i] = i+1;
	
		//Fill the initial values of v
		h_vect_b[i] = i;
	
		//Fill c
		h_vect_c[i] = (i+1)*2;
	}

	//Fill results	
	for(int i = 0; i < n; i++){
		if(i-level >= 0){
			h_vect_results[i] = h_vect_b[i] + (h_vect_a_prime[i] * h_vect_c[i-level]);
		} else{
			h_vect_results[i] = h_vect_b[i];
		}	
	}
/*
	utils::PrintVector(true,"A'",h_vect_a_prime);
	utils::PrintVector(true,"B",h_vect_b);
	utils::PrintVector(true,"C",h_vect_c);
	utils::PrintVector(true,"Results",h_vect_results);
*/


		
//Copy from host to device
	d_vect_a_prime = h_vect_a_prime;
	d_vect_b = h_vect_b;
	d_vect_c = h_vect_c;

//Call method to be tested



//Copy from device to host 
	h_vect_b = d_vect_b;

//Check results
	for(int i=0; i <n; i++){
		EXPECT_EQ(h_vect_results[i],  h_vect_b[i]);
	}

}

CRCTEST(SolutionFront){
	//Declarations
	int n = 10;
	int level = 4;
	
	HVectorD h_vect_a_prime(n),
		h_vect_d(n),
		h_vect_x(n),
		h_vect_results(n);
	
	DVectorD d_vect_a_prime(n),
		d_vect_d(n),
		d_vect_x(n);

//Initialize
	for(int i =0; i <n; i++){
		//Fill a_prime
		h_vect_a_prime[i] = i+1;
	
		//Fill the initial values of X
		h_vect_x[i] = i+3;
	
		//Fill D
		h_vect_d[i] = i+2;
	}

	//Fill results	
	for(int i = 0; i < n; i++){
		if(i-level >= 0){
			h_vect_results[i] = h_vect_x[i] + (h_vect_a_prime[i] * h_vect_d[i-level]);
		} else{
			h_vect_results[i] = h_vect_x[i];
		}	
	}

	utils::PrintVector(true,"A'",h_vect_a_prime);
	utils::PrintVector(true,"D",h_vect_d);
	utils::PrintVector(true,"X",h_vect_x);
	utils::PrintVector(true,"Results",h_vect_results);



		
//Copy from host to device
	d_vect_a_prime = h_vect_a_prime;
	d_vect_d = h_vect_d;
	d_vect_x = h_vect_x;

//Call method to be tested
	MainFront(n,level,
		d_vect_a_prime.data(),
		d_vect_d.data(),
		d_vect_x.data()
	);


//Copy from device to host 
	h_vect_b = d_vect_b;

//Check results
	for(int i=0; i <n; i++){
		EXPECT_EQ(h_vect_results[i],  h_vect_b[i]);
	}

}

/*
* ==========Utility Method Tests==========
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





