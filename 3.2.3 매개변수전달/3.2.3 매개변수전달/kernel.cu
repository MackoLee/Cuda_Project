
#include "cuda_runtime.h"
#include <iostream>

static void HandleError(cudaError_t err,
    const char* file,
    int line) {
    if (err != cudaSuccess) {
        printf("%s in %s at line %d\n", cudaGetErrorString(err),
            file, line);
        exit(EXIT_FAILURE);
    }
}
#define HANDLE_ERROR(err) (HandleError( err, __FILE__, __LINE__ ))

//여기에 커널 작성
__global__ void add(int a,int b, int *c)
{
    *c = a + b;
}

int main()
{
    int c;
    int* dev_c;
    HANDLE_ERROR(cudaMalloc((void**)&dev_c, sizeof(int)));

    add << <1, 1 >> > (2, 7, dev_c);

    HANDLE_ERROR(cudaMemcpy(&c, dev_c, sizeof(int), cudaMemcpyDeviceToHost));
    printf("2+7=%d\n", c);
    cudaFree(dev_c);

    return 0;
}