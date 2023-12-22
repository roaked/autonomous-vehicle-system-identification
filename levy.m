function [G, J, handle] = levy (w, gain, phase, Q, weights)

% [G, J, handle] = levy (w, gain, phase, Q, weights)
% This function returns a model for a plant with a known frequency behaviour.
% The model is
%
%       Q.num(1)         Q.num(2)                   Q.num(end-2)             Q.num(end-1)  
% b(1)*s         + b(2)*s         + ... + b(end-2)*s             + b(end-1)*s             + b(end)
% ------------------------------------------------------------------------------------------------
%       Q.den(1)         Q.den(2)                   Q.den(end-2)             Q.den(end-1)  
% a(1)*s         + a(2)*s         + ... + a(end-2)*s             + a(end-1)*s             +   1
%
% == INPUTS ==
%
% The function receives the gain (dB) and the phase (degrees) for frequencies w (rad/s).
% Q.num is a vector with numerator coefficients and Q.den a vector with denominator coefficients.
% E.g. for model
%
%     b(1)*s + b(2)
% ----------------------
%       2
% a(1)*s  + a(2)*s +   1
%
% we make
%   Q.num = [1 0]; Q.den = [2 1 0]
% Notice that order 0 coefficients are always presumed and must be given as the last elements in Q.num and Q.den.
% If weights is 0 all frequencies carry the same weight in the result;
% otherwise, weights are used to try to correct a high-frequency bias by weighting more low frequency data.
%
% == OUTPUTS ==
%
% G is a structure with fields num and den, containing vectors b and a respectively.
% J is the quadratic error per sampling frequency.
% If output handle exists, a handle for a Bode plot will be returned.
%
% == THEORY ==
%
% See Val�rio, Tejado - IDENTIFYING A NON-COMMENSURABLE FRACTIONAL TRANSFER FUNCTION FROM A FREQUENCY RESPONSE. In: FSS 2013
% (second formulation, summed matrices)
%
% Duarte Val�rio 2007-2013

if nargin < 5, weights = 0; end % no weights by default
if Q.num(end) || Q.den(end)
    error('Q.num(end) and Q.den(end) must be 0.')
end
if size(w, 1) < size(w, 2)
    w = w'; % now w is a column vector for sure
end
if size(gain, 1) < size(gain, 2)
    gain = gain'; % now w is a column vector for sure
end
if size(phase, 1) < size(phase, 2)
    phase = phase'; % now w is a column vector for sure
end
n = length(Q.den)-1;
m = length(Q.num)-1;
Q.num = Q.num(end:-1:1); % this is just for convenience: Matlab uses decreasing orders in tf, while the paper this file is based upon uses increasing orders
Q.den = Q.den(end:-1:1);

A = 10.^(gain/20); % this is the gain in absolute value
ef = deg2rad(phase); % this is the phase is rad
if weights
    weight = [w(2)-w(1);
              w(3:end)-w(1:end-2);
              w(end)-w(end-1)];
    weight = (weight/2) ./ (w.^2);
else
    weight = ones(size(w)); % no weights = all weights equal to 1
end

M0 = eye(n+1,n+1)*0;
M1 = eye(n+1,m+1)*0;
M2 = eye(m+1,n+1)*0;
M3 = eye(m+1,m+1)*0;

for s = 1:length(w)
    for i = 0:n
        for k = 0:n
            M0(k+1,i+1) = M0(k+1,i+1) + A(s) * w(s)^(Q.den(i+1)) * cos( (Q.den(k+1)-Q.den(i+1))*pi/2 ) * weight(s);
        end
        for k = 0:m
            M2(k+1,i+1) = M2(k+1,i+1) + A(s) * w(s)^(Q.den(i+1)) * cos( ef(s)-(Q.num(k+1)-Q.den(i+1))*pi/2 ) * weight(s);
        end
    end

    for i = 0:m
        for k = 0:n
            M1(k+1,i+1) = M1(k+1,i+1) - w(s)^(Q.num(i+1)) * cos( ef(s)+(Q.den(k+1)-Q.num(i+1))*pi/2 ) * weight(s);
        end
        for k = 0:m
            M3(k+1,i+1) = M3(k+1,i+1) - w(s)^(Q.num(i+1)) * cos( (Q.num(k+1)-Q.num(i+1))*pi/2 ) * weight(s);
        end
    end
end

MAT = [M0 M1;
       M2 M3];

b = -MAT(2:n+m+2, 1);
MAT = MAT(2:n+m+2, 2:n+m+2);

coefficients = MAT \ b;
G.num = (coefficients(end:-1:n+1)).'; % ...again the increasing/decreasing order thing
G.den = [coefficients(n:-1:1); 1]';

% index J
if nargout > 1 % quadratic error was required
    tempNum = 0;
    for c = 1:length(G.num)
        tempNum = tempNum + G.num(c) * (1i*w).^(Q.num(m-c+2)); % strage way to match G and Q... because of the increasing/decreasing order thing again!
    end
    tempDen = 0;
    for c = 1:length(G.den)
        tempDen = tempDen + G.den(c) * (1i*w).^(Q.den(n-c+2));
    end
    J = sum((abs(10.^(gain/20).*exp(1i*deg2rad(phase)) - tempNum./tempDen)).^2) / length(w);
end

% Bode plot
if nargout == 3 % a Bode plot was required
    wNew = logspace(floor(log10(min(w))), ceil(log10(max(w))), max(50, length(w))); % vector with frequencies for drawing the Bode plot
    tempNum = 0;
    for c = 1:length(G.num)
        tempNum = tempNum + G.num(c) * (1i*wNew).^(Q.num(m-c+2));
    end
    tempDen = 0;
    for c = 1:length(G.den)
        tempDen = tempDen + G.den(c) * (1i*wNew).^(Q.den(n-c+2));
    end
    gainNew = 20 * log10(abs(tempNum ./ tempDen));
    phaseNew = rad2deg(unwrap(angle(tempNum ./ tempDen)));
    handle = figure;
    subplot(2,1,1), semilogx(w,gain,'.', wNew,gainNew)
    subplot(2,1,2), semilogx(w,phase,'.', wNew,phaseNew)
end
