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

## References

- Li, K.-C. (1991). Sliced inverse regression for dimension reduction. Journal of the American
Statistical Association, 86(414):316–327.
- Zhu, L.-X. and Fang, K.-T. (1996). Asymptotics for kernel estimate of sliced inverse regression.
The Annals of Statistics, 24(3):1053–1068.
- Dong, Y., Yu, Z., and Sun, Y. (2013). A note on robust kernel inverse regression. Statistics and
its Interface, 6:45–52.
- Bura, E. and Cook, R. D. (2001). Estimating the structural dimension of regressions via parametric inverse regression. Journal of the Royal Statistical Society. Series B (Statistical Methodology), 63(2):393–410.
- Cook, R. D. and Weisberg, S. (1991). Sliced inverse regression for dimension reduction: Comment.
Journal of the American Statistical Association, 86(414):328–332.
- Li, D. and Zhou, E. (2018). Sufficient Dimension Reduction Methods and Applications with R.
Chapman and Hall/CRC.
