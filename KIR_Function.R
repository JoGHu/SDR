#KIR functions

# ------------------------------------------------------------------------------------

#Gaussian Kernel Function
#b is bandwidth parameter 
#y is response vector

kern <- function(y, b){
  return(1/(b*sqrt(2*pi))*exp(-0.5*(y)^2/b^2))
}


# ------------------------------------------------------------------------------------

#KIR function
#X is matrix of covariates
#y is response vector
#b is bandwidth parameter
#r is number of dimensions to return

KIR <- function(X, Y, b, r){
  
  #Ensure X is of type matrix
  X <- as.matrix(X)
  
  #Get dimensions of covariate matrix X
  n <- nrow(X)
  p <- ncol(X)
  
  #Standardize response vector
  Y.std <- (Y - mean(Y))/sd(Y)
  
  #Standardize covariate matrix
  XC <- t(t(X)-apply(X,2,mean))
  signrt <- matpower(var(X),-1/2)
  XST <- XC%*%signrt
  
  #Matrix to store value of each row of X scaled by kernel function
  Exy <- matrix(0, nrow = n, ncol = p)
  for(j in 1:n){
    w <- kern(apply(cbind(Y.std, rep(-Y.std[j],n)),1,sum)*(1/b),b)
    tot <- sum(w)
    Exy[j,] <- colSums(XST*w/tot)
  }
  
  #KIR matrix (Approximated variance)
  KIRmat <- 1/n*t(Exy)%*%Exy
  
  #Get eigenvalue decomposition of KIRmat
  eigdec <- eigen(KIRmat)
  
  #Return eigenvalues as lambda, desired eigenvectors as a matrix gamma
  return(list(lambda = eigdec$values, 
              gamma = signrt%*%eigdec$vectors[,1:r]))
}

# ------------------------------------------------------------------------------------

#GetSDRDirs function
#betas is matrix of desired eigenvectors to multiply by centered version of X
#X is matrix of covariates

GetSDRDirs <- function(betas, X){
  
  #Ensure X is of type matrix
  X <- as.matrix(X)
  
  #Get dimensions of covariate matrix X
  p <- ncol(X)
  n <- nrow(X)
  
  #Get matrix whose rows are replicates of the overall mean vector
  X.bar <- matrix(rep(as.numeric(colMeans(X)), 
                      n),
                  ncol = p, 
                  nrow = n, 
                  byrow = T)
  
  #Return SDR directions
  return((X-X.bar)%*%betas)
}