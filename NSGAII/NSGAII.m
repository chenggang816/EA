function [ output_args ] = NSGAII(func_flag)
%NSGAII 此处显示有关此函数的摘要
%   此处显示详细说明
switch(func_flag)
    case 'SCH'
        F1 = @f11;  %目标函数1
        F2 = @f12;  %目标函数2
        n = 1;      %变量维数
        L = -1000;  %下边界
        U = 1000;   %上边界
    otherwise
        F1 = @f11;
        F2 = @f22;
end

%参数设置
MaxGen = 500;           %最大代数
gen = 0;                %当前代数
N = 100;                %种群规模
pop = zeros(N * 2,n + 4);   %当前种群,一行表示一个个体,前n列表示个体向量，n+1,n+2列为目标向量，最后两列分别表示rank和crowding distance
popNew = zeros(N * 2,n + 4); 
pop(:,1:n) = rand(N * 2,n) * (U - L) + L;    %初始化种群
for gen = 1:MaxGen
    for i = 1:2*N
        pop(i,n + 1) = -F1(pop(i,1:n));
        pop(i,n + 2) = -F2(pop(i,1:n));
    end

    %排序分类
    F = fast_nondominate_sort(pop);
    k = 1;
    j = 1;
    while(true)
        frontSet = F{j};
        len = length(frontSet);
        if(k + len > N)
            I = zeros(len,n + 4);
            for i = 1:len
                r = frontSet(i);
                I(i,:) = pop(r,:);
            end
            break;
        end
        for i = 1:len
            r = frontSet(i);
            popNew(k,:) = pop(r,:);
            k = k + 1;
        end
        j = j + 1;
    end
    %计算每类每个个体的crowding distance
    I = crowding_distance_assignment(I);    
    for i = 1:size(I,1)
        popNew(k,:) = I(i,:);
        k = k + 1;
        if(k > N)
            break;
        end
    end
    %交叉和变异，产生下一代种群
    pop = crossover_and_mutation(popNew);
    
    %可视化
    plot(-pop(1:N,n + 1),-pop(1:N,n + 2),'bo');
    title(gen);
    pause(0.01);
end
end

