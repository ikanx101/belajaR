rm(list=ls())

library(deSolve)

LotVmod <- function (Time, State, Pars) {
  with(as.list(c(State, Pars)), {
    dx = 1+(a*x*N)-(c*x)
    return(list(dx))
  })
}

Pars <- c(a = 0.005714286, N = 50, c = 1/3)
State <- c(x = 1)
Time <- seq(0, 120, by = 1)

out <- as.data.frame(ode(func = LotVmod, y = State, parms = Pars, times = Time))
windows()
matplot(out[,-1], type = "l", xlab = "time", ylab = "population")
