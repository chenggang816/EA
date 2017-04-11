function f = evaluate_objective(x, M, V)

%% function f = evaluate_objective(x, M, V)
% Function to evaluate the objective functions for the given input vector
% x. x is an array of decision variables and f(1), f(2), etc are the
% objective functions. The algorithm always minimizes the objective
% function hence if you would like to maximize the function then multiply
% the function by negative one. M is the numebr of objective functions and
% V is the number of decision variables. 
%
% This functions is basically written by the user who defines his/her own
% objective function. Make sure that the M and V matches your initial user
% input. Make sure that the 
%
% An example objective function is given below. It has two six decision
% variables are two objective functions.

% f = [];
% %% Objective function one
% % Decision variables are used to form the objective function.
% f(1) = 1 - exp(-4*x(1))*(sin(6*pi*x(1)))^6;
% sum = 0;
% for i = 2 : 6
%     sum = sum + x(i)/4;
% end
% %% Intermediate function
% g_x = 1 + 9*(sum)^(0.25);
% 
% %% Objective function two
% f(2) = g_x*(1 - ((f(1))/(g_x))^2);

%% Kursawe proposed by Frank Kursawe.
% Take a look at the following reference
% A variant of evolution strategies for vector optimization.
% In H. P. Schwefel and R. M�nner, editors, Parallel Problem Solving from
% Nature. 1st Workshop, PPSN I, volume 496 of Lecture Notes in Computer 
% Science, pages 193-197, Berlin, Germany, oct 1991. Springer-Verlag. 
%
% Number of objective is two, while it can have arbirtarly many decision
% variables within the range -5 and 5. Common number of variables is 3.
func_flag = 'ZDT1';
switch(func_flag)
    case 'SCH'
        F1 = @f11;  %Ŀ�꺯��1
        F2 = @f12;  %Ŀ�꺯��2
        n = 1;      %����ά��
        L = -1000;  %�±߽�
        U = 1000;   %�ϱ߽�
    case 'FON'
        F1 = @f21;  %Ŀ�꺯��1
        F2 = @f22;  %Ŀ�꺯��2
        n = 3;      %����ά��
        L = -4;  %�±߽�
        U = 4;   %�ϱ߽�
    case 'POL'
        F1 = @f31;  %Ŀ�꺯��1
        F2 = @f32;  %Ŀ�꺯��2
        n = 2;      %����ά��
        L = -pi;  %�±߽�
        U = pi;   %�ϱ߽�
    case 'KUR'
        F1 = @KUR_F1;  %Ŀ�꺯��1
        F2 = @KUR_F2;  %Ŀ�꺯��2
        n = 3;      %����ά��
        L = -5;  %�±߽�
        U = 5;   %�ϱ߽�
    case 'ZDT1'
        F1 = @ZDT1_F1;  %Ŀ�꺯��1
        F2 = @ZDT1_F2;  %Ŀ�꺯��2
        n = 30;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
    case 'ZDT2'
        F1 = @ZDT2_F1;  %Ŀ�꺯��1
        F2 = @ZDT2_F2;  %Ŀ�꺯��2
        n = 30;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
        
        MaxGen = 1000;
        d = 3;
        eta_c = 30;
    case 'ZDT3'
        F1 = @ZDT3_F1;  %Ŀ�꺯��1
        F2 = @ZDT3_F2;  %Ŀ�꺯��2
        n = 30;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
    case 'ZDT4'
        F1 = @ZDT4_F1;  %Ŀ�꺯��1
        F2 = @ZDT4_F2;  %Ŀ�꺯��2
        n = 10;      %����ά��
        L = -5 * ones(1,n);  %�±߽�
        L(1) = 0;
        U = 5 * ones(1,n);   %�ϱ߽�
        U(1) = 1;
    case 'ZDT6'
        F1 = @ZDT6_F1;  %Ŀ�꺯��1
        F2 = @ZDT6_F2;  %Ŀ�꺯��2
        n = 10;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
    otherwise
        F1 = @f21;  %Ŀ�꺯��1
        F2 = @f22;  %Ŀ�꺯��2
        n = 3;      %����ά��
        L = -4;  %�±߽�
        U = 4;   %�ϱ߽�
end

% f = [];
% % Objective function one
% sum = 0;
% for i = 1 : V - 1
%     sum = sum - 10*exp(-0.2*sqrt((x(i))^2 + (x(i + 1))^2));
% end
% % Decision variables are used to form the objective function.
% f(1) = sum;
% 
% % Objective function two
% sum = 0;
% for i = 1 : V
%     sum = sum + (abs(x(i))^0.8 + 5*(sin(x(i)))^3);
% end
% % Decision variables are used to form the objective function.
% f(2) = sum;

f(1) = F1(x);
f(2) = F2(x);

%% Check for error
if length(f) ~= M
    error('The number of decision variables does not match you previous input. Kindly check your objective function');
end