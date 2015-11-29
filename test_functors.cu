#include "gtest/gtest.h"
#include "cu_functors.cu"
#include "cu_cr_functors.cu"

//Functor tests go here
TEST( FunctorTest, Hydrogen){
	Hydrogen hydrogen;
	EXPECT_EQ(-1.5,hydrogen(1.0,2.0,3.0,4.0));
}


TEST( FunctorTest, Helium){
	Helium helium;
	EXPECT_EQ(1 , helium(1,2,3,4,5));
}


TEST( FunctorTest, Silicon){
	Silicon silicon;
	EXPECT_EQ(-1 ,silicon(1,2,3));
}


TEST( FunctorTest, AlphaBeta){
	AlphaBeta alphaBeta;
	EXPECT_EQ(-2 ,alphaBeta(4,2));
}

TEST( FunctorTest, AC){
	AC ac;
	EXPECT_EQ(-1.5 ,ac(1,2,3));
}

TEST( FunctorTest, BD){
	BD bd;
	EXPECT_EQ(27 , bd(1,2,3,4,5));
}
