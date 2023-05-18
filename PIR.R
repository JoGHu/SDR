#Parametric Inverse Regression

# ------------------------------------------------------------------------------------

#exponent Function
#a is vector whose entries are to be raised to the power pow 
#pow is vector whose entries are the powers to raise a to

exponent <- function(a, pow) {
  
  #Initialize matrix whose columns will be the vector a raise to the corresponding power in pow
  R <- matrix(0, nrow = length(a), ncol = length(pow))
  
  #Function to determine if power is a whole number
  whole.num <- function(x){return(abs(x-round(x)) == 0)}
  
  #Loop through desired powers
  for(i in 1:length(pow)){
    
    #Determine if power is whole number
    if(whole.num(pow[i])){
      R[,i] <- a^pow[i]
    }else{
      R[,i] <- (abs(a)^pow[i])*sign(a)
    }
    
  }
  
  #Return matrix whose columns are vector a raised to corresponding powers
  return(R)
  
}

# ------------------------------------------------------------------------------------

#PIR function
#X is matrix of covariates
#y is response vector
#m is vector which each entry is power that standardized response is raised to
#r is number of dimensions to return

PIR <- function(X, y, m, r){
  
  #Covariance matrix of covariates
  cvm <- cov(X)
  
  #Get inverse square root matrix
  signrt <- matpower(cvm, -1/2)
  
  #Center X
  XC <- t(t(X)-apply(X, 2, mean))
  
  #Standardize X
  XST <- XC%*%signrt
  
  #Standardized y
  ystand <- (y - mean(y))/sd(y)
  
  #Create matrix whose columns are standardized response raised to various powers
  f <- numeric()
  for(i in m){
    f <- cbind(f, exponent(ystand, i))
  }
  
  #Get covariance matrices
  sigxf <- cov(XST, f)
  sigff <- var(f)
  
  #Get PIR matrix
  PIRmat <- sigxf%*%solve(sigff)%*%t(sigxf)
  
  #Ensure PIR is symmetric
  PIRmat <- matpower(t(PIRmat)%*%PIRmat, 1/2)
  
  #Get eigenvalue decomposition of PIRmat
  eigdec <- eigen(PIRmat)
  
  #Return eigenvalues as lambda, desired eigenvectors as a matrix gamma
  return(list(lambda = eigdec$values, 
              gamma = signrt%*%eigdec$vectors[,1:r]))
}
