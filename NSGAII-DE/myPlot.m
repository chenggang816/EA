function [ output_args ] = myPlot(figureNum, x,y,fileName )
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
hFigure = figure(figureNum);
set(gcf,'position',[100 100 350 240]);
plot(x,y,'ko','markersize',3);

set(gca,'FontName','Times New Roman');
xlabel('\itf_{1}','FontName','Times New Roman');
ylabel('\itf_{2}','FontName','Times New Roman');
posHfig=[0 0 240 150]; % posHfigΪ �������ͼƬ�ĳߴ�
set(hFigure, 'PaperPositionMode', 'manual'); % hFigure ͼ����
set(hFigure, 'PaperUnits', 'points'); 
set(hFigure, 'PaperPosition', posHfig); %
print(hFigure, '-dmeta', fileName);

end

