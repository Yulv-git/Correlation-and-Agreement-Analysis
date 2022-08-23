#=
Author: Shuangchi He / Yulv
Email: yulvchi@qq.com
Date: 2022-02-15 12:32:43
LastEditors: Shuangchi He
LastEditTime: 2022-02-25 21:45:58
Description: Statistical Analysis for Pearson Correlation and Bland-Altman Agreement
=#
using Polynomials
using PyPlot
using Statistics


function Pearson_Correlation_Bland_Altman_Agreement(X, Y)
    # Pearson Correlation
    linearfit=fit(X, Y, 1)  # Linear fit.
    k = linearfit[1]
    b = linearfit[0]

    scatter(X, Y, label="Num: $(length(X))", color="r", s=8)
    plot(sort(X), sort(X * k .+ b), color="b", linestyle="--",
        label="linear_fit: y = $(round(k, digits=5)) x + $(round(b, digits=5))\npearson coefficient: $(round(cor(X, Y), digits=5))")
    plot([findmin([findmin(X)[1], findmin(Y)[1]])[1], findmax([findmax(X)[1], findmax(Y)[1]])[1]], [findmin([findmin(X)[1], findmin(Y)[1]])[1], findmax([findmax(X)[1], findmax(Y)[1]])[1]],
        color="k", linestyle="--", label="Equal Line")

    xlabel("Measurement_predict (mm)")
    ylabel("Measurement_GT (mm)")
    title("Pearson Correlation")
    legend(loc=0)
    savefig("Measurement_Pearson_Correlation.png")
    close()

    # Bland-Altman Agreement
    data_mean = (X + Y) / 2.
    data_diff = X - Y
    mean_diff = mean(data_diff)
    std_diff = std(data_diff)  # Julia std defaults to correcting for bias in sample variance by dividing by N-1.

    linearfit2=fit(data_mean, data_diff, 1)  # Linear fit.
    k2 = linearfit2[1]
    b2 = linearfit2[0]

    scatter(data_mean, data_diff, label="Diff num: $(length(data_mean))", color="r", s=8)
    plot(sort(data_mean), sort(mean_diff * ones(length(data_mean))), color="k", linestyle="--",
        label="Mean_Diff: $(round(mean_diff, digits=5))")
    plot(sort(data_mean), sort((mean_diff .+ 1.96 * std_diff) * ones(length(data_mean))), color="b", linestyle="--",
        label="Mean_Diff + 1.96 Std_Diff: $(round(mean_diff + 1.96 * std_diff, digits=5))")
    plot(sort(data_mean), sort((mean_diff .- 1.96 * std_diff) * ones(length(data_mean))), color="b", linestyle="-.",
        label="Mean_Diff - 1.96 Std_Diff: $(round(mean_diff - 1.96 * std_diff, digits=5))")
    plot(sort(data_mean), sort(data_mean * k2 .+ b2), color="y", linestyle="--",
        label="linear_fit: y = $(round(k2, digits=5)) x + $(round(b2, digits=5))")

    xlabel("Mean of Measurement_predict and Measurement_GT (mm)")
    ylabel("Diff between Measurement_predict and Measurement_GT (mm)")
    title("Bland-Altman Agreement")
    legend(loc=0)
    savefig("Measurement_Bland-Altman_Agreement.png")
end


X = [0.125, 0.95, 0.55, 0.60, 0.78, 0.46, 0.88, 0.50, 0.93, 0.35, 0.975, 0.725, 0.285, 0.166, 0.666, 0.888, 0.233]
Y = [0.127, 0.97, 0.53, 0.57, 0.72, 0.49, 0.91, 0.52, 0.90, 0.37, 0.982, 0.718, 0.277, 0.175, 0.666, 0.88, 0.2333]
Pearson_Correlation_Bland_Altman_Agreement(X, Y)

# julia ./Correlation_Agreement.jl
