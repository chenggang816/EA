function [ output ] = KUR_F2( x )
%KUR_F2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
output = sum(abs(x).^0.8 + 5 * sin(x.^3));
end

