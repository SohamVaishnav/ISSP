vn = randn(24, 1); %Guassian Noise

%(a): a(1) = 0, a(2) = -0.81, b(0) = 1
x = zeros(24, 1);
%assuming x to be causal
x(1) = vn(1);
x(2) = vn(2);
for k = 3:24
    x(k) = -0.81*x(k-2) + vn(k);
end
[rvx_est, lag] = xcorr(vn, x, "normalized"); %autocorrelation for noise

%(b): sample autocorrelation estimation
[rx_est, lags] = xcorr(x, "normalized");
figure;
plot(lags, rx_est);
title("(b): sample autocorrelation estimation");
xlabel("k");
ylabel("values");

%(c): PSD of estimated autocorrelation function
Sx = DT_Fourier(rx_est, 0, -pi:pi/16:pi);
figure;
plot(-pi:pi/16:pi, (abs(Sx)));
title("(c): PSD of estimated autocorrelation function");
ylabel("S_x(w)");
xlabel("w");

%(d): Estimating system parameters using Yule-Walker equations
Rx = [rx_est(lags == 0) rx_est(lags == -1);
    rx_est(lags == 1) rx_est(lags == 0)];
r = [rx_est(lags == 1);
    rx_est(lags == 2)];
a = Rx\r;
b0 = sqrt((rx_est(lags == 0) - a(1)*rx_est(lags == -1) - a(2)*rx_est(lags == -2))/(rvx_est(lag == 0)));
disp([a;b0]);

%(e): PSD using estimates
j = 1j;
w = -pi:pi/16:pi;
Sx_est = (b0^(2))./(abs(1 - a(1)*exp(-j*w) - a(2)*exp(-2*j*w)).^2);
figure;
plot(w, (abs(Sx_est)));
hold on;
plot(w, abs(Sx));
title("Estimated v/s original power spectrum");
xlabel("w");
ylabel("Sx");
legend("S_{x est}(w)", "S_{x}", "northeast");