#!/usr/bin/env python
# coding=utf-8
'''
Author: Shuangchi He / Yulv
Email: yulvchi@qq.com
Date: 2022-02-11 14:55:18
Motto: Entities should not be multiplied unnecessarily.
LastEditors: Shuangchi He
LastEditTime: 2022-02-19 11:24:40
FilePath: /Correlation_and_Agreement_Analysis/Python/Correlation_Agreement.py
Description: Statistical Analysis for Pearson Correlation and Bland-Altman Agreement
'''
import matplotlib.pylab as pl
from pylab import *
import math
import numpy as np
import argparse
import os


def linear_fit(x, y):
    N = float(len(x))
    sum_x, sum_y, sum_xx, sum_yy, sum_xy = 0, 0, 0, 0, 0
    for i in range(0, int(N)):
        sum_x += x[i]
        sum_y += y[i]
        sum_xx += x[i] * x[i]
        sum_yy += y[i] * y[i]
        sum_xy += x[i] * y[i]

    a = (sum_y * sum_x / N - sum_xy) / (sum_x * sum_x / N - sum_xx)
    b = (sum_y - a * sum_x) / N

    r = abs(sum_y * sum_x / N - sum_xy) / math.sqrt((sum_xx - sum_x * sum_x / N) * (sum_yy - sum_y * sum_y / N))

    return a, b, r


def plot_Pearson_Correlation(X, Y, linefit_TF=False, hist_TF=False,
                             xlabel="Measurement_predict", ylabel="Measurement_GT", title="Pearson Correlation",
                             savedir='{}/Measurement_Pearson_Correlation.png'.format(os.path.dirname(__file__))):
    print('Measurement_predict:\n{}\nMeasurement_GT:\n{}\nNum:{}'.format(X, Y, len(X)))

    plt.gcf().set_facecolor(np.ones(3) * 240 / 255)
    fig, ax1 = pl.subplots()
    ax1.scatter(X, Y, s=8, facecolors='none', edgecolors='r', label='Num : %d' % len(X), linewidth=1)

    ax1.plot([np.min(np.concatenate([X, Y])), np.max(np.concatenate([X, Y]))], [
             np.min(np.concatenate([X, Y])), np.max(np.concatenate([X, Y]))], 'k--', label='Equal Line', alpha=0.35)

    if linefit_TF:
        a, b, r = linear_fit(X, Y)  # Linear fit.
        ax1.plot(sort(X), sort(a * X + b), 'b--', label="linear_fit : y = %.5f x + %.5f ,\npearson coefficient : %.5f" %
                 (a, b, r), alpha=0.4)
        print('linear_fit: y = {} x + {}\npearson coefficient: {}\n'.format(a, b, r))

    ax1.set_xlabel(xlabel)
    ax1.set_ylabel(ylabel)
    plt.title(title)
    plt.legend(loc=0, ncol=1)

    if hist_TF:
        ax2 = ax1.twinx()  # Create a second axis.
        ax2.hist(X, bins=len(X), facecolor='yellowgreen', alpha=0.35)
        ax2.set_ylabel('Frequency')

    plt.gcf().autofmt_xdate()
    plt.savefig(savedir)
    plt.close()


def plot_Bland_Altman_Agreement(X, Y, linefit_TF=False,
                                xlabel='Mean of Measurement_predict and Measurement_GT', ylabel='Difference between Measurement_predict and Measurement_GT', title="Bland-Altman Agreement",
                                savedir='{}/Measurement_Bland-Altman_Agreement.png'.format(os.path.dirname(__file__))):
    data_mean = np.array((X + Y) / 2)  # Mean of two measurements.
    data_diff = np.array(X - Y)  # Difference between two measurements.
    mean_diff = np.mean(data_diff)  # Mean of difference between two measurements.
    std_diff = np.std(data_diff, ddof=1)  # Std deviation of difference between two measurements.
    # Python np.std divides by N by default. Set ddof=1 to divide by N-1.
    print('data_mean: {}\ndata_diff: {}\nDiff num: {}\nMean_Diff: {}\nStd_Diff: {}\nnMean_Diff+1.96 Std_Diff: {}\nnMean_Diff-1.96 Std_Diff: {}'.format(
        data_mean, data_diff, len(X), mean_diff, std_diff, mean_diff + 1.96 * std_diff, mean_diff - 1.96 * std_diff))

    plt.gcf().set_facecolor(np.ones(3) * 240 / 255)
    plt.scatter(data_mean, data_diff, s=10, facecolors='none', edgecolors='r',
                label='Diff  num : %d' % len(X), linewidth=1)

    plt.plot(sort(data_mean), sort(mean_diff * np.ones((len(data_mean), 1), dtype=np.uint8)), 'k--',
             label='Mean_Diff : %.5f' % mean_diff, alpha=0.5)  # Mean difference line.
    plt.plot(sort(data_mean), sort((mean_diff + 1.96 * std_diff) * np.ones((len(data_mean), 1), dtype=np.uint8)), 'b--',
             label='Mean_Diff + 1.96 Std_Diff : %.5f' % (mean_diff + 1.96 * std_diff), alpha=0.5)  # Mean plus 1.96*Std_Diff line.
    plt.plot(sort(data_mean), sort((mean_diff - 1.96 * std_diff) * np.ones((len(data_mean), 1), dtype=np.uint8)), 'b-.',
             label='Mean_Diff - 1.96 Std_Diff : %.5f' % (mean_diff - 1.96 * std_diff), alpha=0.5)  # Mean minus 1.96*Std_Diff line.

    if linefit_TF:
        a, b, r = linear_fit(data_mean, data_diff)  # Linear fit.
        plt.plot(sort(data_mean), sort(data_mean * a + b), 'y--',
                 label="linear_fit : y = %.5f x + %.5f" % (a, b), alpha=0.5)
        print('linear_fit: y = {} x + {}'.format(a, b))

    plt.legend(loc=0, ncol=1)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    plt.title(title)
    plt.savefig(savedir)
    plt.close()


def main(args):
    X = np.array(args.M_predict)
    Y = np.array(args.M_GT)

    plot_Pearson_Correlation(X, Y, linefit_TF=args.PC_linefit_TF, hist_TF=args.hist_TF,
                             xlabel=args.PC_xlabel, ylabel=args.PC_ylabel, title=args.PC_title, savedir=args.PC_savedir)

    plot_Bland_Altman_Agreement(X, Y, linefit_TF=args.BAA_linefit_TF,
                                xlabel=args.BAA_xlabel, ylabel=args.BAA_ylabel, title=args.BAA_title, savedir=args.BAA_savedir)


if __name__ == "__main__":
    parse = argparse.ArgumentParser(description='SP_Cls train')

    parse.add_argument('--M_predict', nargs='+', type=float,
                       default=[0.125, 0.95, 0.55, 0.60, 0.78, 0.46, 0.88, 0.50, 0.93,
                                0.35, 0.975, 0.725, 0.285, 0.166, 0.666, 0.888, 0.233],
                       help="Data 1, Measurement_predict")
    parse.add_argument('--M_GT', nargs='+', type=float,
                       default=[0.127, 0.97, 0.53, 0.57, 0.72, 0.49, 0.91, 0.52, 0.90,
                                0.37, 0.982, 0.718, 0.277, 0.175, 0.666, 0.88, 0.2333],
                       help="Data 2, Measurement_GT")

    parse.add_argument('--PC_linefit_TF', type=bool, default=True)
    parse.add_argument('--hist_TF', type=bool, default=False)
    parse.add_argument('--PC_xlabel', default="Measurement_predict (mm)")
    parse.add_argument('--PC_ylabel', default="Measurement_GT (mm)")
    parse.add_argument('--PC_title', default="Pearson Correlation")
    parse.add_argument('--PC_savedir',
                       default='{}/Measurement_Pearson_Correlation.png'.format(os.path.dirname(__file__)))

    parse.add_argument('--BAA_linefit_TF', type=bool, default=True)
    parse.add_argument('--BAA_xlabel', default="Mean of Measurement_predict and Measurement_GT (mm)")
    parse.add_argument('--BAA_ylabel', default="Diff between Measurement_predict and Measurement_GT (mm)")
    parse.add_argument('--BAA_title', default="Bland-Altman Agreement")
    parse.add_argument('--BAA_savedir',
                       default='{}/Measurement_Bland-Altman_Agreement.png'.format(os.path.dirname(__file__)))

    args = parse.parse_args()
    assert type(args.M_predict) is list and type(args.M_GT) is list and len(args.M_predict) == len(
        args.M_GT), 'The input data M_predict and M_GT must be lists of the same length.'
    print('{}\n'.format(args))

    main(args)

    # python Correlation_Agreement.py --M_predict 0.125 0.95 0.55 0.60 0.78 0.46 0.88 0.50 0.93 0.35 0.975 0.725 0.285 0.166 0.666 0.888 0.233 --M_GT 0.127 0.97 0.53 0.57 0.72 0.49 0.91 0.52 0.90 0.37 0.982 0.718 0.277 0.175 0.666 0.88 0.2333
