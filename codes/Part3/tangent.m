load('mnist_uint8.mat');
data = test_x(1:10000, 1:784);
train = train_x(1:10000, 1:784);
trainl = train_y(1:10000, 1:10);
testl = test_y(1:10000, 1:10);
trainlabel = zeros(10000,1);
testlabel = zeros(10000,1);
for i=1:10000,
    for j=1:10,
        if trainl(i,j) == 1
            trainlabel(i) = j-1;
            break;
        end
    end
end
for i=1:10000,
    for j=1:10,
        if testl(i,j) == 1
            testlabel(i) = j-1;
            break;
        end
    end
end
sample = double(data(1:3000,1:784));
D = tangent_d(sample', sample',1);
label = testlabel(1:3000, 1);
%l = find(label == 4);       %find the labels of the desired number

[Y, R, E] = Isomap(D,'k', 7);
figure;
hold on;
% uncomment the required command for plotting images of required label

% plot(Y.coords{2}(1,find(label==1)),Y.coords{2}(2,find(label==1)),'ro');
% plot(Y.coords{2}(1,find(label==2)),Y.coords{2}(2,find(label==2)),'bo');
% plot(Y.coords{2}(1,find(label==3)),Y.coords{2}(2,find(label==3)),'mo');
  plot(Y.coords{2}(1,find(label==4)),Y.coords{2}(2,find(label==4)),'go');
% plot(Y.coords{2}(1,find(label==5)),Y.coords{2}(2,find(label==5)),'co');
% plot(Y.coords{2}(1,find(label==6)),Y.coords{2}(2,find(label==6)),'yo');
  plot(Y.coords{2}(1,find(label==7)),Y.coords{2}(2,find(label==7)),'b+');
% plot(Y.coords{2}(1,find(label==8)),Y.coords{2}(2,find(label==8)),'y*');
% plot(Y.coords{2}(1,find(label==9)),Y.coords{2}(2,find(label==9)),'g+');
% plot(Y.coords{2}(1,find(label==0)),Y.coords{2}(2,find(label==0)),'c*');

%for displaying some images in the plot like in Tenenbaum paper

% title('Two-dimensional Isomap embedding (with neighborhood graph)');
% xLimits = get(gca,'XLim');
% yLimits = get(gca,'YLim');
% image = zeros(28,28);
% for i=randi(length(l),1,8),
%     image = reshape(sample(l(i),:),28,28);
%     axes('position',[((Y.coords{2}(1,l(i)))-xLimits(1))/(xLimits(2)-xLimits(1)), ((Y.coords{2}(2,l(i)))-yLimits(1))/(yLimits(2)-yLimits(1)), 0.05, 0.05]);
%     imshow(image');  
% end
hold off;

