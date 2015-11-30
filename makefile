#-----MACROS----#
#Compiler Macros
CC=nvcc
DB=-g -G
LIBS=-lgtest -lpthread
IF = -I ./  #for internal files

#Locations
CR = cyclic-reduction/


#Thomas Algorithm Serial Method
TS= cu_triSolver.cu cu_triSolver.h cu_functors.cu
SD= cu_triSolver.cu cu_triSolver.h cu_functors.cu

#Cyclic-Reduction Method
CRM = $(CR)cu_cr_functors.cu $(CR)cu_cr_solver.cu $(CR)cu_cr_solver.h $(CR)cu_cr_internal.h

#Test Files
TF = test_all.cu test_input.cu test_solver.cu test_functors.cu

#-----RUN COMMANDS-----

run: program clean_objs
	./program

test: test_all clean_objs
	./test_all 

clean:
	@(rm *.o program test_all) &> /dev/null || true
clean_objs:
	@(rm *.o) &> /dev/null || true

#-----MAKE COMMANDS-----

program: triSolver.cu cu_triSolver.o
	$(CC) -o program cu_triSolver.o triSolver.cu

test_all: $(TF) cu_cr.o
	$(CC) $(IF) cu_cr_solver.o -o test_all test_all.cu $(LIBS)


#-----OBJECT COMMANDS-----

cu_triSolver.o: $(TS)
	$(CC) -c  cu_triSolver.cu

cu_cr.o: $(CRM)
	$(CC) $(IF) -c $(CR)cu_cr_solver.cu





