% trains multiclass SVM models using 1-vs-all classifiers
function model = train_models(tr_labels,tr_feats)
global config;


classid = unique(sort(tr_labels));
ntrain  = size(tr_feats,1);
ndim    = size(tr_feats,2);

fprintf('\n Training MNIST Classifiers with %i examples (feat dim=%i).\n',ntrain,ndim);
for i = 1:length(classid),
    npos = sum(tr_labels==classid(i));
    nneg = ntrain - npos;
    wpos = nneg/npos;
    class_labels = (tr_labels==classid(i))+1;
    if(config.KERNEL_TYPE == 0), %linear SVMs trained using LIBLINEAr
        svmstr = sprintf('-s 3 -c %.1f -B %.1f -q', config.C, config.LIBLINEAR_B);
        svmstr_logist = sprintf('-s 0 -B 10 -c 1000'); %for the logistic regression
    else
        svmstr = sprintf('-t %i -d %i -r %.2f -g %.2f -c %.1f -w2 %.2f -b 1',...
                         config.KERNEL_TYPE, config.LIBSVM_d, config.LIBSVM_r,...
                         config.LIBSVM_g, config.C, wpos);
    end
    fprintf('\nTraining for Digit : %d, ',classid(i));
    fprintf('\t %d+/%d- (%s)\n',npos,nneg,svmstr);
    tic;
    if(config.KERNEL_TYPE==0),
        model{i}.svm = train(class_labels,tr_feats,svmstr);
        [l,a,d] = predict(class_labels,tr_feats,model{i}.svm);
        model{i}.logist = train(class_labels,d,svmstr_logist);
    else
        model{i}.svm = svmtrain(class_labels,tr_feats,svmstr);
        if(config.KERNEL_TYPE == 4),
            model{i}.Label = model{i}.svm.Label;
            model{i}.svm = precomp_model(model{i}.svm,'-m 1 -n 300');
        end
    end
    fprintf('\t %.2fs to train model\n',toc);
end
