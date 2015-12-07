#-----MACROS----#
#Compiler Macros
CC=nvcc
DB=-g -G
LIBS=-lgtest -lpthread
IF = -I ./ 
CFLAGS=--std=c++11 -g -G  -pg -O0

#Locations
EXEDIR = gen/
OBJDIR = bin/
CR = cyclic-reduction/
TEST = tests/
UTIL = utils/

#Objects
OBJ_CR = $(OBJDIR)cu_cr_solver.o
OBJ_UTILS = $(OBJDIR)utils.o
OBJ_SS = $(OBJDIR)serial_solver.o
OBJS = $(OBJ_CR) $(OBJ_UTILS) $(OBJ_SS)

#Thomas Algorithm Serial Method
SS = serial_tSolver.cu serial_tSolver.h

#Cyclic-Reduction Method
CRM = $(addprefix $(CR), cu_cr_functors.cu cu_cr_solver.cu cu_cr_solver.h cu_cr_internal.h)

#Utility and Helper Files
UTILS = $(addprefix $(UTIL), utils.cu utils.h) 

#Test Files
TF = $(addprefix $(TEST), test_all.cu test_cr.cu test_functors.cu test_serial_tSolver.cu test_cr_system.cu)


#-----RUN COMMANDS-----
install: init program

run: init
	./$(EXEDIR)program p

test: init test_all
	./$(EXEDIR)test_all 

clean: clean_log
	@(rm bin/* gen/* *.out program test_all) &> /dev/null || true

clean_log:
	@(rm output.txt log.txt) &> /dev/null || true
clean_objs:
	@(rm *.o) &> /dev/null || true

#-----MAKE COMMANDS-----

init: clean_log 
	@(mkdir bin gen) &> /dev/null || true

program: program.cu $(OBJS)
	$(CC) $(IF) $(OBJS) -o $(EXEDIR)program program.cu 

test_all: $(TF) $(OBJS)
	$(CC) $(IF) $(OBJS)  -o $(EXEDIR)test_all $(TEST)test_all.cu $(LIBS) $(CFLAGS) 

cr: $(OBJ_CR)

ss: $(OBJ_SS) 

utils: $(OBJ_UTILS)


#-----OBJECT COMMANDS-----

$(OBJ_CR): $(CRM)
	$(CC) $(IF) -c  $(CR)cu_cr_solver.cu $(CFLAGS) -o $@

$(OBJ_UTILS): $(UTILS)
	$(CC) $(IF) -c $(UTIL)utils.cu $(CFLAGS) -o $@

$(OBJ_SS): $(SS)
	$(CC) $(IF) -c serial_tSolver.cu -o $@


