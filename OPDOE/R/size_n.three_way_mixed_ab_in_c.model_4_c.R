#(size n.three way mixed ab in c. model 4 c)
# Section 3.4.3.3 test factor C in AxB

# Three way mixed classification. (AxB)>C, Model IV
# Factor A, B are random. C is fixed. Determining n
# a, b and c are given. Testing hypothesis about factor C in AxB
size_n.three_way_mixed_ab_in_c.model_4_c <-  function(alpha, beta, delta, a, b, c, cases)
{
	n <- 2
	dfn <- a*b*(c-1)
	dfd <- a*b*c*(n-1)
	if (cases == "maximin")
	{
		lambda <- 0.5*n*delta*delta
	}
	else if (cases == "minimin")
	{
		lambda <- 0.25*a*b*c*n*delta*delta
	}
	beta.calculated <- Beta(alpha, dfn, dfd, lambda)
	if (is.nan(beta.calculated) || beta.calculated < beta )
	{
   warning(paste("Given parameter will result in too high power.",
                 "To continue either increase the precision or ",
                 "decrease the level of factors."))
               return(NA)
	}
	else
	{
		n <- 5    
		n.new <- 1000
		while (abs(n -n.new)>1e-6)
		{
			n <- n.new
			dfn <- a*b*(c-1)
			dfd <- a*b*c*(n-1)
			lambda <- ncp(dfn,dfd,alpha,beta)
			if (cases == "maximin")
			{
				n.new <- 2*lambda/(delta*delta)
			}
			else if (cases == "minimin")
			{
				n.new <- 4*lambda/(a*b*c*delta*delta)
			}
		}  
		return(ceiling(n.new))
	}
}


# example
# size.3_4_3_3.test_factor_C(0.05, 0.1, 0.5, 6, 5, 4, "maximin")
# size.3_4_3_3.test_factor_C(0.05, 0.1, 0.5, 6, 5, 4, "minimin")


