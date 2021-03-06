stats <- function(datum, m, n, p)
{
    if(n == 1)
    {
        g <- array(dim = c(1, p, m - 1))
        media <- colMeans(datum)             # m�dia das colunas dos dados
        m1 <- matrix(media, m, p, byrow = T) # matriz com as 20 médias
        w <- datum - m1                      # array com a diferença de X - Xbarra
        for(i in 1:m-1)
        {
            v <- matrix(datum[i + 1, ] - datum[i, ], nrow = 1, ncol = p)
            g[, , i] <- v
        }
        p1 <- matrix(unlist(split(as.matrix(g), rep(1:p, each = 1))), nrow = m - 1, ncol = p)
        S <- (t(p1) %*% (p1)) / (2 * (m - 1))
        return(list(media, S, w))
    }
    if(n > 1)
    {
        q <- array(dim = c(p, p, m))
        w <- array(dim = c(n, p, m))
        M2 <- array(dim = c(n, p, m))
        media <- colMeans(datum)                    # m�dia de cada face do array, deve ser uma matriz com 20 linhas e 2 colunas
        m1 <- matrix(media, m, p, byrow = T)        # matriz com as 20 m�dias
        mm <- colMeans(m1)                          # m�dia das m�dias
        for(i in 1:m)
        {
            M1 <- matrix(m1[i, ], n, p, byrow = T)  # repetindo cada m�dia da matriz m1 para construir o array de médias e subtrair dos dados
            M2[, , i] <- M1                         # guardando as repeti��es em um array
        }
        w <- datum - M2                             # array com a diferen�a de X - Xbarra
        for(i in 1:m)
        {
            S <- (t(w[, , i]) %*% w[, , i]) / (n-1) # matriz S
            q[, , i] <- S
        }
        mS <- rowMeans(q, dims = 2)                 # m�dia da matriz de var-cov
        return(list(mm, mS, m1))
    }
}