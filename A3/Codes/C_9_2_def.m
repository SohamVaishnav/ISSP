gn = zeros(1, 1000); %unidentified system impulse response
gn(1) = 1;
gn(2) = 1.8;
gn(3) = 0.81;

%d: Learning curve estimate
xn = randn(100, 1000);

dn = zeros(100, 1999);
E = zeros(100, 1000);

for k = 1:100
    dn(k,:) = cconv(gn, xn(k,:));
end

for k = 1:100
    rx = xcorr(xn(k,:), 1000, "normalized");
    Px = fftshift(fft(rx));
    u_max = 2/max(abs(Px));
    u = 0.1*u_max;
    p = 5;
    x = xn(k,:)';
    X = convmtx(x, p);
    [w, en] = LMS(zeros(p, 1), p, u, X, dn(k,:)');
    E(k,:) = en.^2;
end

mse = zeros(1, 1000);
for k = 1:1000
    for l = 1:100
        mse(k) = mse(k) + E(l,k)/l;
    end
end

figure;
plot(mse);

%e: (b) and (d) with u = 0.01*u_max and u = 0.2*u_max
%(b):
factors = [0.01, 0.2];
for k = 1:2
    rx = xcorr(xn(1,:), 1000, "normalized");
    Px = fftshift(fft(rx));
    u_max = 2/max(abs(Px));
    u = factors(k)*u_max;
    x = xn(1,:)';
    X = convmtx(x, p);
    [w_b, en_b] = LMS(zeros(p, 1), 5, u, X, dn(1,:)');

    figure;
    subplot(211)
    plot(dn(1,:));
    xlim([0 1000]);
    subplot(212)
    plot(cconv(x, w_b));
    xlim([0 1000]);

    for l = 1:100
        rx = xcorr(xn(l,:), 1000, "normalized");
        Px = fftshift(fft(rx));
        u_max = 2/max(abs(Px));
        u = factors(k)*u_max;
        x = xn(l,:)';
        X = convmtx(x, p);
        [w, en] = LMS(zeros(p, 1), p, u, X, dn(l,:)');
        E(l,:) = en.^2;
    end

    mse = zeros(1, 1000);
    for j = 1:1000
        for m = 1:100
            mse(j) = mse(j) + E(m,j)/m;
        end
    end
    figure;
    plot(mse);
end

%f: (b) and (d) with p=3 and p=4
%(b):
for p = 3:4
    rx = xcorr(xn(1,:), 1000, "normalized");
    Px = fftshift(fft(rx));
    u_max = 2/max(abs(Px));
    u = 0.1*u_max;
    x = xn(1,:)';
    X = convmtx(x, p);
    [w_b, en_b] = LMS(zeros(p, 1), p, u, X, dn(1,:)');

    figure;
    subplot(211)
    plot(dn(1,:));
    xlim([0 1000]);
    subplot(212)
    plot(cconv(x, w_b));
    xlim([0 1000]);

    for l = 1:100
        rx = xcorr(xn(l,:), 1000, "normalized");
        Px = fftshift(fft(rx));
        u_max = 2/max(abs(Px));
        u = 0.1*u_max;
        x = xn(l,:)';
        X = convmtx(x, p);
        [w, en] = LMS(zeros(p, 1), p, u, X, dn(l,:)');
        E(l,:) = en.^2;
    end

    mse = zeros(1, 1000);
    for j = 1:1000
        for m = 1:100
            mse(j) = mse(j) + E(m,j)/m;
        end
    end
    figure;
    plot(mse);
end