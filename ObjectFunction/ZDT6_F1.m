function [ output ] = ZDT6_F1( x )
%ZDT6_F1 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
output = 1 - exp(-4 * x(1)) * (sin(6 * pi * x(1))) ^ 6;
end

