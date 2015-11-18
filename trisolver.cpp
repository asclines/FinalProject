#include <iostream>

using namespace std;

void solve(double* a, double* b, double* c, double* d, int n) {
    n--; // since we start from x0 (not x1)
   
//Step 1
    c[0] /= b[0];
    d[0] /= b[0];

    for (int i = 1; i < n; i++) {
//Step 2	
	c[i] /= b[i] - a[i]*c[i-1];

//Step 3
        d[i] = (d[i] - a[i]*d[i-1]) / (b[i] - a[i]*c[i-1]);
    }
//Step 4
    d[n] = (d[n] - a[n]*d[n-1]) / (b[n] - a[n]*c[n-1]);

    for (int i = n; i-- > 0;) {
//Step 5
	d[i] -= c[i]*d[i+1];
    }
}

int main() {
	int  n = 4;
	double a[4] = { 0, -1, -1, -1 };
	double b[4] = { 4,  4,  4,  4 };
	double c[4] = {-1, -1, -1,  0 };
	double d[4] = { 5,  5, 10, 23 };
	// results    { 2,  3,  5, 7  }
	solve(a,b,c,d,n);
	for (int i = 0; i < n; i++) {
		cout << d[i] << endl;
	}
	return 0;
}
