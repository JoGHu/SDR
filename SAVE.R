#SAVE functions

# ------------------------------------------------------------------------------------

#Matrix Power Function
#A is symmetric matrix 
#alpha is desired power of A

matpower <- function(A, alpha){
  
  #Spectral decomposition of A
  tmp <- eigen(A)
  
  #Get eigenvalues of A
  e.vals <- tmp$values
  
  #Replace negative and zero eigenvalues with slight positive value to be able to take inverse square root.
  e.vals[e.vals < 0] <- 1e-10
  
  #Return matrix power using spectral decomposition
  return(tmp$vectors%*%diag((e.vals)^alpha)%*%t(tmp$vectors))
}

# ------------------------------------------------------------------------------------

#Discretize Y Function 
#y is response vector
#h is number of slices

discretize <- function(y, h){
  
  #Get length of Y
  n <- length(y)
  
  #Determine floor of breaks
  m <- floor(n/h)
  
  #Add a jitter to entries (Ensures no ties)
  y <- y + 0.00001*mean(y)*rnorm(n)
  
  #Order entries in response
  yord <- y[order(y)]
  
  #Find division points
  divpt=numeric()
  for(i in 1:(h-1)){
    divpt <- c(divpt, yord[i*m+1])
  }
  
  #Create vector for slice number of each entry of response
  y1 <- rep(0, n)
  y1[y < divpt[1]] <- 1
  y1[y >= divpt[h-1]] <- h
  for(i in 2:(h-1)){
    y1[(y >= divpt[i-1]) & (y < divpt[i])] <- i
  }
  
  #Return slice number of each entry of the response
  return(y1)
}

# ------------------------------------------------------------------------------------

#SAVE function
#X is matrix of covariates
#y is response vector
#h is number of slices
#r is number of dimensions to return
#ytpye denotes whether response is continuous or categorical takes values of "cont" or "cat"


SAVE <- function(X, y, h, r, ytype){
  
  #Ensure X is of type matrix
  X <- as.matrix(X)
  
  #Get dimensions of covariate matrix X
  p <- ncol(X)
  n <- nrow(X)
  
  #Covariance matrix of covariates
  cvm <- cov(X)
  
  #Get inverse square root matrix
  signrt <- matpower(cvm, -1/2)
  
  #Center X
  XC <- t(t(X)-apply(X, 2, mean))
  
  #Standardize X
  XST <- XC%*%signrt
  
  #Determine if Y needs to be discretized
  if(ytype == "cont"){
    ydis <- discretize(y, h)
  }else if(ytype == "cat"){
    ydis <- y
  }else{
    message("Error: Incorrect Response Type")
    return()
  }
  
  #Get labels for Y (Categories)
  ylabel <- unique(ydis)
  
  #Update h if needed (Ensures if categorical response, h is correct)
  h <- length(ylabel)
  
  #Vector to store proportion of response in each slice
  prob <- numeric()
  for(i in 1:h){
    prob <- c(prob, length(ydis[ydis==ylabel[i]])/n)
  }
  
  #Calculate covariance matrices for each slice
  vxy <- array(0,c(p,p,h))
  for(i in 1:h){
    vxy[,,i] <- var(XST[ydis==ylabel[i],])
  }
  
  #Calculate SAVE matrix
  SAVEmat <- 0
  for(i in 1:h){
    SAVEmat <- SAVEmat+prob[i]*(vxy[,,i]-diag(p))%*%(vxy[,,i]-diag(p))
  }
  
  #Get eigenvalue decomp of SAVE matrix
  eigdec <- eigen(SAVEmat)
  
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
