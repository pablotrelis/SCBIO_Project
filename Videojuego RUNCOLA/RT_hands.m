camera = webcam;
load('red_test7_2.mat');
net = handsnet;
inputSize = net.Layers(1).InputSize(1:2);
fig=figure;
%fig.Position=[10 10 700 700];
fig.WindowState='maximized';
ax1=subplot(1,1,1);
while ishandle(fig)
    % Display and classify the image
    im = snapshot(camera);
    image(ax1,im)
    im= imresize(im,inputSize);
    im=flip(im ,2);
    [label,score] = classify(net,im);
    title(ax1,{char(label),num2str(max(score),2)});
    socket(label);
    % Select the top five predictions
    [~,idx] = sort(score,'descend');
    idx = idx(5:1:-1);
    scoreTop = score(idx);
    classNamesTop = string(class(idx));

    drawnow
end

function socket(x) 
tcpipClient = tcpip('127.0.0.1',55003,'NetworkRole','Client');
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