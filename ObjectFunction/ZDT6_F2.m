function [ output ] = ZDT6_F2( x )
%ZDT6_F2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n = length(x);
g = 1 + 9 * (sum(x(2:n)) / (n - 1)) ^ 0.25;
output = g * (1 - (x(1) / g) ^ 2);
end

