kinf.BN = function(G, whole=FALSE)
{
    p = apply(G, 1, mean, na.rm=T)/2                            # missing value in G is allowed
    sel = (p>0.01) & (p<0.99)                                   # only use SNP with MAF > 0.01
    G = G[sel,]
    p = p[sel]

    w = sweep(G, 1, 2*p)
    temp = !is.na(w)
    GG = crossprod(w, w)

    if (!whole) list(total = GG, count = count)      # to be averaged later after all chromosomes are processed
    else GG/count
}