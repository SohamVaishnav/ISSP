w0 = 0.01*pi;
t = 0:999;
dn = sin(w0*t); %desired signal
gn = randn(1000, 1); %Gaussian noise
vn = gn + 0.5*delayseq(gn, 2);
xn = dn' + vn; %input signal

[rv, lag] = xcorr(vn, 1000, "normalized");

%a: the minimum value of k0 should be such that cross correlation of x and v
%is 0 for all k beyond k0

[rvx, lag_vx] = xcorr(vn, xn, 1000, "normalized");

k0 = 0;
count = 0;
for k = 1:length(rvx)
    for l = k+1:length(rvx)
        if (abs(rvx(l)) < 0.05) %threshold is set at 0.05 because pure 0 not possible
            count = count + 1;
        else 
            count = 0;
        end
    end
    if (count == length(rvx) - k)
        k0 = lag_vx(k);
        break;
    else 
        count = 0;
    end
end

%but theoretically, for this problem, k0 can be taken as 3 -> minimum value of delay required;

%c: k0 = {3, ..., 25} and p = {5, 10, 15, 20}
beta = 0.25;
for p = 20
    for k0 = 25
        input_signal = delayseq(xn, k0);
        IS = convmtx(input_signal, p);
        [w, en] = NLMS(zeros(length(input_signal), 1), p, beta, IS, xn, 1);
        dn_out = cconv(input_signal, w);
        figure;
        subplot (311)
        plot(dn);
        title("original signal d(n)");
        subplot (312)
        plot(xn);
        title("corrupted signal x(n)");
        subplot (313)
        plot(dn_out(1:1000));
        title("filtered output d'(n)");
    end
end

%d: let order be 4;
order = 20;
input_signal = delayseq(xn, 25);
[rdx, lag_dx] = xcorr(xn, input_signal, 1000, "normalized");
[rx, lag_x] = xcorr(input_signal, input_signal, 1000, "normalized");
Rx = toeplitz(rx(lag_x >= 0 & lag_x <= order));
w_Wiener = Rx\rdx(lag_dx >= 0 & lag <= order);
IS = convmtx(input_signal, order+1);
[w_NLMS, en] = NLMS(zeros(1000, 1), order+1, 0.25, IS, xn, 1);

fprintf("Wiener Coeffs:\n");
disp(w_Wiener);
fprintf("NLMS Coeffs:\n");
disp(w_NLMS);

error_W_NLMS = w_NLMS - w_Wiener';
mse = mean(abs(error_W_NLMS).^2);
fprintf("Error or difference in Wiener and Adaptive Coeffs is: %d\n", mse);

figure;
subplot(211)
plot(cconv(input_signal, w_NLMS));
title("Adaptive filter output");
subplot(212)
plot(cconv(input_signal, w_Wiener));
title("Wiener filter output");

%b: NLMS for noise cancellation;
function [w_new, en] = NLMS(w_prev, p, beta, xn, dn, k) %NLMS filter
    l2_norm = conj(xn(k,:))*xn(k,:).';
   [r, c] = size(xn);
    if (k == 1) 
        en = dn(1);
        w_new = 0 + (beta/(l2_norm+0.001))*en*conj(xn(1,:));
        k = k+1;
        w_prev = w_new;
        [w_new, en] = NLMS(w_prev, p, beta, xn, dn, k);
        return;
    else
        en = dn(k) - w_prev*xn(k,:).';
        w_new = w_prev + (beta/(l2_norm+0.001))*en*conj(xn(k,:));
        w_prev = w_new;
        if (k == r-p+1)
            return
        else 
            k = k+1;
            [w_new, en] = NLMS(w_prev, p, beta, xn, dn, k);
        end
    end 
end