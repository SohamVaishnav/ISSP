%driver

%(a): 500 samples of xn and v2n
phi = randi([-4 4], 500, 1);
n = 0:499;
w0 = pi/20;
dn = sin(n.*w0 + phi);
gn = randn(500, 1); %Gaussian noise

xn = dn + gn; %500 samples of xn

v2n = zeros(500, 1);
v2n(1) = gn(1);
for k = 2:500 %500 samples of v2n
    v2n(k) = 0.8*v2n(k-1) + gn(k);
end

%(c): test the noise cancellor with p=2, 4 and 6
errors = [];
for k = 2:2:6
    [h, err] = noise_estimator(v2n, gn, k);
    gn_est = cconv(h, v2n);
    figure;
    plot(0:length(gn_est)-1, gn_est);
    hold on;
    plot(0:499, gn);
    xlim([0 500]);
    title("original noise v\s estimated noise | p = ",k);
    xlabel("n");
    ylabel("noise(n)");
    legend("estimate", "original", "northeast");
    errors = cat(1, err, errors);
end
figure;
plot(2:2:6, errors);
title("error v/s order");
xlabel("order");
ylabel("error");

%(d): analysis of effects of signal leakage into secondary mic
p = 2; alpha = 0.1;
v0n = v2n + alpha.*dn(1);
[h, err] = noise_estimator(v0n, gn, p);
gn_est = cconv(h, v0n);
figure;
plot(0:length(gn_est)-1, gn_est);
hold on;
plot(0:499, gn);
xlim([0 500]);
title("original noise v\s estimated noise | p=2, \alpha=0.1");
xlabel("n");
ylabel("noise(n)");
legend("estimate", "original", "northeast");

p = 2; alpha = 1;
v0n = v2n + alpha.*dn(1);
[h, err] = noise_estimator(v0n, gn, p);
gn_est = cconv(h, v0n);
figure;
plot(0:length(gn_est)-1, gn_est);
hold on;
plot(0:499, gn);
xlim([0 500]);
title("original noise v\s estimated noise | p=2, \alpha=1");
xlabel("n");
ylabel("noise(n)");
legend("estimate", "original", "northeast");

p = 2; alpha = 10;
v0n = v2n + alpha.*dn(1);
[h, err] = noise_estimator(v0n, gn, p);
gn_est = cconv(h, v0n);
figure;
plot(0:length(gn_est)-1, gn_est);
hold on;
plot(0:499, gn);
xlim([0 500]);
title("original noise v\s estimated noise | p=2, \alpha=10");
xlabel("n");
ylabel("noise(n)");
legend("estimate", "original", "northeast");

p = 4; alpha = 1.5;
v0n = v2n + alpha.*dn(1);
[h, err] = noise_estimator(v0n, gn, p);
gn_est = cconv(h, v0n);
figure;
plot(0:length(gn_est)-1, gn_est);
hold on;
plot(0:499, gn);
xlim([0 500]);
title("original noise v\s estimated noise | p=4, \alpha=1.5");
xlabel("n");
ylabel("noise(n)");
legend("estimate", "original", "northeast");

p = 4; alpha = 5;
v0n = v2n + alpha.*dn(1);
[h, err] = noise_estimator(v0n, gn, p);
gn_est = cconv(h, v0n);
figure;
plot(0:length(gn_est)-1, gn_est);
hold on;
plot(0:499, gn);
xlim([0 500]);
title("original noise v\s estimated noise | p=4, \alpha=5");
xlabel("n");
ylabel("noise(n)");
legend("estimate", "original", "northeast");

p = 6; alpha = 10;
v0n = v2n + alpha.*dn(1);
[h, err] = noise_estimator(v0n, gn, p);
gn_est = cconv(h, v0n);
figure;
plot(0:length(gn_est)-1, gn_est);
hold on;
plot(0:499, gn);
xlim([0 500]);
title("original noise v\s estimated noise | p=6, \alpha=10");
xlabel("n");
ylabel("noise(n)");
legend("estimate", "original", "northeast");


%(b): WH equations and the noise cancellation filter - function
function [h, err] = noise_estimator(v2n, gn, order)
[rv2_est, lags_v2] = xcorr(v2n, 500, "normalized");
Rv2_est = toeplitz(rv2_est(lags_v2 >= 0 & lags_v2 <= order));
[rv2_g_est, lags_joint] = xcorr(gn, v2n, 500, "normalized");
h = Rv2_est\(rv2_g_est(lags_joint >= 0 & lags_joint <= order)); %WH equation

err = mean(abs(gn - cconv(h, v2n, 500)).^2);
end

