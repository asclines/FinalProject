#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <utils/utils.h>
#include <cyclic-reduction/cu_cr_solver.h>
#include <thrust/host_vector.h>
#include <serial_tSolver.h>

using namespace std;

void usage(){

	cout << "usage: ./program [option]"
		<< endl << endl
		<< "p \t run parallel method" << endl
		<< "s \t run serial method" << endl;
}

int main(int argc, const char *argv[]){
	typedef thrust::host_vector<double> HVectorD;
	
	char opt;

	if(argc != 2){
		usage();
		exit(1);
	} else if(*(argv)[1] == 'p'){
		cout << "Running parallel method" << endl;
		opt = 'p';
	} else if(*(argv)[1] == 's'){
		cout << "Running serial method" << endl;
		opt = 's';
	} else{	
		usage();
		exit(1);
	}
		
	
	

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

		
		HVectorD h_vect_a = A;
		HVectorD h_vect_b = B;
		HVectorD h_vect_c = C;
		HVectorD h_vect_d = D;
		HVectorD h_vect_results;
		if(opt == 'p'){
			h_vect_results = cyclic_reduction::Solve(n,
						h_vect_a,
						h_vect_b,
						h_vect_c,
						h_vect_d
					);
			
			utils::LogProgramResults("Cyclic Reduction Method Results",h_vect_results);
		}
		else{
			h_vect_results = serial_solve(n, h_vect_a, h_vect_b, h_vect_c, h_vect_d);
			utils::LogProgramResults("Thomas Algorithm Method Results", h_vect_results);
		}	


	}
	else cout <<"Unable to open file";

	return 0;
}
