function [w, en] = LMS(w0, p, u, xn, dn)
    w_prev = w0;
    [r, c] = size(xn);
    en = zeros(r-p+1, 1);
    for k = 1:r-p+1
        en(k) = dn(k) - w_prev'*xn(k,:)';
        w = w_prev + u*en(k)*conj(xn(k,:)');
        w_prev = w;
    end
end