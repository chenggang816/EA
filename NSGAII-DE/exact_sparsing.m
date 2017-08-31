function [ pop ] = exact_sparsing( popExt,newSize )
%exact_sparsing ��ȷϡ�軯����������newSize��
%   �˴���ʾ��ϸ˵��
save('matlab.mat');
s = size(popExt);
extSize = s(1);
n = s(2) - 4;
if(extSize <= newSize)
    pop = popExt;
    warning('newSize is not smaller than popExt lenght.');
    return;
end

popExt = sortrows(popExt,n + 1);
d = sqrt(sum((popExt(2:extSize,n+1:n+2) - popExt(1:extSize - 1,n+1:n+2)).^2,2));
d_mean = mean(d);
d_std = sqrt(var(d));
abnormal = find(d >= d_mean + 12 * d_std, 1);
%������쳣ֵ����ʹ��3����׼�û���쳣ֵ����ʹ��9����׼��
if(~isempty(abnormal))
    d_sel = d(d < d_mean + 3 * d_std);
else
    d_sel = d(d < d_mean + 9 * d_std);
end
k = length(d) - length(d_sel);
last_popSize = newSize;
while(true)
    %k������ֵ����ľ������Ŀ��Ҳ�������߶Ͽ���ȱ�ڸ�����k + 1 �������߶�����ÿ�������ϵ�����
    %��������1���� k + 1 �����߶�� k + 1 ���㣬 newSize�����ӦnewSize - k - 1 �ξ���
    d_avg = sum(d_sel) /(newSize - k - 1);
    s = 0;
    j = 2;
    i = 1;
    pop = zeros(newSize * 2,n + 4);
    pop(1,:) = popExt(1,:); %�߽��
    while(i < extSize)
        s1 = s + d(i);
        if(d_avg <= s || (s <= d_avg && d_avg <= s1))
            dd = d_avg - s;
            dd1 = s1 - d_avg;
            if(dd < dd1)
                pop(j,:) = popExt(i,:);
            else
                i = i + 1;
                pop(j,:) = popExt(i,:);
            end
            s = 0;
            j = j + 1;
        end
        if(i >= extSize) %����ǰ��i�Լ���һ�Σ��������d(i)���ܻ�Խ��
            break;
        end
        s = s + d(i);
        i = i + 1;
    end
    
    pop(j,:) = popExt(extSize,:); %�߽��
    pop(sum(pop,2) == 0,:) = [];
    popSize = size(pop,1);
    if(popSize == newSize)
        break;
    else
        k = k + popSize - newSize;
        if(popSize > newSize && last_popSize < newSize)
            pop = crowding_distance_assignment(pop);
            pop(newSize + 1:end,:) = [];
            fprintf('��ȷϡ�軯ʹ��ӵ������ȥ����%d����\n',popSize - newSize);
            break;
        end
    end
    last_popSize = popSize;
end
save('matlab.mat');
end

