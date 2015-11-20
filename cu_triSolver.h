#ifndef CU_TRI_SOLVER_H
#define CU_TRI_SOLVER_H

#include <thrust/host_vector.h>

/**
 * This method is what will be called to do the actual calculations.
 * Parameters:
 * - sub_diag The sub diagonal of the matrix (a in the diagram)
 * - main_diag The main diagonal of the matrix (b in the diagram)
 * - super_diag The super diagonal of the matrix (c in the diagram)
 * - size The size of the vectors being passed in
 */
 
void triSolve(thrust::host_vector<int> sub_diag, thrust::host_vector<int> main_diag, thrust::host_vector<int> super_diag, thrust::host_vector<int> col_sol, int size); 



void test();


#endif

