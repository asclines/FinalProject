CC=nvcc
DEBUG=-g -G
SD= cu_triSolver.cu cu_triSolver.h

program: triSolver.cu $(SD)
	$(CC) -o program triSolver.cu




