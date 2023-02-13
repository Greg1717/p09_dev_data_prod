plot(mpg ~ disp, data=mtcars)
lm1 <- lm(mpg ~ disp, data = mtcars)
abline(lm1)
