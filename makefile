#-----MACROS----#
#Compiler Macros
CC=nvcc
DB=-g -G
LIBS=-lgtest -lpthread
IF = -I ./ 
CFLAGS=--std=c++11 -g -G -pg -O0

#Locations
OBJDIR = bin/
CR = cyclic-reduction/
TEST = tests/

#Objects
OBJ_CR = $(OBJDIR)cu_cr_solver.o
OBJ_TS = $(OBJDIR)cu_triSolver.o
OBJS = $(OBJ_CR) 

#Thomas Algorithm Serial Method
TS= cu_triSolver.cu cu_triSolver.h cu_functors.cu
SD= cu_triSolver.cu cu_triSolver.h cu_functors.cu

#Cyclic-Reduction Method
CRM = $(addprefix $(CR), cu_cr_functors.cu cu_cr_solver.cu cu_cr_solver.h cu_cr_internal.h)

#Test Files
TF = $(addprefix $(TEST), test_all.cu test_cr.cu test_input.cu test_solver.cu test_functors.cu)
#-----RUN COMMANDS-----
build: init program

run: 
	./program

test: init test_all
	./test_all 

clean:
	@(rm bin/* program test_all) &> /dev/null || true

clean_objs:
	@(rm *.o) &> /dev/null || true

#-----MAKE COMMANDS-----

init: 
	@(mkdir bin) &> /dev/null || true

program: triSolver.cu $(OBJS)
	$(CC) -o program cu_triSolver.o triSolver.cu

test_all: $(TF) $(OBJS)
	$(CC) $(IF) $(OBJS)  -o test_all $(TEST)test_all.cu $(LIBS) $(CFLAGS)

cr: $(OBJ_CR) 


#-----OBJECT COMMANDS-----

$(OBJ_TS): $(TS)
	$(CC) -c cu_triSolver.cu

$(OBJ_CR): $(CRM)
	$(CC) $(IF) -c  $(CR)cu_cr_solver.cu $(CFLAGS) -o $@




