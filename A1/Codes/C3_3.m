%(a) generating Gaussian noise
x = randn(1000, 1);

%(b) estimating autocorrelation function for Gaussian Noise
[rx_est, lags] = xcorr(x, 100, "normalized");

figure;
plot(lags, rx_est);
title("(b): estimated r_x(k) for Gaussian Noise");
ylabel("values");
xlabel("k");

rx = zeros(201, 1);
rx(101) = 1;
estimation_error = mean((rx-rx_est).^2); %mean squared error
fprintf("MSE between estimated rx(k) for 1000 samples of Gaussian Noise and ideal rx(k) = %d\n",estimation_error);

%(c) segmenting and estimating autocorrelation function
rx_est_seg = 0; l = 1;
for k = 1:10
    rx_est_seg = rx_est_seg + xcorr(x(l:100*k), 100, "normalized");
    l = 100*k+1;
end

figure;
plot(-100:100, rx_est_seg);
title("(c): estimated r_x(k) for segmented Gaussian Noise");
ylabel("values");
xlabel("k");

estimation_error_rx = mean((rx-rx_est_seg).^2); %mean squared error
fprintf("MSE between estimated and segmented rx(k) for 1000 samples of Gaussian Noise and ideal rx(k) = %d\n",estimation_error_rx);

estimation_error_rx_est = mean((rx_est - rx_est_seg).^2); %mean squared error
fprintf("MSE between estimated and segmented rx(k) for 1000 samples of Gaussian Noise and unsegmented rx(k) = %d\n",estimation_error_rx_est);

%(d) more number of samples for Gaussian Noise
x = randn(10000, 1);

[rx_est_more, lags] = xcorr(x, 100, "normalized");

figure;
plot(lags, rx_est_more);
title("(d): estimated r_x(k) for Gaussian Noise");
ylabel("values");
xlabel("k");

estimation_error = mean((rx_est-rx_est_more).^2); %mean squared error
fprintf("MSE between estimated rx(k) for 10000 samples of Gaussian Noise and ideal rx(k) = %d\n",estimation_error);
