%Darshan Agarwal: 201225189
load ('USPS_10');
train_img = (train_patterns+1)/2;
test_img = (test_patterns+1)/2;
train_img = train_img';
test_img = test_img';
%% KNN begins
disp('Fitting KNN');
mdl = ClassificationKNN.fit(train_img,train_labels_10,'NumNeighbors',1);
disp('Predicting');
pre = predict(mdl,test_img);
confusion_knn=confusionmatStats(test_labels_10, pre);
save('KNN_confusion','confusion_knn');
