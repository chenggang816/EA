function  F = fast_nondominate_sort( P )
%fast_nondominate_sort �Ե�ǰ��Ⱥ���з�֧������
%   �Ե�ǰ��Ⱥ���з�֧������
s = size(P);
N = s(1);
n = s(2) - 4;

S = cell(N,1);     %S(i)��ʾ����i֧�����ļ���,��¼��������Ⱥ�е��±�ֵ
F = cell(N,1);
dc = zeros(N,1);    %dc(i)��ʾ֧�����i�ĸ��������
F(1) = {[]};
for i = 1:N
    dc(i) = 0;
    for j = 1:N
        if(dominate(P(i,:),P(j,:)))
            S(i) = {[S{i};j]};
        elseif(dominate(P(j,:),P(i,:)))
            dc(i) = dc(i) + 1;
        end
    end
    if(dc(i) == 0)
        P(i,n + 3) = 1;        
        F(1) = {[F{1};i]};
    end
end
i = 1;
while(~isempty(F{i}))
    Q = [];
    Fi = F{i};
    for j = 1:size(Fi,1)
        Sj = S{Fi(j)};
        for k = 1:size(Sj,1)
            p = Sj(k);
            dc(p) = dc(p) - 1;
            if(dc(p) == 0)
                P(p,n + 3) = i + 1;
                Q = [Q;p];
            end
        end
    end
    i = i + 1;
    F(i) = {Q};
end
end

