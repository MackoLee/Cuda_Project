
#include "cuda_runtime.h"
#include <iostream>

using namespace std;

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
__global__ void add(int a, int b, int* c)
{
}

int main()
{
    cudaDeviceProp prop;
    int count;
    HANDLE_ERROR(cudaGetDeviceCount(&count)); //그래픽 카드의 갯수를 가져올 수 있다. 나는 지금 한개니깐 0 번째만 가져와도 상관은 없다.
    for (int i = 0; i < count; i++) {
        HANDLE_ERROR(cudaGetDeviceProperties(&prop, i));
        printf(" --- General Information for device %d ---\n", i);
        printf("Name: %s\n", prop.name);
        printf("Compute capability: %d. %d\n", prop.major, prop.minor);
        printf("Clock rate: %d\n", prop.clockRate);
        printf("Device copy overlap: %s\n", (prop.deviceOverlap?"Enabled":"Disabled"));
        printf("Kernel execition timeout: %s\n", (prop.kernelExecTimeoutEnabled ? "Enabled" : "Disabled"));

        puts("");
        printf(" --- Memory Information for device %d ---\n", i);
        printf("Total global mem: %llu\n", prop.totalGlobalMem); //책과의 차이점.. 아주많은 발달로 엄청난 크기의 메모리를 가지고 있어서 ld 가 아닌 llu-> unsigned long long 을 써야한다.
        printf("Total constant mem: %llu\n", prop.totalConstMem);
        printf("Max mem pitch: %llu\n", prop.memPitch);
        printf("Texture Alignment: %llu\n", prop.textureAlignment);
       
        puts("");
        printf(" --- MP Information for device %d ---\n", i);
        printf("Multiprocessor count: %d\n", prop.multiProcessorCount);
        printf("Shared mem per mp: %llu\n", prop.sharedMemPerBlock);
        printf("Registers per mp: %d\n", prop.regsPerBlock);
        printf("Threads in warp: %d\n", prop.warpSize);
        printf("Max threads per block: %d\n", prop.maxThreadsPerBlock);
        printf("Max thread dimensions: (%d, %d, %d)\n", prop.maxThreadsDim[0], prop.maxThreadsDim[1], prop.maxThreadsDim[2]);
        printf("Max grid dimension: (%d, %d, %d)\n", prop.maxGridSize[0], prop.maxGridSize[1], prop.maxGridSize[2]);
        puts("");
    }

    // 아래 방법을 이용하여 원하는 버전의 GPU를 고를수 있다.
    // 내컴퓨터는 하나밖에 안가지고 있으므로 멀 찾아도 0번째가 나온다.
    int dev;
    HANDLE_ERROR(cudaGetDevice(&dev));
    printf("ID off current CUDA device: %d\n", dev);
    memset(&prop, 0, sizeof(cudaDeviceProp));
    prop.major = 7;
    prop.minor = 5;
    HANDLE_ERROR(cudaChooseDevice(&dev, &prop));
    printf("ID of CUDA device closest to revision 1.3: %d\n", dev);
    HANDLE_ERROR(cudaSetDevice(dev));

    return 0;
}