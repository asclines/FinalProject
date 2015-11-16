#include <iostream>

using namespace std;


/**
 *Params:
 *a - Diagonal
 *b - Offset-Diagonal
 *d - Result column
 *n - Size of matrix
 */
void solve(double* a, double* b,double* d, int n) {
    n--; // since we start from x0 (not x1)
    b[0] /= b[0];
    d[0] /= b[0];

    for (int i = 1; i < n; i++) {
	b[i] /= b[i] - a[i]*b[i-1];
        d[i] = (d[i] - a[i]*d[i-1]) / (b[i] - a[i]*b[i-1]);
    }

    d[n] = (d[n] - a[n]*d[n-1]) / (b[n] - a[n]*b[n-1]);

    for (int i = n; i-- > 0;) {
        d[i] -= b[i]*d[i+1];
    }
}

int main() {
	int  n = 4;
	double a[4] = { 0, -1, -1, -1 };
	double b[4] = { 4,  4,  4,  4 };
	double c[4] = {-1, -1, -1,  0 };
	double d[4] = { 5,  5, 10, 23 };
	// results    { 2,  3,  5, 7  }
	solve(a,b,d,n);
	for (int i = 0; i < n; i++) {
		cout << d[i] << endl;
	}
	cout << endl << "n= " << n << endl;
	return 0;
}
