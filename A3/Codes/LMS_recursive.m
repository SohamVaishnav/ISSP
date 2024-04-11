function [w_new, en] = LMS_recursive(w_prev, p, u, xn, dn, k) %LMS filter
    [r, c] = size(xn);
    if (k == 1) 
        en = dn(1);
        w_new = 0 + u*en*conj(xn(1,:));
        k = k+1;
        w_prev = w_new;
        [w_new, en] = LMS_recursive(w_prev, p, u, xn, dn, k);
        return;
    else
        en = dn(k) - w_prev*xn(k,:)';
        w_new = w_prev + u*en*conj(xn(k,:));
        w_prev = w_new;
        if (k == r-p+1)
            return
        else 
            k = k+1;
            [w_new, en] = LMS_recursive(w_prev, p, u, xn, dn, k);
        end
    end
end