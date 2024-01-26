#include <iostream>

extern "C" void cpp_matmul(double *a, double *b, int size){
    int c = 0;

    for(int i = 0; i < size; i++){
        for(int k = 0; k < size; k++){
            for(int j = 0; j < size; j++){
                c += a[i*size + k] * b[k*size + j];
            }
        }
    }
}
