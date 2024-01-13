function reference = reference_builder

disp('This function builds a reference for the forward movement of the Rasteirinho.')

number1 = input('First digit ');
number2 = input('Second digit ');
number3 = input('Third digit ');
rng(number1 + number2 + number3); % this sets a seed for the generation of random numbers
delta_t1 = randi(4) + 1; % 2, 3, 4 or 5
delta_t2 = randi(4) + 3; % 4, 5, 6 or 7
delta_t3 = randi(4) + 2; % 3, 4, 5 or 6
delta_t4 = randi(4) + 3; % 4, 5, 6 or 7
delta_t5 = randi(6) + 4; % 5, 6, 7, 8, 9 or 10
delta_t6 = randi(6) + 14; % 15, 16, 17, 18, 19 or 20
sample_time = 0.1;
d1 = randi(3) * 0.5; % 0.5, 1.0 or 1.5
while 1
    d2 = randi(3) * 0.5; % 0.5, 1.0 or 1.5
    if d2~=d1, break, end % d1 and d2 are different
end
v = randi(3) * 0.1 + 0.2; % 0.3, 0.4 or 0.5
d3 = randi(3) * 0.5 + 1.5; % 2, 2.5 or 3
order = randi(2) - 1; % 0 or 1

t_aux = (0 : sample_time : delta_t5)';
y_aux = 1/(2*delta_t5) * t_aux.^2; % let's build the parabola first
if order
    t1 = delta_t1;      % step #1
    t2 = t1 + delta_t2; % step #2
    t3 = t2 + delta_t3; % ramp
    t4 = t3 + delta_t4; % stop
    t5 = t4 + delta_t5; % parabola
    t6 = t5 + delta_t6; % stop
    t7 = t6 + 10;        % step #3 (biggest); 1 would be enough for the time, 10 is just to make sure
    y1 = d1;                % step #1
    y2 = y1 + d2;           % step #2
    y3 = y2 + v * delta_t3; % ramp
    y4 = y3 + y_aux(end);   % parabola
    y5 = y4 + d3;           % step #3 (biggest)
%     reference = ...
%         [0, y1;             % step #1
%         t1, y1;
%         t1, y2;             % step #2
%         t2, y2;
%         t3, y3;             % ramp
%         t4, y3;
%         t4+t_aux, y3+y_aux; % parabola
%         t6, y4;
%         t6, y5;             % step #3 (biggest)
%         t7, y5];
    reference = ...
        [ [0:sample_time:t1]' , y1*ones(1+t1/sample_time,1) ;
        [t1:sample_time:t2]' , y2*ones(1+(t2-t1)/sample_time,1) ;
        [t2:sample_time:t3]' , [y2:(y3-y2)/((t3-t2)/sample_time):y3]' ;
        [t3:sample_time:t4]' , y3*ones(1+(t4-t3)/sample_time,1) ;
        t4+t_aux , y3+y_aux ;
        [t5:sample_time:t6]' , y4*ones(1+(t6-t5)/sample_time,1) ;
        [t6:sample_time:t7]' , y5*ones(1+(t7-t6)/sample_time,1) ];
else
    t1 = delta_t1;      % step #1
    t2 = t1 + delta_t2; % step #2
    t3 = t2 + delta_t5; % parabola
    t4 = t3 + delta_t6; % stop
    t5 = t4 + delta_t3; % ramp
    t6 = t5 + delta_t4; % stop
    t7 = t6 + 10;        % step #3 (biggest); 1 would be enough for the time, 10 is just to make sure
    y1 = d1;                % step #1
    y2 = y1 + d2;           % step #2
    y3 = y2 + y_aux(end);   % parabola
    y4 = y3 + v * delta_t3; % ramp
    y5 = y4 + d3;           % step #3 (biggest)
%     reference = ...
%         [0, y1;             % step #1
%         t1, y1;
%         t1, y2;             % step #2
%         t2, y2;
%         t2+t_aux, y2+y_aux; % parabola
%         t4, y3;
%         t5, y4; % ramp
%         t6, y4;
%         t6, y5;             % step #3 (biggest)
%         t7, y5];
    reference = ...
        [ [0:sample_time:t1]' , y1*ones(1+t1/sample_time,1) ;
        [t1:sample_time:t2]' , y2*ones(1+(t2-t1)/sample_time,1) ;
        t2+t_aux , y2+y_aux ;
        [t3:sample_time:t4]' , y3*ones(1+(t4-t3)/sample_time,1) ;
        [t4:sample_time:t5]' , [y3:(y4-y3)/((t5-t4)/sample_time):y4]' ;
        [t5:sample_time:t6]' , y4*ones(1+(t6-t5)/sample_time,1) ;
        [t6:sample_time:t7]' , y5*ones(1+(t7-t6)/sample_time,1) ];
end
