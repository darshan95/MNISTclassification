%Darshan Agarwal: 201225189
addpath('/home/darshan/Stage2/liblinear/liblinear-2.1/matlab/');

global model;
% training data size
total = 4649;
numTrain = int(0.1*total);

% loading data
load data_usps.mat;
[coeff,score,latent] = pca(train_im,'NumComponents',150);
train_im = train_im * coeff;
test_im = test_im * coeff;

trainSet = train_im(1:numTrain,:);
trainLab = train_lab(1:numTrain);
testSet = train_im(numTrain+1:end,:);
testLab = train_lab(numTrain+1:end);

tic;
for i=1:15
	disp('started training');
	model = train(trainLab, sparse(trainSet), ['-s 2 -c 10 -B 1 -q']);
	disp('Started testing');
	[predict_label, accuracy, dec_values] = predict(testLab, sparse(testSet), model);
	disp(accuracy);
	C = confusionmat(testLab,predict_label);
	[pred_label, acc, dec_val] = predict(test_lab, sparse(test_im), model);
	disp(acc);
	trainSet = [trainSet; testSet(find(testLab~=predict_label),:)];
	trainLab = [trainLab; testLab(find(testLab~=predict_label),:)];
	testSet = testSet(find(testLab==predict_label),:);
	testLab = testLab(find(testLab==predict_label),:);
	toc;
end
