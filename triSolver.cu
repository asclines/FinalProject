#include <iostream>
#include <fstream>
#include <string>
#include "cu_triSolver.h"
#include <vector>
#include <sstream>

using namespace std;

int main(){
	string line;
	ifstream myfile ("input.txt");
	if (myfile.is_open())
	{	
		getline (myfile, line);
		int n;
		stringstream stream;
		stream <<line;
		stream >>n;
		
		getline (myfile, line);
		int a;
		vector<int> A;
		stringstream stream_a;
		stream_a <<line;
		for (int i=0; i<n; i++){
			stream_a >>a; 
			A.push_back(a);}
		
		getline (myfile, line);
		int b;
		vector<int> B;
		stringstream stream_b;
		stream_b <<line;
		for (int i=0; i<n; i++){
			stream_b >>b;
			B.push_back(b);}

		getline (myfile, line);
		int c;
		vector<int> C;
		stringstream stream_c;
		stream_c <<line;
		for (int i=0; i<n; i++){
			stream_c >>c;
			C.push_back(c);}

		getline (myfile, line);
		int d;
		vector<int> D;
		stringstream stream_d;
		stream_d <<line;
		for (int i=0; i<n; i++){
			stream_d >>d;
			D.push_back(d);}

	
		myfile.close();
	}
	else cout <<"Unable to open file";




	return 0;
}
