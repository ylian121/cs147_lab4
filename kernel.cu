#include <stdio.h>
#define BLOCK_SIZE 512
#define NUM_BLOCK 16
#define MAX_SIZE 4096

__global__ void histo_kernel(unsigned int* input, unsigned int* bins, unsigned int num_elements, unsigned int num_bins)
{
	
    /*************************************************************************/
    // INSERT KERNEL CODE HERE
    __shared__ unsigned int histo_private[MAX_SIZE];
    
    if (threadIdx.x < MAX_SIZE) histo_private[threadIdx.x] = 0;
    __syncthreads();
    
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    int stride = blockDim.x * gridDim.x;
    
    int x = 0;
    while(x*stride+i < num_elements){
        atomicAdd(&histo_private[input[x*stride+i]], 1);
        ++x;
    }
    __syncthreads();
    
    //if (threadIdx.x < 7) {
      //  atomicAdd(&(histo[threadIdx.x]), private_histo[threadIdx.x] );
    //}
    x = 0;
    while(x*blockDim.x+threadIdx.x < num_bins){
        atomicAdd(&bins[x*blockDim.x+threadIdx.x], histo_private[x*blockDim.x+threadIdx.x]);
        ++x;
    }
	
	
	  /*************************************************************************/
}

void histogram(unsigned int* input, unsigned int* bins, unsigned int num_elements, unsigned int num_bins) {

	  /*************************************************************************/
    //INSERT CODE HERE
    //dim3 DimGrid((n-1)/BLOCK_SIZE+1, (m-1)/BLOCK_SIZE+1, 1);
    //dim3 DimBlock(BLOCK_SIZE, BLOCK_SIZE, 1);
    histo_kernel<<<NUM_BLOCK, BLOCK_SIZE>>>(input, bins, num_elements, num_bins);


	  /*************************************************************************/

}


