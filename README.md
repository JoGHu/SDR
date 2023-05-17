# Sufficient Dimension Reduction
R functions to perform sufficient dimension reduction.

## Sliced Inverse Regression
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

## Kernel Inverse Regression
### KIR Function

*Arguments*

- X - covariate matrix
- Y - response vector
- b - bandwidth parameter
- r - number of dimensions to return

*Output*

- lambda - eigenvalues of the SIR matrix
- gamma - matrix containing the desired number of SIR directions

## Miscellaneous
### GetSDRDirs Function 

- Purpose: Function to project covariates along SDR directions

*Arguments*
- betas - matrix of SDR directions
- X - covariate matrix

*Output*
- centered covariates projected along SDR directions
