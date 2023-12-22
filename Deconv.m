function g=Deconv(U,Y,Ts)
%
%	Deconvolution Method
%
%	Inputs:	
%       U=[u(0), u(Ts), u(2*Ts), ... , u((N-1)*Ts)         ]
%		Y=[      y(Ts), y(2*Ts), ... , y((N-1)*Ts), y(N*Ts)]
%		Ts = Sample Time
%
%	Output:
%		g=[g(0), g(Ts), g(2*Ts), ... , g((N-1)*Ts)]
%
%	Theory:
%       The convolution integral is written as:
%       
%              /t
%       y(t) = |  g(tau)*u(t-tau) dtau
%              /0
%
%       After discretization with sample time Ts and
%
%       u(t)=u(kTs),  kTs < t < (k+1)Ts and k=0,1,2,...,N-1
%       g(t)=g(kTs),  kTs < t < (k+1)Ts and k=0,1,2,...,N-1 
%       
%       results:
%                   _k-1
%       y(kTs) = Ts*>    u(iTs)*g((k-1)Ts-iTs),   k=1,2,...,N
%                   -i=0		
%
%       k=1: y( Ts) = ( u(0)g(0) )Ts
%       k=2: y(2Ts) = ( u(0)g(Ts)  + u(Ts)g(0) )Ts
%       k=3: y(3Ts) = ( u(0)g(2Ts) + u(Ts)g(Ts) + u(2Ts)g(0) )Ts
%        ...
%       
%       Therefore, in matrix form we may write
%               
%        -    -     -                                          -  -        -
%       |y(Ts) |   | u(0)        0          0         ...    0  ||g(0)      |
%       |y(2Ts)|   | u(Ts)      u(0)        0         ...    0  ||g(Ts)     |
%       |y(3Ts)|=Ts| u(2Ts)     u(Ts)      u(0)       ...    0  ||g(2Ts)    |
%       | ...  |   | ...        ...        ...        ...   ... ||...       |
%       |y(NTs)|   | u((N-1)Ts) u((N-2)Ts) u((N-3)Ts) ...   u(0)||g((N-1)Ts)|
%        -    -     -                                          -  -        -
%       
%       or Y = Ts * Umatrix * g
%       
%       from which we may calculate g as g = Umatrix \ (Y./Ts) .
%
%       With \ (left matrix devide), rather than explicitly using inv as in 
%       g = inv(Umatrix)*(Y./Ts), matlab uses a forward method to 
%       solve for g which is computationally more efficient, and similar 
%       to the recursive solution:
%       
%       g(0)       = 1/u(0) *   1/Ts y(Ts)
%       g(Ts)      = 1/u(0) * ( 1/Ts y(2Ts) - u(Ts)g(0) )
%       g(2Ts)     = 1/u(0) * ( 1/Ts y(3Ts) - u(2Ts)g(0) - u(Ts)g(Ts) )
%         ...
%       g((N-1)Ts) = 1/u(0) * ( 1/Ts y(NTs) - SUM_i=1^(N-1) u(iTs)g((N-1-i)Ts) )
%
%       resulting
%
%       g(kTs) = 1/u(0) * ( 1/Ts y((k+1)Ts) - SUM_i=1^k u(iTs)g((k-i)Ts) )

g = tril(toeplitz(U)) \ (Y./Ts);
