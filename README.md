# Sufficient Dimension Reduction
R functions to perform inverse sufficient dimension reduction.

SDR
======
The correspond R files contain code for a variety of inverse suffient dimension reduction techniques for high dimensional data in supervised learning.

Inverse SDR Techniques
- Sliced Inverse Regression (SIR)
- Kernel Inverse Regression (KIR)
- Parametric Inverse Regression (PIR)
- Sliced Average Variance Estimation (SAVE)

Examples
------

Examples with the mtcars dataset with the variable mpg as the response and the variables disp, hp, drat, wt, and qsec as the covariates.

#### SIR Example
```{R}
df <- mtcars

Y <- df$mpg
X <- df[,3:7]

h <- 4
r <- 5

tmp <- SIR(X, Y, h, r, "cont")

dirs <- GetSDRDirs(tmp$gamma, X)
```

#### PIR Example
```{R}
df <- mtcars

Y <- df$mpg
X <- df[,3:7]

m <- c(1/3, 1/2, 1, 2, 3)
r <- 5

tmp <- PIR(X, Y, m, r)

dirs <- GetSDRDirs(tmp$gamma, X)
```
