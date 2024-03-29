###
 # @Author: Shuangchi He / Yulv
 # @Email: yulvchi@qq.com
 # @Date: 2022-02-12 11:50:45
 # @Motto: Entities should not be multiplied unnecessarily.
 # @LastEditors: Shuangchi He
 # @LastEditTime: 2022-04-06 18:35:29
 # @FilePath: /Correlation_and_Agreement_Analysis/run.sh
 # @Description: Statistical Analysis for Pearson Correlation and Bland-Altman Agreement with Python, R, Julia and Matlab
### 

## Python
python ./Python/Correlation_Agreement.py \
    --M_predict 0.125 0.95 0.55 0.60 0.78 0.46 0.88 0.50 0.93 0.35 0.975 0.725 0.285 0.166 0.666 0.888 0.233 \
    --M_GT 0.127 0.97 0.53 0.57 0.72 0.49 0.91 0.52 0.90 0.37 0.982 0.718 0.277 0.175 0.666 0.88 0.2333 \
    >./Python/note.log 2>&1

## R
Rscript ./R/Correlation_Agreement.R

## Julia
julia ./Julia/Correlation_Agreement.jl

## Matlab
cd ./Matlab
plot_Pearson_Correlation_Bland_Altman_Agreement([0.125, 0.95, 0.55, 0.60, 0.78, 0.46, 0.88, 0.50, 0.93, 0.35, \
0.975, 0.725, 0.285, 0.166, 0.666, 0.888, 0.233], [0.127, 0.97, 0.53, 0.57, 0.72, 0.49, 0.91, 0.52, 0.90, 0.37, \
0.982, 0.718, 0.277, 0.175, 0.666, 0.88, 0.2333])
