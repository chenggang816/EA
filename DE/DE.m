function [ output_args ] = DE( )
%DE ��ֽ����㷨
%   �˴���ʾ��ϸ˵��
fun = @fun1;
F = 0.5;
CR = 0.3;

draw = false;

M = 100;    %��Ⱥ��ģ
It = 1000;  %��������
n = 4;      %��������ά��
POP = zeros(M,n);    %��Ⱥ
POP_H = zeros(M,n);    %������Ⱥ
POP_V = zeros(M,n);     %������Ⱥ
POP_New = zeros(M,n);   %�����ɵ���Ⱥ
Fit_Pop = zeros(M,1);   %M���������Ӧ��
Fit_Best = zeros(It,1);     %ÿһ�������Ÿ�����Ӧֵ
for i=1:M
    X = rand(1,n) * 20 - 10;
    POP(i,:) = X;
end
for k = 1:It        %����It��
    Fit_Best(k) = -fun(POP(1));      %ȡ��ǰ��Ⱥ�ĵ�1���������Ӧֵ    
    for i=1:M       %��ÿһ����M��������б��졢���桢ѡ�����
        %����
        p = randi(M,1,3);
        POP_H(i,:) = POP(p(1),:) + F * (POP(p(2),:) - POP(p(3),:));
        while(~isValid(POP_H(i,:)))
            p = randi(M,1,3);
            POP_H(i,:) = POP(p(1),:) + F * (POP(p(2),:) - POP(p(3),:));
        end
             
        %����
        rnbr = randi(n);
        for j = 1:n
            if(rand() < CR || j == rnbr)
                POP_V(i,j) = POP_H(i,j);
            else
                POP_V(i,j) = POP(i,j);
            end
        end
        %������Ӧֵ
        Fit_V = -fun(POP_V(i,:));
        Fit = -fun(POP(i,:));
        Fit_Pop(i) = Fit;
        if(Fit_Best(k) < Fit)
            Fit_Best(k) = Fit;
        end
        %ѡ��
        if(Fit_V > Fit)
            POP_New(i,:) = POP_V(i,:);
        else
            POP_New(i,:) = POP(i,:);
        end        
    end
    if(n == 2 && draw == true)      %����Ƕ�ά�������ɢ��ͼ���ӻ�
        figure(1);
        scatter(POP(:,1),POP(:,2),15,'filled');
        s_ti = sprintf('��%d�� �����Ӧֵ:%f',k,Fit_Best(k));
        title(s_ti);
        disp(s_ti);
        pause(0.01);
    end    
    %������Ⱥ
    POP = POP_New;
end
figure(2);
plot(Fit_Best);
title('��Ӧֵ����ͼ');
end

function output = isValid(X)
    n = length(X);
    output = true;
    for i = 1:n
        if(X(i) < -10 || X(i) > 10)
            output = false;
            break;
        end
    end
end

