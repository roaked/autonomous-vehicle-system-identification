function a = rasta_V3(in)

PORTNUMBER = 'COM5'; % set the correct number of the port here

currenttime = in(1);
actionleft = round(in(2)); % this is the value that will be sent to the left wheel
if actionleft < 0
    actionleft = 0;
elseif actionleft > 255
    actionleft = 255;
else
    actionleft = round(actionleft);
end % now we know actionleft is an integer in the [0,255] range
actionright = round(in(3)); % ditto, right wheel
if actionright < 0
    actionright = 0;
elseif actionright > 255
    actionright = 255;
else
    actionright = round(actionright);
end % now we know actionright is an integer in the [0,255] range

Ts = in(4); % sample time
% L = 0.295; % distance between wheels
r = in(5); % wheel radius

global port % to communication with the mobile robot
global x % position of the same --- THIS LINE MAY BE MARKED AS AN ERROR BY THE DEBUGGER, BUT IT'S QUITE ALRIGHT THANK YOU VERY MUCH
global encl_last encr_last % last value of the encoders of the same

if currenttime == 0
    whatsopen = instrfind; % find what ports have been open
    for k = 1 : length(whatsopen)
        if strcmp( whatsopen(k).Status , 'open' ) % if there's an open port...
            fclose(whatsopen(k)); % ...close it
        end
    end % now we know everything's closed
    port = serial(PORTNUMBER,'Baudrate',38400,'Databits',8,'Stopbit',2,'Parity','none');
    fopen(port); % now the port is open
    x = 0; % initial position is 0
    fwrite(port , [uint8(0) uint8(3*16+5)] , 'uint8') % reset encoders
    
    fwrite(port , [uint8(0) uint8(52) uint8(0)] , 'uint8') % define the actuation to independent speed mode
    fwrite(port , [uint8(0) uint8(50) uint8(128)] , 'uint8') % initialization with motors stopped...
    fwrite(port , [uint8(0) uint8(49) uint8(128)] , 'uint8') % same
    
    while 1 % keep trying till we succeed
        fwrite(port, [uint8(0) uint8(37)] , 'uint8') % ask data from the encoders...
        aenc = fread(port, 8); % ...and get the answer as a sequence of bits
        if ~isempty(aenc)
            break % we finally got it
        end
    end
    encl_last = aenc(4)+256*aenc(3)+256^2*aenc(2)+256^3*aenc(1); % left wheel: integer number, base 10
    encr_last = aenc(8)+256*aenc(7)+256^2*aenc(6)+256^3*aenc(5); % right wheel, ditto
else
    fwrite(port , [uint8(0) uint8(52) uint8(0)] , 'uint8') % define the actuation to independent speed mode
    try % let's see if we can get a reading from the encoders (it fails quite often, I'm afraid)
        fwrite(port, [uint8(0) uint8(37)] , 'uint8') % ask data from the encoders...
        aenc = fread(port, 8); % ...and gets the answer as a sequence of bits
        encl = aenc(4)+256*aenc(3)+256^2*aenc(2)+256^3*aenc(1); % left wheel: integer number, base 10
        encr = aenc(8)+256*aenc(7)+256^2*aenc(6)+256^3*aenc(5); % right wheel, ditto
    catch % if there is no encoder data, just presume everything is as it used to be
        encl = encl_last; encr = encr_last;
    end
    Vencr = ( encr - encr_last ) * (2*pi/360)* r / Ts; % velocity, right wheel (there are 360 impulses per turn)
    Vencl = ( encl - encl_last ) * (2*pi/360)* r / Ts; % velocity, left wheel
    x = x + (Vencr + Vencl)/2 * Ts; % position is updated
    encr_last = encr; encl_last = encl; % current encoder readings will be the last ones the next time
    fwrite(port , [uint8(0) uint8(50) uint8(actionright)] , 'uint8') % signals are sent to the motors: right...
    fwrite(port , [uint8(0) uint8(49) uint8(actionleft)] , 'uint8') % ...and left
end
a = [x, encl_last, encr_last];