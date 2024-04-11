function [w_new, yn, en] = CMA(w0, p, u, xn) %CMA filter
    w_prev = w0;
    [r, c] = size(xn);
    yn = zeros(r-p+1, 1);
    en = zeros(r-p+1, 1);
    for k = 1:r-p+1
        yn(k) = conj(w_prev')*xn(k,:).';
        en(k) = 0.5*(abs(yn(k)).^2-1);
        w_new = w_prev + u*conj(yn(k))*xn(k,:).'*en(k);
        w_prev = w_new;
        if (k == 1)
            figure;
            plot(abs(w_new));
            title("3rd order filter coeffs changing over time");
            hold on;
        else
            plot(abs(w_new));
        end
    end
end