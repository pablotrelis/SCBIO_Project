camera = webcam;
net = handsnet;
inputSize = net.Layers(1).InputSize(1:2);
fig=figure;
fig.Position=[10 10 700 700];
ax1=subplot(1,1,1);
% % ax2=subplot(1,2,2);
% ax2.PositionConstraint='InnerPosition';
while ishandle(fig)
    % Display and classify the image
    im = snapshot(camera);
    image(ax1,im)
    im = imresize(im,inputSize);
    [label,score] = classify(net,im);
    title(ax1,{char(label),num2str(max(score),2)});
%     socket(label);
    % Select the top five predictions
    [~,idx] = sort(score,'descend');
    idx = idx(5:1:-1);
    scoreTop = score(idx);
    classNamesTop = string(class(idx));

%     % Plot the histogram
%     barh(ax2,scoreTop)
%     title(ax2,'Top 5')
%     xlabel(ax2,'Probability')
%     xlim(ax2,[0 1])
%     yticklabels(ax2,classNamesTop)
%     ax2.YAxisLocation = 'right';

    drawnow
end

function socket(x) 
tcpipClient = tcpip('127.0.0.1',55001,'NetworkRole','Client');
set(tcpipClient,'Timeout',30);
fopen(tcpipClient);
if x == "00"
   a="00"; 
elseif x == "11"
   a="11";
elseif x == "01"
   a="01";
elseif x == "10"
   a="10";
end
fwrite(tcpipClient,a);
fclose(tcpipClient);

end