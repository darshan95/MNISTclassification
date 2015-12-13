[tr_labels,tr_feats,te_labels,te_feats] = read_data(ntrain,data_dir);

%{
% PCA
[coeff,score,latent] = pca(tr_feats,'NumComponents',150);
tr_feats = tr_feats * coeff;
te_feats = te_feats * coeff;
%}

%{
% LDA
options.PCARatio = 0.95;
[eg_vec, eg_val] = LDA(tr_labels, options, tr_feats);
tr_feats = tr_feats * eg_vec;
te_feats = te_feats * eg_vec;
%}

%{
% NPE
options.NeighborMode = 'KNN';
options.k = 5;
%options.gnd = tr_labels;
[eg_vec, eg_val] = NPE(options, tr_feats);
whos
tr_feats = tr_feats * eg_vec;
te_feats = te_feats * eg_vec;
%}

%{
fprintf('\n\n --- LINEAR SVM --- \n');
config.KERNEL_TYPE = 0;    % linear SVM
models = train_models(tr_labels,tr_feats);
[acc_linear, pl_linear] = predict_labels(models,te_labels,te_feats);
confusionmat(te_labels,pl_linear);
%}

fprintf('\n\n --- INTERSECTION KERNEL SVM --- \n');
config.KERNEL_TYPE = 4;
models = train_models(tr_labels,tr_feats);
[acc_iksvm, pl_iksvm] = predict_labels(models,te_labels,te_feats);
disp(confusionmat(te_labels,pl_iksvm))

%{
fprintf('\n\n --- POLYNOMIAL KERNEL SVM --- \n');
config.KERNEL_TYPE = 1;
models = train_models(tr_labels,tr_feats);
[acc_poly, pl_poly] = predict_labels(models,te_labels,te_feats);
confusionmat(te_labels,pl_linear);

fprintf('\n\n --- RBF KERNEL SVM --- \n');
config.KERNEL_TYPE = 2;
models = train_models(tr_labels,tr_feats);
[acc_rbf, pl_rbf] = predict_labels(models,te_labels,te_feats);
confusionmat(te_labels,pl_linear);
%}

fprintf('\t-------------------------\n');
fprintf('\t Method\t Acc(%%)\t Err(%%)\n');
fprintf('\t-------------------------\n');
fprintf('\t LINEAR\t%.2f%%\t %.2f%%\n',acc_linear,100-acc_linear);
fprintf('\t IKSVM\t%.2f%%\t %.2f%%\n',acc_iksvm,100-acc_iksvm);
fprintf('\t POLY\t%.2f%%\t %.2f%%\n',acc_poly,100-acc_poly);
fprintf('\t RBF\t%.2f%%\t %.2f%%\n',acc_rbf,100-acc_rbf);

figure;
bar([acc_linear; acc_iksvm; acc_poly; acc_rbf]);
set(gca,'XTickLabel',{'Linear SVM','IKSVM','POLY SVM','RBF SVM'});
title(sprintf('MNIST dataset performance (ntrain %i, raw)',ntrain));
ylabel('Accuracy(%)'); colormap summer; grid on;
