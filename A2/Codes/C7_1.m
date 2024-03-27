%driver

%(b): alpha = 0.8 and p = 1, 2, ..., 20
vn = randn(20, 1);
errs = [];
for p = 1:20
    [rv_est, lags] = xcorr(vn(1:p), p, "normalized");
    [h, err] = FIR_wiener(rv_est(lags>=0), 0.8, p);
    errs = cat(1, errs, err);
end

figure;
plot(1:20, errs);
title("error v/s order of the filter");
xlabel("order (p)");
ylabel("error");

%(c): p = 10 and alpha = 0.1, 0.2, ..., 0.9
vn = randn(10, 1);
[rv_est, lags] = xcorr(vn, 10, "normalized");
errs = [];
for alpha = 0.1:0.1:0.9
    [h, err] = FIR_wiener(rv_est(lags>=0), alpha, 10);
    errs = cat(1, errs, err);
end

figure;
plot(0.1:0.1:0.9, errs);
title("error v/s alpha");
xlabel("alpha");
ylabel("error");

%(a): wiener filter
function [h, err] = FIR_wiener(rv_est, alpha, order)
k = 0:order;
rdx_est = alpha.^(k);
Rx_est = rdx_est' + rv_est;
Rx_est = toeplitz(Rx_est); %autocorr matrix Rx

h = Rx_est\(rdx_est'); %WH equation

err = rdx_est(1) - conj(rdx_est)*(h);
end