vn = randn(24, 1); %Guassian Noise

%(a): a(1) = 0, a(2) = -0.81, b(0) = 1
x = zeros(24, 1);
%assuming x to be causal
x(1) = vn(1);
x(2) = vn(2);
for k = 3:24
    x(k) = -0.81*x(k-2) + vn(k);
end

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
plot(-pi:pi/16:pi, abs(Sx));
title("(c): PSD of estimated autocorrelation function");
ylabel("S_x(w)");
xlabel("w");