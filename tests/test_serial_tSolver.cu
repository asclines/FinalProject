#include "gtest/gtest.h"
#include <serial_tSolver.h>

TEST( serialTest, systemTest )
{
	double n = 4;

	host_vector<double> a(4);
	a[0] = 0.0; a[1] = -1.0; a[2] = -1.0; a[3] = -1.0;
	host_vector<double> b(4);
	b[0] = 4.0; b[1] = 4.0; b[2] = 4.0; b[3] = 4.0;
	host_vector<double> c(4);
	c[0] = -1.0; c[1] = -1.0; c[2] = -1.0; c[3] = 0.0;
	host_vector<double> d(4);
	d[0] = 5; d[1] = 5; d[2] = 10; d[3] = 23.0;

	host_vector<double> actual(4);
	host_vector<double> exp(4);
	exp[0] = 2; exp[1] = 3; exp[2] = 5; exp[7];

	actual = serial_solve(a, b, c, d);


	for(int i = 0; i < n; i++)
	{
		EXPECT_EQ(exp[i], actual[i]);
	}
}
