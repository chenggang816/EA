function [ output_args ] = NSGAII_DE(func_flag)
%NSGAII_DE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%��������
MaxGen = 100;           %������
ExtGen = 50;
N = 100;                %��Ⱥ��ģ

de_F = 0.5;                %DE��������
de_cr = 0.3;               %DE�������
switch(func_flag)
    case 'SCH'
        F1 = @f11;  %Ŀ�꺯��1
        F2 = @f12;  %Ŀ�꺯��2
        n = 1;      %����ά��
        L = -1000;  %�±߽�
        U = 1000;   %�ϱ߽�
        MaxGen = 50;
        ExtGen = 50;
    case 'FON'
        F1 = @f21;  %Ŀ�꺯��1
        F2 = @f22;  %Ŀ�꺯��2
        n = 3;      %����ά��
        L = -4;  %�±߽�
        U = 4;   %�ϱ߽�
    case 'POL'
        F1 = @f31;  %Ŀ�꺯��1
        F2 = @f32;  %Ŀ�꺯��2
        n = 2;      %����ά��
        L = -pi;  %�±߽�
        U = pi;   %�ϱ߽�
    case 'KUR'
        F1 = @KUR_F1;  %Ŀ�꺯��1
        F2 = @KUR_F2;  %Ŀ�꺯��2
        n = 3;      %����ά��
        L = -5;  %�±߽�
        U = 5;   %�ϱ߽�
    case 'ZDT1'
        F1 = @ZDT1_F1;  %Ŀ�꺯��1
        F2 = @ZDT1_F2;  %Ŀ�꺯��2
        n = 30;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
        
        MaxGen = 500;
    case 'ZDT2'
        F1 = @ZDT2_F1;  %Ŀ�꺯��1
        F2 = @ZDT2_F2;  %Ŀ�꺯��2
        n = 30;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
        
        MaxGen = 500;
        eta_c = 10;
    case 'ZDT3'
        F1 = @ZDT3_F1;  %Ŀ�꺯��1
        F2 = @ZDT3_F2;  %Ŀ�꺯��2
        n = 30;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
        
        MaxGen = 400;
    case 'ZDT4'
        F1 = @ZDT4_F1;  %Ŀ�꺯��1
        F2 = @ZDT4_F2;  %Ŀ�꺯��2
        n = 10;      %����ά��
        L = -5 * ones(1,n);  %�±߽�
        L(1) = 0;
        U = 5 * ones(1,n);   %�ϱ߽�
        U(1) = 1;
        
        MaxGen = 1000;
    case 'ZDT6'
        F1 = @ZDT6_F1;  %Ŀ�꺯��1
        F2 = @ZDT6_F2;  %Ŀ�꺯��2
        n = 10;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
        MaxGen = 500;
    otherwise
        F1 = @f21;  %Ŀ�꺯��1
        F2 = @f22;  %Ŀ�꺯��2
        n = 3;      %����ά��
        L = -4;  %�±߽�
        U = 4;   %�ϱ߽�
end


pop = zeros(N * 2,n + 4);   %��ǰ��Ⱥ,һ�б�ʾһ������,ǰn�б�ʾ����������n+1,n+2��ΪĿ��������������зֱ��ʾrank��crowding distance
popNew = zeros(N * 2,n + 4); 
popExtend = zeros(N * ExtGen,n + 4);

one = ones(N * 2,1);
if(length(U) > 1)
    pop(:,1:n) = rand(N * 2,n) .* (one * (U - L)) + one * L;    %��ʼ����Ⱥ
else
    pop(:,1:n) = rand(N * 2,n) * (U - L) + L;    %��ʼ����Ⱥ
end

for gen = 1:MaxGen + ExtGen
    for i = 1:2*N
        pop(i,n + 1) = -F1(pop(i,1:n));
        pop(i,n + 2) = -F2(pop(i,1:n));
    end

    %�������
    F = fast_nondominate_sort(pop);
    k = 1;
    j = 1;
    while(true)
        frontSet = F{j};
        len = length(frontSet);
        
        I = zeros(len,n + 4);
        for i = 1:len
            r = frontSet(i);
            pop(r,n + 3) = j;   %����rankֵ
            I(i,:) = pop(r,:);
        end
        I = crowding_distance_assignment(I);       %����ÿ��ÿ�������crowding distance
        if(k + len > N)
            break;
        end
        popNew(k:k + len - 1,:) = I;
        k = k + len;
        j = j + 1;
    end

    for i = 1:size(I,1)
        popNew(k,:) = I(i,:);
        k = k + 1;
        if(k > N)
            break;
        end
    end
    figure(1);
    plot(-popNew(1:N,n + 1),-popNew(1:N,n + 2),'bo');
    hold on;
%     plot(-I(i:end,n + 1),-I(i:end,n + 2),'rs');
    title(gen);
    hold off;
    pause(0.01);

    if(gen > MaxGen)
        from = (gen - MaxGen - 1) * N + 1;
        to = from + N - 1;
        popExtend(from:to,:) = popNew(1:N,:);
        figure(3);
        plot(-popExtend(:,n + 1),-popExtend(:,n + 2),'bo');
        title('������Ⱥ');
        if(gen >= MaxGen + ExtGen)
            popExtend(:,end) = 0; %���һ��Ϊcrowding_distance������û������
            popExtend = unique(popExtend,'rows');
            popExtend(find(popExtend(:,n + 3) > 1),:) = []; %ȥ������������Ľ�
            F_ext = fast_nondominate_sort(popExtend);
            firstFront = F_ext{1};
            popNondominateExt = zeros(size(popExtend));
            for i=1:length(firstFront)
                popNondominateExt(i,:) = popExtend(firstFront(i),:);
            end
            popNondominateExt(find(sum(popNondominateExt,2) == 0),:) = [];
            popSparsing = sparsing(popNondominateExt,N);
            figure(4);
            plot(-popSparsing(:,n + 1),-popSparsing(:,n + 2),'bo');
            title('���ս��');
        end
    end
    
    
    %����ͱ��죬������һ����Ⱥ
    pop = crossover_and_mutation(popNew,[L;U],F1,F2,de_F,de_cr);    
end

figure(2);
plot(-pop(1:N,n + 1),-pop(1:N,n + 2),'bo');
title('ԭʼ���');
end

