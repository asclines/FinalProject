#include "gtest/gtest.h"
#include <cyclic-reduction/cu_cr_internal.h>




/**
*	This test file holds all tests for unit testing methods for the cyclic-reduction method of
*	solving tridiagonal matricies
**/

TEST(CyclicReductionTest, QCalc){
	//Test even and odd numbers where ouput IS NOT a whole number
	EXPECT_EQ(2,calc_q(5));
	EXPECT_EQ(3,calc_q(12));

	//Test even and odd numbers where output IS a whole number
	EXPECT_EQ(2,calc_q(4));
	EXPECT_EQ(2,calc_q(7));
}
