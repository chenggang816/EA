function [ output ] = f21( x )
%f21 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
output = 1 - exp(-sum((x-1/sqrt(3)).^2));
end

