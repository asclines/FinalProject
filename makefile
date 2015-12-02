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
UTIL = utils/

#Objects
OBJ_CR = $(OBJDIR)cu_cr_solver.o
OBJ_UTILS = $(OBJDIR)utils.o
OBJ_TS = $(OBJDIR)cu_triSolver.o
OBJS = $(OBJ_CR) $(OBJ_UTILS)

#Thomas Algorithm Serial Method
TS= cu_triSolver.cu cu_triSolver.h cu_functors.cu
SD= cu_triSolver.cu cu_triSolver.h cu_functors.cu

#Cyclic-Reduction Method
CRM = $(addprefix $(CR), cu_cr_functors.cu cu_cr_solver.cu cu_cr_solver.h cu_cr_internal.h)

#Utility and Helper Files
UTILS = $(addprefix $(UTIL), utils.cu utils.h) 

#Test Files
TF = $(addprefix $(TEST), test_all.cu test_cr.cu test_input.cu test_solver.cu test_functors.cu)


#-----RUN COMMANDS-----
install: init program

run: 
	./program

test: init test_all
	./test_all 

clean:
	@(rm bin/* *.out program test_all) &> /dev/null || true

clean_objs:
	@(rm *.o) &> /dev/null || true

#-----MAKE COMMANDS-----

init: 
	@(mkdir bin) &> /dev/null || true

program: triSolver.cu $(OBJS)
	$(CC) $(IF) $(OBJS)-o program triSolver.cu

test_all: $(TF) $(OBJS)
	$(CC) $(IF) $(OBJS)  -o test_all $(TEST)test_all.cu $(LIBS) $(CFLAGS)

cr: $(OBJ_CR) 

utils: $(OBJ_UTILS)


#-----OBJECT COMMANDS-----

$(OBJ_TS): $(TS)
	$(CC) -c cu_triSolver.cu

$(OBJ_CR): $(CRM)
	$(CC) $(IF) -c  $(CR)cu_cr_solver.cu $(CFLAGS) -o $@

$(OBJ_UTILS): $(UTILS)
	$(CC) $(IF) -c $(UTIL)utils.cu $(CFLAGS) -o $@


