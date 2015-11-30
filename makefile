#-----MACROS----#
#Compiler Macros
CC=nvcc
DEBUG=-g -G
LIBS=-lgtest -lpthread

#Thomas Algorithm Serial Method
TS= cu_triSolver.cu cu_triSolver.h cu_functors.cu
SD= cu_triSolver.cu cu_triSolver.h cu_functors.cu

#Cyclic-Reduction Method

#Test Files
TF = test_all.cu test_input.cu test_solver.cu test_functors.cu

#-----RUN COMMANDS-----

run: program clean
	./program

test: test_all clean
	./test_all

clean:
	@(rm *.o program test_all) &> /dev/null || true

#-----MAKE COMMANDS-----

program: triSolver.cu cu_triSolver.o
	$(CC) -o program cu_triSolver.o triSolver.cu

test_all: $(TF)
	$(CC) -o test_all test_all.cu $(LIBS)


#-----OBJECT COMMANDS-----

cu_triSolver.o: $(TS)
	$(CC) -c  cu_triSolver.cu






