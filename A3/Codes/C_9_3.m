gn = zeros(1, 1000); %unidentified system impulse response
gn(1) = 1;
gn(2) = 1.8;
gn(3) = 0.81;

xn = randn(1000, 1); %input signal to the unidentified system

dn = cconv(xn, gn); %desired signal

vn = randn(1000, 1); %Gaussian noise

%a: gamma = 0.1, order = 4, beta = 0.1
gamma = 0.1;
dn_corrupted = dn(1:1000) + gamma*vn;
p = 5; beta = 0.1;
X = convmtx(xn, p);
[w_NLMS, en_NLMS] = NLMS_recursive(zeros(1000, 1), p, beta, X, dn_corrupted, 1);

dn_NLMS_out = cconv(xn, w_NLMS);
fprintf("the final coeffs for the 4th order adaptive filter are:\n");
for k = 1:p
    disp(w_NLMS(k));
end

figure;
subplot(311)
plot(dn);
title("original signal: (a) | order 4");
xlim([0 1000]);
subplot(312)
plot(dn_corrupted);
title("corrupted signal: (a) | order 4");
xlim([0 1000]);
subplot(313)
plot(dn_NLMS_out);
title("output of filter: (a) | order 4");
xlim([0 1000]);

%for order = 5;
p = 6; beta = 0.1;
X = convmtx(xn, p);
[w_NLMS, en_NLMS] = NLMS_recursive(zeros(1000, 1), p, beta, X, dn_corrupted, 1);

dn_NLMS_out = cconv(xn, w_NLMS);
fprintf("the final coeffs for the 5th order adaptive filter are:\n");
for k = 1:p
    disp(w_NLMS(k));
end

figure;
subplot(311)
plot(dn);
title("original signal: (a) | order 5");
xlim([0 1000]);
subplot(312)
plot(dn_corrupted);
title("corrupted signal: (a) | order 5");
xlim([0 1000]);
subplot(313)
plot(dn_NLMS_out);
title("output of filter: (a) | order 5");
xlim([0 1000]);

%b: gamma = 1
gamma = 1;
dn_corrupted = dn(1:1000) + gamma*vn;
p = 5; beta = 0.1;
X = convmtx(xn, p);
[w_NLMS, en_NLMS] = NLMS_recursive(zeros(1000, 1), p, beta, X, dn_corrupted, 1);

dn_NLMS_out = cconv(xn, w_NLMS);
fprintf("the final coeffs for the 4th order adaptive filter are:\n");
for k = 1:p
    disp(w_NLMS(k));
end

figure;
subplot(311)
plot(dn);
title("original signal: (b) | order 4");
xlim([0 1000]);
subplot(312)
plot(dn_corrupted);
title("corrupted signal: (b) | order 4");
xlim([0 1000]);
subplot(313)
plot(dn_NLMS_out);
title("output of filter: (b) | order 4");
xlim([0 1000]);