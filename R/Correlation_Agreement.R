# Statistical Analysis for Pearson Correlation and Bland-Altman Agreement
Pearson_Correlation_Bland_Altman_Agreement <- function(X, Y){
    # Pearson Correlation
    XY_min = min(min(X), min(Y))
    XY_max = max(max(X), max(Y))
    data_Num = length(X)
    pearson_r = cor(X, Y)

    png('Measurement_Pearson_Correlation.png')
    plot(X, Y, type='p', xlab='Measurement_predict (mm)', ylab='Measurement_GT (mm)', col='red', main='Pearson Correlation')
    lines(c(XY_min, XY_max), c(XY_min, XY_max), col='black', lty=2)

    line.model <- lm(Y~X)
    b = line.model$coefficients[[1]]
    k = line.model$coefficients[[2]]

    clip(min(X), max(X), min(Y), max(Y) + (max(Y) - min(Y)) / 6)
    abline(line.model, lwd=1, col="blue", lty=2)

    legend('top', c(paste("Num:", data_Num), "Equal",
        paste("linear_fit: y =", round(k, 5), "x +", round(b, 5)), paste("pearson coefficient:", round(pearson_r, 5))),
        col=c("red", "black", "blue"), pch=c('o', '', '', ''), lty=c(0, 2, 2))

    # Bland-Altman Agreement
    data_mean = (X + Y) /2
    data_diff = X - Y
    mean_diff = mean(data_diff)
    std_diff = sd(data_diff)

    png('Measurement_Bland-Altman_Agreement.png')
    plot(data_mean, data_diff, ylim=c(min(- 1.96 * std_diff, min(data_diff)), max(+ 1.96 * std_diff, max(data_diff))), type='p',
        xlab='Mean of Measurement_predict and Measurement_GT (mm)', ylab='Diff between Measurement_predict and Measurement_GT (mm)',
        col='red', main='Bland-Altman Agreement')
    lines(sort(data_mean), sort(mean_diff * rep(1, times=data_Num)), col='black', type='l', lty=2)
    lines(sort(data_mean), sort((mean_diff + 1.96 * std_diff) * rep(1, times=data_Num)), col='blue', type='l', lty=1)
    lines(sort(data_mean), sort((mean_diff - 1.96 * std_diff) * rep(1, times=data_Num)), col='blue', type='l', lty=2)

    line2.model <- lm(data_diff~data_mean)
    b2 = line2.model$coefficients[[1]]
    k2 = line2.model$coefficients[[2]]

    clip(min(data_mean), max(data_mean), min(data_diff), max(data_diff) + (max(data_diff) - min(data_diff)) / 6)
    abline(line2.model, lwd=1, col="yellow", lty=2)

    legend('top', c(paste("Num:", data_Num), paste("Mean_Diff:", round(mean_diff, 3)),
        paste("Mean_Diff + 1.96 Std_Diff:", round(mean_diff + 1.96 * std_diff, 3)),
        paste("Mean_Diff - 1.96 Std_Diff:", round(mean_diff - 1.96 * std_diff, 3)),
        paste("linear_fit: y =", round(k2, 5), "x +", round(b2, 5))),
        col=c("red", "black", "blue", "blue", "yellow"), pch=c('o', '', '', '', ''), lty=c(0, 2, 1, 2, 2), bty="n")
}


X <- c(0.125, 0.95, 0.55, 0.60, 0.78, 0.46, 0.88, 0.50, 0.93, 0.35, 0.975, 0.725, 0.285, 0.166, 0.666, 0.888, 0.233)
Y <- c(0.127, 0.97, 0.53, 0.57, 0.72, 0.49, 0.91, 0.52, 0.90, 0.37, 0.982, 0.718, 0.277, 0.175, 0.666, 0.88, 0.2333)
Pearson_Correlation_Bland_Altman_Agreement(X, Y)
