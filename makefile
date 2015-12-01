#-----MACROS----#
#Compiler Macros
CC=nvcc
DB=-g -G
LIBS=-lgtest -lpthread
IF = -I ./  #for internal files
CFLAGS=--std=c++11 -g -G -pg -O0

#Locations
CR = cyclic-reduction/
TEST = tests/

#Objects
OBJ_CR = cu_cr.o
OBJ_TS = cu_triSolver.o 
OBJS = $(OBJ_CR) 

#Thomas Algorithm Serial Method
TS= cu_triSolver.cu cu_triSolver.h cu_functors.cu
SD= cu_triSolver.cu cu_triSolver.h cu_functors.cu

#Cyclic-Reduction Method
CRM = $(CR)cu_cr_functors.cu $(CR)cu_cr_solver.cu $(CR)cu_cr_solver.h $(CR)cu_cr_internal.h

#Test Files
TF = $(TEST)test_all.cu $(TEST)test_input.cu $(TEST)test_solver.cu $(TEST)test_functors.cu

#-----RUN COMMANDS-----
build: program clean_objs

run: 
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

test_all: $(TF) $(OBJS)
	$(CC) $(IF) cu_cr_solver.o -o test_all $(TEST)test_all.cu $(LIBS) $(CFLAGS) 


#-----OBJECT COMMANDS-----

$(OBJ_TS): $(TS)
	$(CC) -c  cu_triSolver.cu

$(OBJ_CR): $(CRM)
	$(CC) $(IF) -c $(CR)cu_cr_solver.cu $(CFLAGS)





