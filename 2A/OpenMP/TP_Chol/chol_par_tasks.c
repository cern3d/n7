#include "trace.h"
#include "common.h"

/* This is a sequential routine for the LU factorization of a square
   matrix in block-columns */
void chol_par_tasks(matrix_t A){


  int i, j, k;


  #pragma omp parallel
{
    for(k=0; k<A.NB; k++) {

        #pragma omp single
        potrf(A.blocks[k][k]);

        #pragma omp for
        for(i=k+1; i<A.NB; i++)
            trsm(A.blocks[k][k], A.blocks[i][k]);

        #pragma omp for collapse(2)
        for(i=k+1; i<A.NB; i++)
            for(j=k+1; j<=i; j++)
                gemm(A.blocks[i][k],
                     A.blocks[j][k],
                     A.blocks[i][j]);
    }
}

  return;

}

