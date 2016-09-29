CC = gcc
CFLAGS = -O0 -std=gnu99 -Wall  

EXECUTABLE = \
	time_test_iteration
# time_test_openmp_2 time_test_openmp_4 \
#	time_test_avx time_test_avxunroll \
#	time_test_Leibniz time_test_leibizavx time_test_Leibnizavx_unroll\
#	time_test_MonteCarlo \
#	benchmark_clock_gettime

default: clz.o
	$(CC) $(CFLAGS) clz.o time_test.c -DITERATION -o time_test_iteration
#	$(CC) $(CFLAGS) clz.o time_test.c -DOPENMP_2 -o time_test_openmp_2
#	$(CC) $(CFLAGS) clz.o time_test.c -DOPENMP_4 -o time_test_openmp_4
#	$(CC) $(CFLAGS) clz.o time_test.c -DAVX -o time_test_avx
#	$(CC) $(CFLAGS) clz.o time_test.c -DAVXUNROLL -o time_test_avxunroll
#	$(CC) $(CFLAGS) clz.o time_test.c -DLEIBNIZ -o time_test_Leibniz 

#	$(CC) $(CFLAGS) clz.o benchmark_clock_gettime.c -o benchmark_clock_gettime

.PHONY: clean default

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@  

check: default
	time ./time_test_iteration
#	time ./time_test_openmp_2
#	time ./time_test_openmp_4
#	time ./time_test_avx
#	time ./time_test_avxunroll
#	time ./time_test_Leibniz
#	time ./time_test_leibizavx
#	time ./time_test_Leibnizavx_unroll
#	time ./time_test_MonteCarlo

gencsv: default
	for i in `seq 1000 1000 250000`; do \
		printf "%d," $$i;\
		./benchmark_clock_gettime $$i; \
	done > result_clock_gettime.csv	

plot: gencsv
		gnuplot script.gp

clean:
	rm -f $(EXECUTABLE) *.o *.s result_clock_gettime.csv
