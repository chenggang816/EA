function [ output ] = fun1( X )
%FUN1 ��������X��Ŀ�꺯��ֵ
%  X Ϊ1 x n ά����
n = length(X);
result = 1;
for i=1:n
    sum = 0;
    for j=1:5
        c = j * cos((j+1)*X(i) + j);
        sum = sum + c;        
    end
    result = result * sum;
end
output = result;
end

