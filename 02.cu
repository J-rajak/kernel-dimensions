#include <stdio.h>
#include <errno.h>
#include <cuda_runtime_api.h>

/****************************************************************************
 * An experiment with cuda kernel invocation parameters. Two threads on  
 * three blocks should yield six kernel invocations.
 *
 * Compile with:
 *   nvcc -o 02 02.cu
 * 
 * Dr Kevan Buckley, University of Wolverhampton, January 2018
 *****************************************************************************/

__global__ void kernel(){
  int i = (blockIdx.x * blockDim.x) + threadIdx.x;

  printf("gd(%4d,%4d,%4d) bd(%4d,%4d,%4d) bi(%4d,%4d,%4d) ti(%4d,%4d,%4d) %d\n",
    gridDim.x, gridDim.y, gridDim.z, 
    blockDim.x, blockDim.y, blockDim.z,
    blockIdx.x, blockIdx.y, blockIdx.z,
    threadIdx.x, threadIdx.y, threadIdx.z, i); 
}

void advice(){
  printf("\ngd = gridDim\n");
  printf("bd = blockDim\n");  
  printf("bi = blockIdx\n");  
  printf("ti = threadIdx\n\n");
}

int main() {
  cudaError_t error;

  advice();

  kernel <<<2, 3>>>();
  cudaDeviceSynchronize();

  error = cudaGetLastError();
  
  if(error){
    fprintf(stderr, "Kernel launch returned %d %s\n", 
      error, cudaGetErrorString(error));
    return 1;
  } else {
    fprintf(stderr, "Kernel launch successful.\n");
  }
}

