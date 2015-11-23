CC=nvcc
DEBUG=-g -G
TS= cu_triSolver.cu cu_triSolver.h cu_functors.cu
SD= cu_triSolver.cu cu_triSolver.h cu_functors.cu
LIBS=-lgtest -lpthread

program: triSolver.cu cu_triSolver.o
	$(CC) -o program cu_triSolver.o triSolver.cu

cu_triSolver.o: $(TS)
	$(CC) -c  cu_triSolver.cu

test_all: test_all.cu test_functors.cu test_input.cu test_solver.cu
	$(CC) -o test_all test_all.cu $(LIBS)

clean:
	rm *.o

