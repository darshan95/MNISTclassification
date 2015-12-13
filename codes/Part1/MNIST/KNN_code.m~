%Darshan Agarwal: 201225189
if exist('train_img','var')
    disp('Data exist');
else
train_img = [];
test_img = [];
disp('Loading Training data');
[temp_train_img, train_labels] = readMNIST('train-images.idx3-ubyte','train-labels.idx1-ubyte', 6000,0);
disp('Loading Testing data');
[temp_test_img, test_labels] = readMNIST('t10k-images.idx3-ubyte','t10k-labels.idx1-ubyte', 100,0);
disp('Converting');
for i=1:size(temp_train_img,3)
    p = temp_train_img(:,:,i);
    p = p(:);
    train_img = [train_img ;p'];
end
for i=1:size(temp_test_img,3)
    p = temp_test_img(:,:,i);
    p = p(:);
    test_img = [test_img ;p'];
end
end

%% KNN begins
disp('Fitting KNN');
mdl = ClassificationKNN.fit(train_img,train_labels,'NumNeighbors',1);
disp('Predicting');
pre = predict(mdl,test_img);
confusion_knn=confusionmatStats(test_labels, pre);
save('KNN_confusion','confusion_knn');
