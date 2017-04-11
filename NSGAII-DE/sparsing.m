function [ pop ] = sparsing( popExt,newSize )
%sparsing �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
save('matlab.mat','popExt');

s = size(popExt);
extSize = s(1);
n = s(2) - 4;
if(extSize <= newSize)
    pop = popExt;
    warning('newSize is not smaller than popExt lenght.');
    return;
end
pop = zeros(newSize,n + 4);
popExt = sortrows(popExt,n + 1);
d = sqrt(sum((popExt(2:extSize,n+1:n+2) - popExt(1:extSize - 1,n+1:n+2)).^2,2));
d_mean = mean(d);
d_std = sqrt(var(d));
d_sel = d(find(d < d_mean + 3 * d_std));

d_avg = sum(d_sel) /(newSize - 1);

s = 0;
j = 2;
i = 1;
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
        if(j > 100)
            break;
        end
    end
    s = s + d(i);
    i = i + 1;
end
if(j <= 100)
    pop(j,:) = popExt(extSize,:); %�߽��
else
    pop = [pop;popExt(extSize,:)]; %�߽��
end
pop(find(sum(pop,2) == 0),:) = [];

save('matlab.mat','pop');
end

