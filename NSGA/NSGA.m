function [ output_args ] = NSGA()
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
f1 = @f11;
f2 = @f12;

Maxgen = 1000;   %����������
N = 100;    %��Ⱥ��ģ
rpnum = 10; %�滻����
pc = 1; %�ӽ�����
pm = 0; %�������

SigmaShare = 1;

DecRate = 0.99;         %������Ӧֵ�½�����

Pop = zeros(N,3);   %��һά���Ա������ڶ�ά��rank������ά��������Ӧֵ
FitVector = zeros(N,2);

%��ʼ����Ⱥ
for i=1:N
    Pop(i) = rand() * 20 - 10;
    FitVector(i,1) = -f1(Pop(i));
    FitVector(i,2) = -f2(Pop(i));
end

for gen = 1:Maxgen
    front = 1;
    classifiedNum = 0;    
    VirFit = 1000;     %������Ӧֵ
    Pop(:,2) = 0;       %����ȼ���0
    
    %����֧��������з��࣬���㹲��������������Ӧֵ    
    while(classifiedNum < N)
        frontSetNum = 0;    %��ǰǰ�����еĸ�����

        for i = 1:N         %�Եڸ�����i��һ��ǰ����
            if(Pop(i,2) > 0) %�������i�Ѿ����࣬������
                continue;
            end
            Pop(i,2) = front;   %���ȼ����i�����崦��Paretoǰ����
            frontSetNum = frontSetNum + 1;
            for j = 1:N
                FitVector(i,1) = -f1(Pop(i));
                FitVector(i,2) = -f2(Pop(i));
                junclassified = Pop(j,2) == 0;   %ֻ��δ����ĸ�����бȽ�
                if(junclassified && FitVector(i,1) < FitVector(j,1) && FitVector(i,2) < FitVector(j,2))
                    %�������jδ������j֧��i����i�����ڵ�ǰ������,��i��rank��Ϊ0
                    Pop(i,2) = 0;
                    frontSetNum = frontSetNum - 1;
                    break;
                end
            end
        end
        
        %���㹲����
        frontSet = zeros(frontSetNum,1);
        for i=1:frontSetNum
            if(Pop(i,2) == front)
                frontSet(i) = Pop(i,1);
            end
        end
        len = length(frontSet);
        sh = zeros(len,len);
        sum = 0;
        for i = 1:len
            for j = i + 1:len
                d = abs(Pop(i,1) - Pop(j,1));
                if(d < SigmaShare)
                    sh(i,j) = 1 - power((d/SigmaShare),2);
                end
                sum = sum + sh(i,j);
            end
        end
        NicheCount = sum / len + 1;
        
        %����������Ӧֵ
        VirFit = VirFit * DecRate / NicheCount;
        for i = 1:N
            if(Pop(i,2) == front)
                Pop(i,3) = VirFit;
            end
        end
        
        classifiedNum = classifiedNum + frontSetNum;
        front = front + 1;
    end     
    %��Ⱥ����Ӧֵ����,����Ӧֵ���ĸ���ŵ�ǰ��
    for i = 1:rpnum
        for j = i:N
            if(Pop(i,3) > Pop(j,3))
                tmp = Pop(i,:);
                Pop(i,:) = Pop(j,:);
                Pop(j,:) = tmp;
            end
        end
    end
    %����������õ���һ������Ⱥ 
    for i = 1:rpnum
        while(true)
            p1 = randi([rpnum,N]);
            p2 = randi([rpnum,N]);
            while(p1 == p2)
                p2 = randi([rpnum,N]);
            end
            a = rand() * 2 - 0.5;        
            Pop(i,1) = Pop(p1,1) * a + Pop(p2,1) * (1 - a);
            if(-10 < Pop(i,1) && Pop(i,1) < 10)
                break;
            end    
        end
    end
    
    if(mod(gen,100) == 0)
        figure(1);        
        plot(Pop(rpnum + 1:N,1),ones(N - rpnum),'bo');
        s_ti = sprintf('��%d��',gen);
%         axis([-2,4,0,5]);
        title(s_ti);
        
        figure(2);
        ObjVector = -FitVector;
        plot(ObjVector(:,1),ObjVector(:,2),'bs');
        pause(0.01);
    end
end
Pop

