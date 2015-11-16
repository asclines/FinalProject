CC=g++
DEBUG=-g -G

trisolver: trisolver.cpp
	$(CC) -o triSolver trisolver.cpp

triSymSolver: triSymSolver.cpp
	$(CC) -o triSymSolver triSymSolver.cpp

