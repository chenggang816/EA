function [ output ] = ZDT1_F2( x )
%ZDT1_F2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n = length(x);
g = 1 + 9 * sum(x(2:n)) / (n - 1);
output = g * (1 - sqrt(x(1) / g));
end

