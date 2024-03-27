syms Rx(A, delta);
syms rd(A, delta);
Rx(A, delta) = [A/2 + A*delta/2, A/pi - A/(1.414*pi) + A*(pi/4 + delta)*sinc(1/4 + delta/pi)/pi, A*(pi/4 + delta)*sinc(1/2 + 2*delta/pi)/pi - A/pi;
    A/pi - A/(1.414*pi) + A*(pi/4 + delta)*sinc(1/4 + delta/pi)/pi, A/2 + A*delta/2, A/pi - A/(1.414*pi) + A*(pi/4 + delta)*sinc(1/4 + delta/pi)/pi;
    A*(pi/4 + delta)*sinc(1/2 + 2*delta/pi)/pi - A/pi, A/pi - A/(1.414*pi) + A*(pi/4 + delta)*sinc(1/4 + delta/pi)/pi, A/2 + A*delta/2];
rd(A, delta) = [A/2 ; A/pi ; 0];

%disp(Rx\rd); %filter coeffs
if (1/2 - conj(rd(1, 1)')*(Rx(1, 1)\rd(1, 1)) > 1*1/(2*pi)) %error comparison with (a)
    disp("the FIR filter has higher error than that in (a)");
else 
    disp("the FIR filter has lower error than that in (a)")
end
if (1/2 - conj(rd(1, 1)')*(Rx(1, 1)\rd(1, 1)) > 1*1/(pi)) %error comparison with (b)
    disp("the FIR filter has higher error than that in (b)");
else 
    disp("the FIR filter has lower error than that in (b)");
end