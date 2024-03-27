syms Rx(a, b, mv);
syms rx(a, b);
Rx(a, b, mv) = [(b+1)*mv (1 + b^2 + 2*a*b)/(1 - a^2) (a + a*b + b)/(1 - a^2); 
    (a+1)*(b+1)*mv (a + a*b + b)/(1 - a^2) (1 + b^2 + 2*a*b)/(1 - a^2); 
    (a^2 + a + 1)*(b+1)*mv (a + a*b)/(1 - a^2) (a + a*b + b)/(1 - a^2)];
rx(a, b) = [(a + a*b + b)/(1 - a^2) ;
    (a + a*b)/(1 - a^2) ; 
    (a + a*b)/(1 - a^2)];

%disp(Rx(a, b, mv)\rx(a, b)); %c
%considering alpha = 1/2, beta = 1 and mv = 0.75, we get
if (4 - conj(rx(1/2, 1)')*(Rx(1/2, 1, 0.75)\rx(1/2, 1)) > 3*64*(9/16 - 4 - 1)/27 + 2*4*64/27) %error comparison with (a)
    disp("the FIR filter has higher error than that in (a)");
else 
    disp("the FIR filter has lower error than that in (a)")
end

