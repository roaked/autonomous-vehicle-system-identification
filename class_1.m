function class_1

disp('This function builds a reference for the forward movement of the Rasteirinho.')
disp('Each group will have to follow a different reference.')
disp('If the group has less than three members, input 0 as the number of the non-existing members.')

number1 = input('Input the student number of the first member of the group: ');
number2 = input('Input the student number of the second member of the group: ');
number3 = input('Input the student number of the third member of the group: ');
rng(number1 + number2 + number3); % this sets a seed for the generation of random numbers
file = strrep( ['data_' num2str(setdiff( [number1 number2 number3] , 0 )) '.xls'] , ' ' , '_' ); % lets now find the name of the file we want

disp('Please wait while your Excel file is being built...')

% forward movement
xlswrite(file, {'Forward movement (measured during laboratory class 1)'}, 'Sheet1', 'A6');
xlswrite(file, {'beta_l'}, 'Sheet1', 'A8');
xlswrite(file, {'beta_r'}, 'Sheet1', 'B8');
xlswrite(file, {'beta average'}, 'Sheet1', 'C8');
xlswrite(file, {'Delta beta'}, 'Sheet1', 'D8');
xlswrite(file, {'left encoder after running'}, 'Sheet1', 'E8');
xlswrite(file, {'right encoder after running'}, 'Sheet1', 'F8');
xlswrite(file, {'distance travelled'}, 'Sheet1', 'G8');
xlswrite(file, {'time elapsed'}, 'Sheet1', 'H8');
beta1 = randi(6) + 4; % 5, 6, 7, 8, 9 or 10
beta2 = randi(5) + 11; % 12, 13, 14, 15 or 16
xlswrite(file, 0, 'Sheet1', 'C9');
xlswrite(file, beta1, 'Sheet1', 'C10');
xlswrite(file, beta2, 'Sheet1', 'C11');
xlswrite(file, -beta1, 'Sheet1', 'C12');
xlswrite(file, -beta2, 'Sheet1', 'C13');
xlswrite(file, beta2, 'Sheet1', 'C14');
xlswrite(file, -beta2, 'Sheet1', 'C15');
xlswrite(file, 0, 'Sheet1', 'D9');
xlswrite(file, 0, 'Sheet1', 'D10');
xlswrite(file, 0, 'Sheet1', 'D11');
xlswrite(file, 0, 'Sheet1', 'D12');
xlswrite(file, 0, 'Sheet1', 'D13');
xlswrite(file, 0, 'Sheet1', 'D14');
xlswrite(file, 0, 'Sheet1', 'D15');
xlswrite(file, {'2 s'}, 'Sheet1', 'H9');
xlswrite(file, {'2 s'}, 'Sheet1', 'H10');
xlswrite(file, {'2 s'}, 'Sheet1', 'H11');
xlswrite(file, {'2 s'}, 'Sheet1', 'H12');
xlswrite(file, {'2 s'}, 'Sheet1', 'H13');
xlswrite(file, {'2 s'}, 'Sheet1', 'H14');
xlswrite(file, {'2 s'}, 'Sheet1', 'H15');
xlswrite(file, {'run this beta average a second time'}, 'Sheet1', 'I14');
xlswrite(file, {'run this beta average a second time'}, 'Sheet1', 'I15');

disp('You might want to go somewhere else and come back later on...')

% rotation

xlswrite(file, {'Rotation (measured during laboratory class 1)'}, 'Sheet1', 'A17');
xlswrite(file, {'beta_l'}, 'Sheet1', 'A19');
xlswrite(file, {'beta_r'}, 'Sheet1', 'B19');
xlswrite(file, {'beta average'}, 'Sheet1', 'C19');
xlswrite(file, {'Delta beta'}, 'Sheet1', 'D19');
xlswrite(file, {'time to rotate pi/2 rad'}, 'Sheet1', 'E19');
xlswrite(file, {'time to rotate pi rad'}, 'Sheet1', 'F19');
xlswrite(file, {'time to rotate 3pi/2 rad'}, 'Sheet1', 'G19');
xlswrite(file, {'time to rotate 2pi rad'}, 'Sheet1', 'H19');
delta1 = randi(4) + 3; % 4, 5, 6 or 7
delta2 = randi(5) + 8; % 9, 10, 11, 12 or 13
xlswrite(file, 0, 'Sheet1', 'C20');
xlswrite(file, 0, 'Sheet1', 'C21');
xlswrite(file, 0, 'Sheet1', 'C22');
xlswrite(file, 0, 'Sheet1', 'C23');
xlswrite(file, 0, 'Sheet1', 'C24');
xlswrite(file, 0, 'Sheet1', 'D20');
xlswrite(file, delta1, 'Sheet1', 'D21');
xlswrite(file, delta2, 'Sheet1', 'D22');
xlswrite(file, -delta1, 'Sheet1', 'D23');
xlswrite(file, -delta2, 'Sheet1', 'D24');

disp('There is still some time to go...')

% values

xlswrite(file, {'Values measured during laboratory classes 1 and 2'}, 'Sheet1', 'A26');
xlswrite(file, {'value'}, 'Sheet1', 'B28');
xlswrite(file, {'units'}, 'Sheet1', 'C28');
xlswrite(file, {'r'}, 'Sheet1', 'A29');
xlswrite(file, {'L'}, 'Sheet1', 'A30');
xlswrite(file, {'d_1'}, 'Sheet1', 'A31');
xlswrite(file, {'d_2'}, 'Sheet1', 'A32');
xlswrite(file, {'d_3'}, 'Sheet1', 'A33');
xlswrite(file, {'frame rate'}, 'Sheet1', 'A34');

disp('Sorry, we''re not done yet...')

% header
if number1, xlswrite(file, number1, 'Sheet1', 'A1'); xlswrite(file, {'Name:'}, 'Sheet1', 'B1'); end
if number2, xlswrite(file, number2, 'Sheet1', 'A2'); xlswrite(file, {'Name:'}, 'Sheet1', 'B2'); end
if number3, xlswrite(file, number3, 'Sheet1', 'A3'); xlswrite(file, {'Name:'}, 'Sheet1', 'B3'); end
xlswrite(file, {'Rasteirinho serial number:'}, 'Sheet1', 'A4')

disp('OK, now your file is ready to use!')