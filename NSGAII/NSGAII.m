function [ output_args ] = NSGAII(func_flag)
%NSGAII �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%��������
MaxGen = 300;           %������
gen = 0;                %��ǰ����
N = 100;                %��Ⱥ��ģ

pool = 5;
eta_c = 15;
switch(func_flag)
    case 'SCH'
        F1 = @f11;  %Ŀ�꺯��1
        F2 = @f12;  %Ŀ�꺯��2
        n = 1;      %����ά��
        L = -1000;  %�±߽�
        U = 1000;   %�ϱ߽�
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
        
        MaxGen = 1000;
        eta_c = 30;
        pool = 5;
    case 'ZDT2'
        F1 = @ZDT2_F1;  %Ŀ�꺯��1
        F2 = @ZDT2_F2;  %Ŀ�꺯��2
        n = 30;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
        
        MaxGen = 1000;
        pool = 3;
        eta_c = 10;
    case 'ZDT3'
        F1 = @ZDT3_F1;  %Ŀ�꺯��1
        F2 = @ZDT3_F2;  %Ŀ�꺯��2
        n = 30;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
        
        MaxGen = 1000;
    case 'ZDT4'
        F1 = @ZDT4_F1;  %Ŀ�꺯��1
        F2 = @ZDT4_F2;  %Ŀ�꺯��2
        n = 10;      %����ά��
        L = -5 * ones(1,n);  %�±߽�
        L(1) = 0;
        U = 5 * ones(1,n);   %�ϱ߽�
        U(1) = 1;
        
        MaxGen = 2000;
        eta_c = 40;
    case 'ZDT6'
        F1 = @ZDT6_F1;  %Ŀ�꺯��1
        F2 = @ZDT6_F2;  %Ŀ�꺯��2
        n = 10;      %����ά��
        L = 0;  %�±߽�
        U = 1;   %�ϱ߽�
        eta_c = 5;
        MaxGen = 1000;
    otherwise
        F1 = @f21;  %Ŀ�꺯��1
        F2 = @f22;  %Ŀ�꺯��2
        n = 3;      %����ά��
        L = -4;  %�±߽�
        U = 4;   %�ϱ߽�
end


pop = zeros(N * 2,n + 4);   %��ǰ��Ⱥ,һ�б�ʾһ������,ǰn�б�ʾ����������n+1,n+2��ΪĿ��������������зֱ��ʾrank��crowding distance
popNew = zeros(N * 2,n + 4); 
one = ones(N * 2,1);
if(length(U) > 1)
    pop(:,1:n) = rand(N * 2,n) .* (one * (U - L)) + one * L;    %��ʼ����Ⱥ
else
    pop(:,1:n) = rand(N * 2,n) * (U - L) + L;    %��ʼ����Ⱥ
end
for gen = 1:MaxGen
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
    %����ͱ��죬������һ����Ⱥ
    eta_c_1 = 1 + floor(eta_c*((MaxGen - gen)/MaxGen)^6)
    pop = crossover_and_mutation(popNew,[L;U],pool,eta_c_1);
    
    %���ӻ�
    plot(-pop(1:N,n + 1),-pop(1:N,n + 2),'bo');
    title(gen);
    pause(0.01);
end
end

