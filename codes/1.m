% libsvm library path
addpath('/home/darshan/Stage1/libsvm/libsvm-3.20/matlab/');
% liblinear library path
%addpath('/home/darshan/Stage2/liblinear/liblinear-2.1/matlab/');

numTrain = 6000;
numTest =  1000;

% data loading
%load data_usps.mat;
%[coeff,score,latent] = pca(train_im,'NumComponents',150);
%train_im = train_im * coeff;
%test_im = test_im * coeff;
load data_mnist.mat;
%load data_mnist_pca.mat;
%load data_test;

% chi-square kernel matrix calculation
%{
chi2Kernel = @(x,y) 1-(sum((x - y).^2 ./ (x + y + 0.00000001) / 2));
%chi2Kernel = @(x,y) 1-(sum((x - y).^2 ./ (x + y + 2) / 2));
%chi2Kernel = @(x,y) 2.*(x.*y)/(x+y+0.00000001);
%chi2Kernel = @(x,y) 2.*(x.*y)/(x+y+1);

k = zeros(numTrain);
k = zeros([numTest, numTrain]);
parfor i=1:numTrain
	disp(i);
	for j=1:numTrain
		k(i,j) = chi2Kernel(train_im(i,:),train_im(j,:));
	end
end

parfor i=1:numTest
	disp(i);
	for j=1:numTrain
		kk(i,j) = chi2Kernel(test_im(i,:),train_im(j,:));
	end
end

k = [ (1:numTrain)' , k ];
kk = [ (1:numTest)' , kk ];
%}

disp('started training');
tic;
% liblinear
%model = train(train_lab(1:numTrain), sparse(train_im(1:numTrain,:)), ['-s 2 -c 10 -B 1 -q']);
% libsvm linear kernel
%model = svmtrain(train_lab(1:numTrain), train_im(1:numTrain,:), ['-s 0 -t 0 -r 1 -c 10 -q']);
% libsvm polynomial kernel
model = svmtrain(train_lab(1:numTrain), train_im(1:numTrain,:), ['-s 0 -t 1 -d 9 -r 1 -c 10']);
% libsvm rbf kernel
%model = svmtrain(train_lab(1:numTrain), train_im(1:numTrain,:), ['-s 0 -t 2 -c 10']);
% libsvm chi square kernel
%model = svmtrain(train_lab(1:numTrain), k, ['-s 0 -t 4 -c 10']);
disp('Started testing');
toc;
tic;
% liblinear
%[predict_label, accuracy, dec_values] = predict(test_lab(1:numTest), sparse(test_im(1:numTest,:)), model);
% libsvm all except chi square
[predict_label, accuracy, dec_values] = svmpredict(test_lab(1:numTest), test_im(1:numTest,:), model);
% libsvm chi square
%[predict_label, accuracy, dec_values] = svmpredict(test_lab(1:numTest), kk, model);
toc;
disp(accuracy);
C = confusionmat(test_lab(1:numTest),predict_label);
disp(C);
%save('mnist-6kchi2SVMOutput.mat','model','predict_label','accuracy','dec_values','C','-v7.3');
