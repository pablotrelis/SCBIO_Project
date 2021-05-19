% nuevas imagenes de entrenamiento, ahora manos
clear 
hands_ds= imageDatastore('hands_test4','IncludeSubfolders',true,'LabelSource','foldernames');
%[trainImgs,testImgs] = splitEachLabel(hands_ds,0.6);
numClasses = numel(categories(hands_ds.Labels));
 

%Crear una red mediante la modificación de AlexNet

net = alexnet; %guardar la red en una variable
layers = net.Layers; %guardar las capas en una variable

inlayer=layers(1); %coger la primera capa
insz=inlayer.InputSize; %tamaño de la primera capa

layers(end-2) = fullyConnectedLayer(numClasses);  
layers(end) = classificationLayer;  %clasificacion de la ultima capa

outlayer=layers(end);  %guardar la ultima capa en variable 
categorynames= outlayer.Classes; % clasificacion de capa out red neuronal
[trainImgs,testImgs] = splitEachLabel(hands_ds,0.6); 
testlabels=testImgs.Labels; 
trainImgs = augmentedImageDatastore(insz,trainImgs,'ColorPreprocessing','gray2rgb'); %guardar en tamaño decapa de entrada
testImgs = augmentedImageDatastore(insz,testImgs,'ColorPreprocessing','gray2rgb');
%auds = augmentedImageDatastore(insz,hands_ds);

% handsPreds = classify(net,auds); %predicciones de la red con las imagenes
% [trainImgs,testImgs] = splitEachLabel(auds,0.6);  %clasificar en entrenar y test
%Establecer las opciones del algoritmo de entrenamiento



options = trainingOptions('sgdm','InitialLearnRate', 0.001);
 

%Realizar el entrenamiento


[handsnet,info] = trainNetwork(trainImgs, layers, options);
 

%Utilizar la red entrenada para clasificar imágenes de prueba
[testPreds,scores] = classify(handsnet,testImgs);
bar(scores);

confusionchart(testlabels,testPreds)
