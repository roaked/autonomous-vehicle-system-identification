function G=ir2dtf(g,n,Ts)
%
%	Calculation of discrete time transfer function, G(z), from the 
%   discrete time impulse response g(kTs).
%
%   Inputs:
%	g:     	Discrete time impulse response g=[g0 g1 g2 g3 ...].
% 	n:	    Order of the transfer function to estimate.
%	Ts:     Sample time.
%
%   Output:
%   G:     Discrete time transfer function
%
%   Theory:
%
%   By definition we have,
%
%         b0+b1z^-1+b2z^-2+...+bnz^-n
%   G(z)=-------------------------- = g0+g1z^-1+g2z^-2+...
%         1+a1z^-1+a2z^-2+...+anz^-n
%   
%   multiplying both sides by the denominator yields,
%
%   b0+b1z^-1+b2z^-2+...+bnz^-n = g0+(g1+a1g0)z^-1 + (g2+a1g1+a2g0)z^-2 +
%                                 + (g3+a1g2+a2g1+a3g0)z^-3 + ...
%
%   The coeficients ai and bi of the transfer function my now be calculated
%   by considering the first 2n+1 points of the discrete time impulse
%   response. For the first n+1 points, z^0 through z^-n, we equate the 
%   coeficients on the left hand side to the coeficients of the same order
%   terms on the right hand side resulting:
%   
%    - -     -                               -  - -
%   |b0 |   | 1     0       0       ...    0  ||g0 |
%   |b1 |   | a1    1       0       ...    0  ||g1 |
%   |b2 | = | a2    a1      1       ...    0  ||g2 |
%   |...|   | ...   ...     ...     ...   ... ||...|
%   |bn |   | an    a(n-1)  a(n-2)  ...    1  ||gn |
%    - -     -                               -  - -
%
%   For the last n point, z^-(n+1) through z^-2n, we equate the coeficients
%   on the right hand side to zero, resulting:
%
%    -      -     -                                   -  -    -
%   |-g(n+1) |   | g1    g2      g3      ...    gn     ||an    |
%   |-g(n+2) |   | g2    g3      g4      ...    g(n+1) ||a(n-1)|
%   |-g(n+3) | = | g3    g4      g5      ...    g(n+2) ||a(n-2)|
%   |  ...   |   | ...   ...     ...     ...   ...     ||...   |
%   |-g(2n)  |   | gn    g(n+1)  g(n+2)  ...    g(2n-1)||a1    |
%    -      -     -                                   -  -    -
%   
%   The coeficients of the denominator, ai, are obtained from this last
%   system of equations, and are then used in the first system of equations
%   in order to obtain the coeficients of the numerator, bi.

if length(g)~= 2*n+1
    error('myApp:argChk', 'The length of the discrete time impulse response vector g must be equal to 2*n+1')
end

A = [1 ; flipud(hankel([g(2:n+1)],[g(n+1:end-1)]) \ -g(n+2:end))];
B = tril(toeplitz(A)) * g(1:n+1);
G = tf(B',A',Ts,'Variable','z^-1');
