% this will create a variable called "sensor"
%SUF='e';
% group1 = [101:105];

group1 = [112:115,117:119,122,126,129];%keymap red
%group2 = [101:105, 116,120,121,123,130]; %no keymap blue
%group2 = [131:135, 116,120,121,123,130]; %no keymap blue
group2 = [131,132,103,134,135, 116,120,121,123,130]; %no keymap blue
group3 = [106:111,124,125,127,128];%ambiguous keymap green



% group1 = [112:115,117:119,122,126,129];%keymap red
% group2 = [101:105, 116,120,121,123,130]; %no keymap blue
% group3 = [106:111,124,125,127,128];%ambiguous keymap green

groupArray = [group1,group2,group3];
groupArray

activeMat=[];
%count = zeros(3000,1,30);
%timeArray =[];
%function averageGroups(groupArray)
%%
clf
index=0;
%ARR = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s'];
sumVector=[];
%for subgroup = 1:3
    
for SUF = groupArray%[subgroup] %SUF
    SUF = num2str(SUF);
    index=index+1;


run(['sensorLog18Rev_' SUF '.m'])

filename = ['audio_' SUF '.bin'];
numChannels = 2;
Fs = 44100;

sensorMax = 255;
numSensors = 18;
timestampColumn = 19;


limit = 0.0;

 fid=fopen([filename],'r');

 %offset = 4739824; %samples
 %str='alignTime_' SUF ;
 
 offset = alignTime;
 %offset = x;
 offsetOfBytes = offset*4*numChannels;
   
 
  %audio = fread(fid, 'float');
  % audio = fread(fid, 'float');
   
%   audio = fseek(fid,offsetOfBytes,'bof');
%   audio = fread(fid, 'float');
%   %position = ftell(fid)
%  fclose(fid);
%  %audio = vec2mat(audio, numChannels);
%  audioMat = vec2mat(audio, numChannels);
%sound(audioMat,Fs);


 %25 columns. 1-24 are sensors and 25 is timestamp ( in samples)

s = sensor(:,1:numSensors) / sensorMax; % this is to have it from 0 to 1

T = sensor(1:14500,timestampColumn) / Fs;

activated = gt(sensor(1:14500,1:numSensors),0) ; % matrix of 0 and 1 for each column (sensor)
%transposing the matrix would create rows for sensors and columns for data
%points.
% this would eventually lead to create a column vector having as rows the
% sensors


    
   sumVector(index,:) = sum(activated,1); 
   
   %activeMat(:,:,index)=activated(:,:);

   %sumVector(index,:,subgroup) = sum(activated,1); 
  % t = activated(j);
    %sumVector(1,j) = sum(t);
    
%    for x=1:3000     
%     countVector(x,index)=sum(activated,2);
%    end
%   


size(sumVector)




 
%sumSuf= sum(activated,2);
     
     
 
%count=sum(activated,2);
%size(count)



end
%end
%%



 clf
 audioTime = (0:size(audioMat,1)-1) / Fs;

 h = plot(audioTime(1:10:end), audioMat(1:10:end,2), T, countVector(x,2),  '.-');




%sumVector
%%
count = 0;

for c = 1 : numSensors
         
    
 for x = 1:length(T)
   
   
     activated (x,c)= gt(activated(x,c),0);
     
     
     end
     
    
     
 end

 
% count=sum(activated,2);
% size(count)
%this plots the number of counts for each participants across time
%in order to compare them across time the Matrix of time needs to be
%consistent. It makes sense to trim it after 5 minutes which in sensor time
%should be 60*5*samplingRate of sensors, which is 10 Hz - 3000 samples


%%

audioTime = (0:size(audioMat,1)-1) / Fs;


%  M = mean(sumVector/length(T));
%   M1 = mean(sumVector[1:5]/length(T));
%    M2 = mean(sumVector[6:10]/length(T)); 
%    M3 = mean(sumVector[11:15]/length(T));

 %size(S)
 %length(S)
 

 %figure
 %%
 clf
 audioTime = (0:size(audioMat,1)-1) / Fs;
 count=sum(activated,2);
size(count)
 h = plot(audioTime(1:10:end), audioMat(1:10:end,2), T, count,  '.-');
 
 
 %% 
 
 clf
 audioTime = (0:size(audioMat,1)-1) / Fs;
%boxplot(sumVector/length(T),'Color','r','BoxStyle','outline');
  boxplot(sumVector(1:10,:)/length(T),'Color','r','BoxStyle','outline');
 hold on 
  boxplot(sumVector(11:20,:)/length(T),'Color','b','BoxStyle','outline');
 boxplot(sumVector(21:30,:)/length(T),'Color',[0.3,0.8,0.3],'BoxStyle','outline')
 boxplot(sumVector/length(T),'Color','k', 'BoxStyle','filled');
h1= plot(1:18,std(sumVector(1:10,:)));
  grid on
 
 ax2 = gca;
 ax2.YLim = [0,0.3];
 ax2.YTick = 0:0.1:0.3;
 ax2.YLabel.String= 'Time Spent / Overall Time';
 %ax2.YTickLabels = {'0','30','60','90','120','150','180','210'};
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
 ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
%ax2.XTickLabels.FontSize = 10;
%ax2.XLabel= 'Locations';
  hold off
%end

%%

%  boxplot(sumVector(1:5,:)/length(T),'Color','r','BoxStyle','outline');
%  hold on 
%  boxplot(sumVector(6:11,:)/length(T),'Color','b','BoxStyle','outline');
% boxplot(sumVector(12:15,:)/length(T),'Color',[0.3,0.8,0.3],'BoxStyle','outline')
% boxplot(sumVector/length(T),'Color','k', 'BoxStyle','filled');
%   grid on
 
%  ax2 = gca;
%  ax2.YLim = [0,0.4];
%  ax2.YTick = 0:0.05:0.4;
%  ax2.YLabel.String= 'Time percentage';
%  %ax2.YTickLabels = {'0','30','60','90','120','150','180','210'};
%  ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
%  ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
% %ax2.XTickLabels.FontSize = 10;
% %ax2.XLabel= 'Locations';
%   hold off
clf
% figure
% h = plot(1:numSensors, mean(sumVector)/length(T),1:numSensors, std(sumVector)/length(T));


 
 subplot(3,1,1)
 boxplot(sumVector(1:10,:)/length(T),'Color','r','BoxStyle','outline');
 hold on 
 boxplot(sumVector/length(T),'Color','k', 'BoxStyle','filled');
%  h1= plot(1:18,std(sumVector(1:10,:)));
 title('keymap');
 grid on
  %hold off
 ax2 = gca;
 ax2.YLim = [0,0.4];
 ax2.YTick = 0:0.05:0.4;
 ax2.YLabel.String= 'Time Spent / Overall Time';
 %ax2.YTickLabels = {'0','30','60','90','120','150','180','210'};
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
 ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
%ax2.XTickLabels.FontSize = 10;
%ax2.XLabel= 'Locations';
  hold off
  
  subplot(3,1,2)
 boxplot(sumVector(11:20,:)/length(T),'Color','b','BoxStyle','outline');
hold on
 boxplot(sumVector/length(T),'Color','k', 'BoxStyle','filled');
%  h1= plot(1:18,std(sumVector(11:20,:)));
 title('no keymap');
 
   grid on
  %hold off
 ax2 = gca;
 ax2.YLim = [0,0.4];
 ax2.YTick = 0:0.05:0.4;
 ax2.YLabel.String= 'Time Spent / Overall Time';
 %ax2.YTickLabels = {'0','30','60','90','120','150','180','210'};
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
 ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
%ax2.XTickLabels.FontSize = 10;
%ax2.XLabel= 'Locations';
  hold off
  
 subplot(3,1,3)
 boxplot(sumVector(21:30,:)/length(T),'Color',[0.0,0.8,0.2],'BoxStyle','outline');
hold on
 boxplot(sumVector/length(T),'Color','k', 'BoxStyle','filled');
%  h1= plot(1:18,std(sumVector(21:30,:)));
 title('ambiguous keymap');
   grid on
  %hold off
 ax2 = gca;
 ax2.YLim = [0,0.4];
 ax2.YTick = 0:0.05:0.4;
 ax2.YLabel.String= 'Time Spent / Overall Time';
 %ax2.YTickLabels = {'0','30','60','90','120','150','180','210'};
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
 ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
%ax2.XTickLabels.FontSize = 10;
%ax2.XLabel= 'Locations';

%%
clf



sumVectorMap=sumVector(1:10,:);
sumVectorNoMap=sumVector(11:20,:);
sumVectorAMap=sumVector(21:30,:);

sumVectorKey=vertcat(sumVectorMap,sumVectorAMap);

size(sumVectorKey)
%%
clf

%statistics. n observations = 30 (sample)
%values for each sample = 18
%values for each locations; table with mean, median, std for each location,
%groups, and total
%average time spent on each location mean of the mean
timeConversion = 1/14500*290; 


 meanT=mean(sumVector*timeConversion);
 meanTMap=mean(sumVectorMap*timeConversion);
 meanTNoMap=mean(sumVectorNoMap*timeConversion);
 meanTAMap=mean(sumVectorAMap*timeConversion);
 
 stdG=std(meanT)
 stdKM=std(meanTMap)
 stdNM=std(meanTNoMap)
 stdAKM=std(meanTAMap)

medianGroup=median(sumVector*timeConversion);
medianKM=median(sumVectorMap*timeConversion);
medianNKM=median(sumVectorNoMap*timeConversion);
medianAKM=median(sumVectorAMap*timeConversion);

stdMedG=std(medianGroup)
 stdMedKM=std(medianKM)
 stdMedNM=std(medianNKM)
 stdMedAKM=std(medianAKM)


stanDev=std(sumVector*timeConversion);
stanDevMap=std(sumVectorMap*timeConversion);
stanDevNoMap=std(sumVectorNoMap*timeConversion);
stanDevAMap=std(sumVectorAMap*timeConversion);


names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
% names
[SmedianG,J]=sort(medianGroup,'descend');


Amean = [meanT(J);meanTMap(J);meanTNoMap(J);meanTAMap(J)];
Amean
Amed = [medianGroup(J); medianKM(J);medianNKM(J);medianAKM(J)];
Amed
%Variance
Astd = [stanDev(J);stanDevMap(J);stanDevNoMap(J);stanDevAMap(J)];
Astd

subplot(4,1,1)

for i=1:numSensors
    z(i,1) = Amean(1,i);
    z(i,2) = Amed(1,i);
    z(i,3) = Astd(1,i);
end
    bar(z)   
    title('Entire Group n = 30');
  ax2 = gca;
   ax2.YLim = [0,70];
 ax2.YTick = 0:5:70;
 ax2.YLabel.String= 'Time Spent, seconds';
 ax2.XLim = [0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 %names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
ax2.XTickLabels = names(J);
legend('mean','median','std');
grid on

subplot(4,1,2)

for i=1:numSensors
    zK(i,1) = Amean(2,i);
    zK(i,2) = Amed(2,i);
    zK(i,3) = Astd(2,i);
end
    bar(zK)   
    title('Key Map (KM) n=10');
  ax2 = gca;
   ax2.YLim = [0,70];
 ax2.YTick = 0:5:70;
 ax2.YLabel.String= 'Time Spent, seconds';
 ax2.XLim = [0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 %names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
ax2.XTickLabels = names(J);
legend('mean','median','std');
grid on

subplot(4,1,3)

for i=1:numSensors
    zN(i,1) = Amean(3,i);
    zN(i,2) = Amed(3,i);
    zN(i,3) = Astd(3,i);
end
    bar(zN)   
    title('No Key Map (NKM) n=10');
    
  ax2 = gca;
   ax2.YLim = [0,70];
 ax2.YTick = 0:5:70;
 ax2.YLabel.String= 'Time Spent, seconds';
 ax2.XLim = [0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 %names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
ax2.XTickLabels = names(J);
legend('mean','median','std');
grid on

subplot(4,1,4)

for i=1:numSensors
    zA(i,1) = Amean(4,i);
    zA(i,2) = Amed(4,i);
    zA(i,3) = Astd(4,i);
end
    bar(zA)   
    title('Ambiguous Key Map (AKM) n=10');
  ax2 = gca;
   ax2.YLim = [0,70];
 ax2.YTick = 0:5:70;
 ax2.YLabel.String= 'Time Spent, seconds';
 ax2.XLim = [0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 %names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
ax2.XTickLabels = names(J);
legend('mean','median','std');
grid on
    
%%
%THIS IS THE PLOT OF THE GROUP
clf
   names= {'FOU','TLC','GRW','QAC','PHA','CHE','UND','QMC','KWC','KWG','MKS','TUL','MKN','MST','CYS', 'WLP', 'PRS','WAT'}
   timeConversion = 1/14500*290; 
 meanT=mean(sumVector*timeConversion);
   [sortedM,I]=sort(meanT,'descend');
   D=sumVector(:,I)/14500*290;
 
 %boxplot(DM,'BoxStyle','outline');
 hold on
 %boxplot(D,'Color','k','BoxStyle','filled');
  boxplot(D,'BoxStyle','outline');
   title('Entire Group n=30');
   
   grid on
  hold off
 ax2 = gca;
 set(gca,'LooseInset',get(gca,'TightInset'))
 ax2.YLim = [-2,100];
 ax2.YTick = 0:10:150;
 ax2.YLabel.String= 'LTL, (s)';
 ax2.XLim=[0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
 ax2.XTickLabels = names(I);

%%
  
subplot(3,1,1)
    scatter(1:numSensors,Amean(1,:),'s','k','filled');
    hold on
    scatter(1:numSensors,Amean(2,:),'d','k','filled');
    scatter(1:numSensors,Amean(3,:),'o','k','filled');
    scatter(1:numSensors,Amean(4,:),'*','k','filled');
    hold off
    grid on
     
     title('mean');
  ax2 = gca;
   ax2.YLim = [0,50];
 ax2.YTick = 0:5:50;
 ax2.YLabel.String= 'Time Spent for each Location, seconds';
 ax2.XLim = [0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};


subplot(3,1,2)
    scatter(1:numSensors,Amed(1,:),'s','k','filled');
    hold on
    scatter(1:numSensors,Amed(2,:),'d','k','filled');
    scatter(1:numSensors,Amed(3,:),'o','k','filled');
    scatter(1:numSensors,Amed(4,:),'*','k','filled');
    hold off
    grid on
    
     title('median');
  ax2 = gca;
   ax2.YLim = [0,50];
 ax2.YTick = 0:5:50;
 ax2.YLabel.String= 'Time Spent for each Location, seconds';
 ax2.XLim = [0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};

  subplot(3,1,3)
    scatter(1:numSensors,Astd(1,:),'s','k','filled');
    hold on
    scatter(1:numSensors,Astd(2,:),'d','k','filled');
    scatter(1:numSensors,Astd(3,:),'o','k','filled');
    scatter(1:numSensors,Astd(4,:),'*','k','filled');
    hold off
    grid on
    
     title('standard deviation');
  ax2 = gca;
   ax2.YLim = [0,50];
 ax2.YTick = 0:5:50;
 ax2.YLabel.String= 'Time Spent for each Location, seconds';
 ax2.XLim = [0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};

    
%%
% stanDev=std(sumVector/14500*290);
% stanDevMap=std(sumVectorMap/14500*290);
% stanDevNoMap=std(sumVectorNoMap/14500*290);
% stanDevAMap=std(sumVectorAMap/14500*290);

stdK=std(stanDev);
stdM=std(stanDevMap);
stdN=std(stanDevNoMap);
stdA=std(stanDevAMap);


stdK=std(stanDev)
stdM=std(stanDevMap)
stdN=std(stanDevNoMap)
stdA=std(stanDevAMap)

% meanT=mean(sumVector/14500*290);
% meanTMap=mean(sumVectorMap/14500*290);
% meanTNoMap=mean(sumVectorNoMap/14500*290);
% meanTAMap=mean(sumVectorAMap/14500*290);

stdM=std(meanT);
stdMKM=std(meanTMap);
stdMNM=std(meanTNoMap);
stdMAM=std(meanTAMap);



stdM=std(meanT)
stdMKM=std(meanTMap)
stdMNM=std(meanTNoMap)
stdMAM=std(meanTAMap)

median


names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
% names
[sortedM,I]=sort(meanT,'descend');
% meanT
% sortedM
% sortedNames=names(I);
% sortedNames


subplot(2,1,1)
%figure
M=scatter(1:numSensors,meanT(I),100,'k','s');
hold on
mM=scatter(1:numSensors,meanTMap(I),100,'r','o')
mN=scatter(1:numSensors,meanTNoMap(I),100,'b','o')
mA=scatter(1:numSensors,meanTAMap(I),100,'r','x')



plot(1:numSensors,meanT(I),'k',1:numSensors,meanTMap(I),'r',1:numSensors,meanTNoMap(I),'b',1:numSensors,meanTAMap(I),'r--');
hold off
grid on
 title('mean');
  ax2 = gca;
   ax2.YLim = [0,50];
 ax2.YTick = 0:5:50;
 ax2.YLabel.String= 'Time Spent for each Location, seconds';
 ax2.XLim = [0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};

 ax2.XTickLabels = names(I);
  %ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};

  legend('mean n=30','mean key n=10','mean no key n=10','mean amb key n=10');
 
 subplot(2,1,2)
%figure
M=scatter(1:numSensors,meanT(I),100,'k','s');
hold on


HM=scatter(1:numSensors,stanDevMap(I),100,'r','d');
HN=scatter(1:numSensors,stanDevNoMap(I),100,'b','d');
HA=scatter(1:numSensors,stanDevAMap(I),100,'r','x');

plot(1:numSensors,meanT(I),'k',1:numSensors,stanDevMap(I),'r',1:numSensors,stanDevNoMap(I),'b',1:numSensors,stanDevAMap(I),'r--');
hold off
grid on
 title('std');
  ax2 = gca;
   ax2.YLim = [0,50];
 ax2.YTick = 0:5:50;
 ax2.YLabel.String= 'Time Spent for each Location, seconds';
 ax2.XLim = [0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 %names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
ax2.XTickLabels = names(I);
  %ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};

  legend('mean n=30 ','std key n=10','std no key n=10','std amb key n=10');
 

 %%
  make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.03], [0.06 0.05], [0.06 0.01]);
if ~make_it_tight,  clear subplot;  end
  
 %%
 
 %THIS ARE THE SUBPLOTS OF THE THREE GROUPS
 
 sumVectorMap=sumVector(1:10,:);
sumVectorNoMap=sumVector(11:20,:);
sumVectorAMap=sumVector(21:30,:);
%sumVectorKey=vertcat(sumVectorMap,sumVectorAMap);

%size(sumVectorKey)



 
%stanDevKey=std(sumVectorKey/14500*290,1);
% stanDevMap=std(sumVectorMap/14500*290,1);
% stanDevNoMap=std(sumVectorNoMap/14500*290,1);
% stanDevAMap=std(sumVectorAMap/14500*290,1);

meanT=mean(sumVector/14500*290);
meanTMap=mean(sumVectorMap/14500*290);
meanTNoMap=mean(sumVectorNoMap/14500*290);
meanTAMap=mean(sumVectorAMap/14500*290);


names= {'FOU','TLC','GRW','QAC','PHA','CHE','UND','QMC','KWC','KWG','MKS','TUL','MKN','MST','CYS', 'WLP', 'PRS','WAT'}


%names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
% names
[sortedM,I]=sort(meanT,'descend');
 %sumVectorMap
%sumVectorMap(:,I);
D=sumVector(:,I)/14500*290;
DM=sumVectorMap(:,I)/14500*290;
size(DM)
DN=sumVectorNoMap(:,I)/14500*290;
DA=sumVectorAMap(:,I)/14500*290;

figure(1)
 
 
  subplot(3,1,1)
 boxplot(DM,'BoxStyle','outline');
 hold on
  %boxplot(D,'Color','k','BoxStyle','filled');
   title('\fontsize{14}Key Map, KM');
   
   grid on
  hold off
 ax2 = gca;
 
 ax2.YLim = [-2,100];
 ax2.YTick = 0:10:100;
 ax2.YLabel.String= '\fontsize{14}Tot Seconds';
 ax2.XLim=[0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
 ax2.XTickLabels = names(I);
 %ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};

 
  subplot(3,1,2)
  boxplot(DN,'BoxStyle','outline');
  hold on
  %boxplot(D,'Color','k','BoxStyle','filled');
  
  title('\fontsize{14}No Key Map, NKM');
   grid on
  hold off
 ax2 = gca;
 
 ax2.YLim = [-2,100];
 ax2.YTick = 0:10:100;
 ax2.YLabel.String= '\fontsize{14}Tot Seconds';
 ax2.XLim=[0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
 ax2.XTickLabels = names(I);
% ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};

 
  
  subplot(3,1,3)
  boxplot(DA,'BoxStyle','outline');
  hold on
  %boxplot(D,'Color','k','BoxStyle','filled');
    title('\fontsize{14}Ambiguous Key Map, AKM');
   grid on
  hold off
 ax2 = gca;

 ax2.YLim = [-2,100];
 ax2.YTick = 0:10:100;
 ax2.YLabel.String= '\fontsize{14}Tot Seconds';

 ax2.XLim=[0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
 ax2.XTickLabels = names(I);
% ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};

%%
 %figure(2)
 sumVector
  
sumVectorMap=sumVector(1:10,:);
sumVectorAMap=sumVector(21:30,:);
sumVectorNoMap=sumVector(11:20,:);

%sumVectorKey=vertcat(sumVectorMap,sumVectorAMap);
%size(sumVectorKey)
%stanDevKey=std(sumVectorKey/14500*290,1);
% stanDevMap=std(sumVectorMap/14500*290,1);
% stanDevNoMap=std(sumVectorNoMap/14500*290,1);
% stanDevAMap=std(sumVectorAMap/14500*290,1);
% 
% meanT=mean(sumVector/14500*290);
% meanTMap=mean(sumVectorMap/14500*290);
% meanTNoMap=mean(sumVectorNoMap/14500*290);
% meanTAMap=mean(sumVectorAMap/14500*290);

  stanDevLoc=std(sumVector/14500*290,1,1);
  size(stanDevLoc)
 stanDevLoc
  stanDevLocK=std(sumVectorMap/14500*290,1,1);
  stanDevLocN=std(sumVectorNoMap/14500*290,1,1);
  stanDevLocA=std(sumVectorAMap/14500*290,1,1);
  
 DDev = stanDevLoc(I);
 DDevK = stanDevLocK(I);
 DDevN = stanDevLocN(I);
 DDevA = stanDevLocA(I);
 
 plot(1:numSensors,DDev,'k:o',1:numSensors,DDevK,'r-o',1:numSensors,DDevN,'b-o',1:numSensors,DDevA,'r--x');
 
%hold off
grid on
 title('standard deviation across Locations');
  ax2 = gca;
   ax2.YLim = [0,50];
 ax2.YTick = 0:5:50;
 ax2.YLabel.String= 'Standard Deviation Time for average across Locations, seconds';
 ax2.XLim = [0,19];
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 %names ={'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
ax2.XTickLabels = names(I);
 
legend('Std n=30','Std Key Map n=10', 'Std No Map n=10', 'Std Amb. Map n=10');
  
  %%
%subplot(2,1,1)
 boxplot(sumVector1/length(T),'Notch','on','Color','r','BoxStyle','outline');
hold on
 %boxplot(sumVector/length(T),'Color','k', 'BoxStyle','filled');
 boxplot(sumVector2/length(T),'Notch','on','Color','b','BoxStyle','outline');
%  h1= plot(1:18,std(sumVector(21:30,:)));
 title('keymap');
   grid on
  %hold off
 ax2 = gca;
 ax2.YLim = [0,0.4];
 ax2.YTick = 0:0.05:0.4;
 ax2.YLabel.String= 'Time Spent / Overall Time';
 %ax2.YTickLabels = {'0','30','60','90','120','150','180','210'};
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
 ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
%ax2.XTickLabels.FontSize = 10;
%ax2.XLabel= 'Locations';

% subplot(2,1,2)
%  boxplot(sumVector3/length(T),'Color','blue','BoxStyle','outline');
% hold on
%  boxplot(sumVector/length(T),'Color','k', 'BoxStyle','filled');
% %  h1= plot(1:18,std(sumVector(21:30,:)));
%  title('no keymap');
%    grid on
%   %hold off
%  ax2 = gca;
%  ax2.YLim = [0,0.4];
%  ax2.YTick = 0:0.05:0.4;
%  ax2.YLabel.String= 'Time Spent / Overall Time';
%  %ax2.YTickLabels = {'0','30','60','90','120','150','180','210'};
%  ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
%  ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
% %ax2.XTickLabels.FontSize = 10;
% %ax2.XLabel= 'Locations';

