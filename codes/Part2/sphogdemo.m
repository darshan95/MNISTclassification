%read data
[tr_labels,tr_feats,te_labels,te_feats] = read_data(ntrain,data_dir);

%compute SPHOG features
sphog_file = sprintf('cache/sphog_%i_%i.mat',ntrain,config.NORI);
if(exist(sphog_file,'file')),
    tic;
    load(sphog_file);
    fprintf('%.2fs to load precomputed features..\n',toc);
else
    [tr_sphog_feats,te_sphog_feats] = compute_sphog_features(tr_feats,te_feats);
    save(sphog_file,'tr_sphog_feats','te_sphog_feats');
end

fprintf('\n\n --- LINEAR SVM --- \n');
config.KERNEL_TYPE = 0;    % linear SVM
models = train_models(tr_labels,tr_sphog_feats);
[acc_sphog_linear, pl_sphog_linear] = predict_labels(models,te_labels,te_sphog_feats);


fprintf('\n\n --- INTERSECTION KERNEL SVM --- \n');
config.KERNEL_TYPE = 4;
models = train_models(tr_labels,tr_sphog_feats);
[acc_sphog_iksvm, pl_sphog_iksvm] = predict_labels(models,te_labels,te_sphog_feats);


fprintf('\t-------------------------\n');
fprintf('\t Method\t Acc(%%)\t Err(%%)\n');
fprintf('\t-------------------------\n');
fprintf('\t LINEAR\t%.2f%%\t %.2f%%\n',acc_sphog_linear,100-acc_sphog_linear);
fprintf('\t IKSVM\t%.2f%%\t %.2f%%\n',acc_sphog_iksvm,100-acc_sphog_iksvm);

figure;
bar([acc_sphog_linear; acc_sphog_iksvm]);
set(gca,'XTickLabel',{'Linear SVM','IKSVM'});
title(sprintf('MNIST dataset performance (ntrain %i, SPHOG)',ntrain));
ylabel('Accuracy(%)'); colormap summer; grid on;
