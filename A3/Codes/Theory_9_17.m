xn = zeros(100, 1);
n = 0:33;
j = 1j;
xn(1:34) = exp(j*n*pi/10);
n = 34:66;
xn(35:67) = j*exp(j*n*pi/10);
n = 67:99;
xn(68:100) = -j*exp(j*n*pi/10);

X = convmtx(xn, 4);

w0 = zeros(4, 1);
w0(1) = 0.01;

[w, yn, en] = CMA(w0, 4, 0.1, X);

figure;
plot(abs(yn));
title("3rd order CMA output y(n)");
xlabel("n");
ylabel("y(n)");