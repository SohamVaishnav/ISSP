gn = zeros(1, 1000); %unidentified system impulse response
gn(1) = 1;
gn(2) = 1.8;
gn(3) = 0.81;

xn = randn(1000, 1); %input signal to the unidentified system

dn = cconv(xn, gn); %desired signal

%a: range of values for u is (0, 2/lambda_max)

%b: p=4, LMS algo, u = 0.1u_max
[rx,lags] = xcorr(xn, 1000, "normalized");
Px = fftshift(fft(rx));
lambda_max = max(abs(Px));
u_max = 2/lambda_max; %max value of u
u = 0.1*u_max;
p = 5;
X = convmtx(xn, p);
[w_LMS, en_LMS] = LMS_recursive(zeros(1000, 1), p, u, X, dn, 1);

dn_LMS = cconv(xn, w_LMS);

figure;
subplot(211)
plot(dn);
title("original signal");
xlim([0 1000]);
subplot(212)
plot(dn_LMS);
title("output of filter: LMS");
xlim([0 1000]);

%c: part(b) using NLMS with beta = 0.1
beta = 0.1;
[w_NLMS, en_NLMS] = NLMS_recursive(zeros(1000, 1), p, beta, X, dn, 1);

dn_NLMS = cconv(xn, w_NLMS);

figure;
subplot(311);
plot(dn);
title("original signal");
xlim([0 1000]);
subplot(312);
plot(dn_NLMS);
title("output of filter: NLMS");
xlim([0 1000]);
subplot(313);
plot(dn_LMS);
title("output of filter: LMS");
xlim([0 1000]);

fprintf("difference in errors in LMS and NLMS filters = %d\n", abs(en_NLMS - en_LMS));


