# SDR
R functions to perform sufficient dimension reduction.

## SIR
### SIR Function

*Arguments*

- X - covariate matrix
- y - response vector
- h - number of slices
- r - number of dimensions to return
- ytpye - denotes whether response is continuous or categorical takes values of "cont" or "cat"

*Output*

- lambda - eigenvalues of the SIR matrix
- gamma - matrix containing the desired number of SIR directions

### GetSDRDirs Function

*Arguments*
- betas - matrix of SDR directions
- X - covariate matrix

*Output*
- centered covariates projected along SDR directions
