function [w_new, en] = NLMS_recursive(w_prev, p, beta, xn, dn, k) %NLMS filter
    l2_norm = conj(xn(k,:))*xn(k,:).';
   [r, c] = size(xn);
    if (k == 1) 
        en = dn(1);
        w_new = 0 + (beta/l2_norm)*en*conj(xn(1,:));
        k = k+1;
        w_prev = w_new;
        [w_new, en] = NLMS_recursive(w_prev, p, beta, xn, dn, k);
        return;
    else
        en = dn(k) - w_prev*xn(k,:).';
        w_new = w_prev + (beta/l2_norm)*en*conj(xn(k,:));
        w_prev = w_new;
        if (k == r-p+1)
            return
        else 
            k = k+1;
            [w_new, en] = NLMS_recursive(w_prev, p, beta, xn, dn, k);
        end
    end 
end