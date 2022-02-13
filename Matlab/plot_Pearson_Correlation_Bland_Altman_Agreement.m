function plot_Pearson_Correlation_Bland_Altman_Agreement(X, Y)
if(size(X)~=size(Y) & (isrow(X) | iscolumn(X)))
    error('The input data X and Y must be one-dimensional matrices of the same size.');
end
if(isrow(X))
    X = X';
    Y = Y';
end

%% Pearson Correlation
fig1 = figure;
plot(X, Y, 'or', 'MarkerSize', 4, 'LineWidth', 1)
hold on;
plot([min(min(X), min(Y)), max(max(X), max(Y))], [min(min(X), min(Y)), max(max(X), max(Y))], 'k--');
linear_fit = polyfit(X, Y, 1);  % Linear fit.
r = corr(X, Y);
plot(X, X .* linear_fit(1) + linear_fit(2), 'b--');

legend(strcat('Num: ', num2str(length(X))),...
    'Equal Line',...
    ['linear fit:y=', num2str(linear_fit(1), '%8.5f'), 'x+', num2str(linear_fit(2), '%8.5f'),...
    newline, 'pearson coefficient:', num2str(r, '%8.5f')]);
grid off;
title('Pearson Correlation');
xlabel('Measurement_predict (mm)','Interpreter','none');
ylabel('Measurement_GT (mm)','Interpreter','none');

imwrite(frame2im(getframe(fig1)), 'Measurement_Pearson_Correlation.png');

%% Bland-Altman Agreement
data_mean = mean([X, Y], 2);  % Mean of two measurements.
data_diff = X - Y;  % Difference between two measurements.
mean_diff = mean(data_diff);  % Mean of difference between two measurements.
std_diff = std(data_diff);  % Std deviation of difference between two measurements.
% Matlab std defaults to correcting for bias in sample variance by dividing by N-1.

fig2 = figure;
plot(data_mean, data_diff, 'or', 'MarkerSize', 4, 'LineWidth', 1)
hold on;
plot(data_mean, mean_diff * ones(1, length(data_mean)), 'k--');  % Mean difference line.
plot(data_mean, (mean_diff + 1.96 * std_diff) * ones(1, length(data_mean)), 'b--');  % Mean plus 1.96*Std_Diff line.
plot(data_mean, (mean_diff - 1.96 * std_diff) * ones(1, length(data_mean)), 'b-.');  % Mean minus 1.96*Std_Diff line.

linear_fit = polyfit(data_mean, data_diff, 1);  % Linear fit.
plot(data_mean, data_mean .* linear_fit(1) + linear_fit(2), 'y--');

legend(strcat('Diff num: ', num2str(length(X))),...
    strcat('Mean_Diff: ', num2str(mean_diff, '%5.3f')),...
    strcat('+1.96 Std_Diff: ', num2str(1.96 * std_diff, '%5.3f')),...
    strcat('-1.96 Std_Diff:-', num2str(1.96 * std_diff, '%5.3f')),...
    ['linear_fit:y=', num2str(linear_fit(1), '%8.5f'), 'x+', num2str(linear_fit(2), '%8.5f')],...
    'Interpreter', 'none');
grid off;
title('Bland-Altman Agreement');
xlabel('Mean of Measurement_predict and Measurement_GT (mm)','Interpreter','none');
ylabel('Diff between Measurement_predict and Measurement_GT (mm)','Interpreter','none');

imwrite(frame2im(getframe(fig2)), 'Measurement_Bland-Altman_Agreement.png');

%% run
% plot_Pearson_Correlation_Bland_Altman_Agreement([0.125, 0.95, 0.55, 0.60, 0.78, 0.46, 0.88, 0.50, 0.93, 0.35, 0.975, 0.725, 0.285, 0.166, 0.666, 0.888, 0.233], [0.127, 0.97, 0.53, 0.57, 0.72, 0.49, 0.91, 0.52, 0.90, 0.37, 0.982, 0.718, 0.277, 0.175, 0.666, 0.88, 0.2333])
