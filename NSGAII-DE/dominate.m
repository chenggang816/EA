function [ output ] = dominate( p, q )
%UNTITLED �ж�p�Ƿ�֧��q
%   �ж�p�Ƿ�֧��q,p��qΪn + 4ά�����������ؽ��Ϊtrue����false
n = length(p);
if(n ~= length(q))
    error('dominate(p,q) get different dimension input arguments!');
end
n = n - 4;
output = true;
for i = 1:2
    if(p(n + i) < q(n + i))
        output = false;
        break;
    end
end
if(output == true)
    if(p(n:n+2) == q(n:n+2))
        output = false;
    end
end
end

