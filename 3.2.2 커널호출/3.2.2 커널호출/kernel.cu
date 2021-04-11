
#include "cuda_runtime.h"

#include <iostream>

__global__ void kernel()
{
}

int main()
{
    kernel<<<1,1>>>();
    printf("Hello, World!");
    return 0;
}