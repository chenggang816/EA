function [ output ] = KUR_F1( x )
%KUR_F1 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n = length(x);
s = 0;
for i = 1:n-1
    s = s - 10 * exp(-0.2 * sqrt(x(i)^2 + x(i + 1)^2));
end
output = s;
end

