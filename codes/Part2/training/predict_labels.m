function [acc,pl] = predict_labels(models, te_labels, te_feats)
global config;
classid = unique(te_labels);
probs = zeros(length(te_labels),length(classid));
for i = 1:length(classid),
    fprintf('Classifying for Digit :  %i \n', classid(i));
    class_label = (te_labels==classid(i)) + 1;
    if(config.KERNEL_TYPE == 0),
        [l,a,d] = predict(class_label,te_feats,models{i}.svm);
        [l2,a2,d2] = predict(class_label,d,models{i}.logist,'-b 1');
        probs(:,i) = d2(:,find(models{i}.logist.Label==2));
    elseif(config.KERNEL_TYPE == 4),
        d2 = fiksvm_predict(class_label,te_feats,models{i}.svm,'-b 1');        
        cidx = find(models{i}.Label==2);
        if(cidx > 1),
            probs(:,i) = 1-d2;
        else
            probs(:,i) = d2;
        end        
    else
        [l,a,d] = svmpredict(class_label,te_feats,models{i}.svm,'-b 1');
        probs(:,i) = d(:,find(models{i}.svm.Label==2));
    end
end
[junk,pl] = max(probs,[],2);
num_correct = sum(pl == te_labels+1);
acc = num_correct*100/length(te_labels);
fprintf('\n\nAccuracy on MNIST %.2f%% (%.2f%%) \n', acc, 100-acc);
fprintf('%.2fs to classify all examples\n',toc);
end