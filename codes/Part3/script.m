[data,labels]=loadDigits(1000,'train');
options.dims = 1:10;
edistance=L2_distance(data,data);
[Y,R,E]=isomap(edistance,'k',7,options,labels,1000,data);