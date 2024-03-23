LIB ?= -lm -L/usr/lib -pthread -fopenmp  -march=native
FLAGS ?= -O3 -DNDEBUG -g -Wall

.PHONY: clean all

all: ct_sequential ct_parallel ct_parallel_fr

ct_sequential: ct_sequential.cpp
	g++ $(FLAGS) $(LIB) -o ct_sequential ct_sequential.cpp

ct_parallel: ct_parallel.cpp
	mpicxx $(FLAGS) $(LIB) -o ct_parallel ct_parallel.cpp

ct_parallel_fr: ct_parallel_fr.cpp
	mpicxx $(FLAGS) $(LIB) -o ct_parallel_fr ct_parallel_fr.cpp

clean:
	rm -f ct_sequential ct_parallel ct_parallel_fr *.o
