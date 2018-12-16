% this will create a variable called "sensor"
group1 = [112:115,117:119,122,126,130];%keymap red
group3 = [106:109,111,111,124,125,127,128];%ambiguous keymap blue
%group3 = [106:111,124,125,127,128];%ambiguous keymap blue
group2 = [101:105, 116,120,121,123,130]; %no keymap green

groupArray = [group1,group2,group3];
index=0;

countMatrix=[14500,3];

for SUF = groupArray%[subgroup] %SUF
    SUF = num2str(SUF);
    index=index+1;

%SUF='n';
run(['sensorLog18Rev_' SUF '.m'])

filename = ['audio_' SUF '.bin'];
numChannels = 2;
Fs = 44100;

sensorMax = 255;
numSensors = 18;
timestampColumn = 19;


limit = 0.0;



 %25 columns. 1-24 are sensors and 25 is timestamp ( in samples)

s = sensor(:,1:numSensors) / sensorMax; % this is to have it from 0 to 1

T = sensor(:,timestampColumn) / Fs;

activated = gt(sensor(:,1:numSensors),0) ; % matrix of 0 and 1 for each column (sensor)
%transposing the matrix would create rows for sensors and columns for data
%points.
% this would eventually lead to create a column vector having as rows the
% sensors





count = 0;

for c = 1 : numSensors
         
    
 for x = 1:length(T)
   
   
     activated (x,c)= gt(activated(x,c),0);
  
    end
 end
 %size(count)
 
%triggered(100:150,:)
 
%sum is doing sum on the matrix activated rows are timestamps lines,
%columns are activated or not
%counts is counting how many ones we have for each row
%in order to do the mean we need to execute code for each line until 5 min
%(3000 lines)we need the mean for each time line, but the points in time
%are not aligned and we need to discard the audio information. It would be
%mean (x= rows, sum) across the data set
%we need to create another matrix to store the different sums in time
%we can do this after calling the specific count and running a for loop for
%each line (rows of matrix count)but we have 16040 lines, not 3000, the
%sampling rate is 50 Hz 50 samples per second which means one point every
%20 millisecond. 320 seconds.80. we have 15000 lines, we can take 10 seconds more which is 15500
%pseudo code is for every x = 1:15500 store sum in a column, page = index

count=sum(activated,2); %this creates a sumVector for the number of areas activated in time, rows are time, value
size(count)
%size(activated)



for x=1:14500
   countMatrix(x,index)=count(x); 
   Tred(x)=T(x);
end



end

average=std(countMatrix ,0,2);
%average=mean(countMatrix ,2);



size(average)
size(Tred)



%  xlabel('Time (Seconds)'); ylabel('Frequencies Hz');
  %xlabel('Time (Seconds)'); ylabel('Areas touched');
  xlabel('Time (Seconds)'); ylabel('num of Areas touched');


   
 figure
 %subplot(2,1,1);
 h = plot( Tred, average(:),  '.-');
   

 % h = plot(audioTime(1:10:end), audioMat(1:10:end,2), T,(s>0)/10, T, count, '.-');
  %h = plot(A,T);
 %col = [0.95 0.95 0.95]; 
 %col = [0.9 0.9 0.9];
 set(h(1), 'Color', 'b')
 ax1 = gca;
 ax1.YLim = [-2 12];
  ax1.YTick = [-2 -1 0 1 2 3 4 5 6 7 8 9 10 11 ];
  ax1.YTickLabels = {' ',' ','0','1','2','3','4','5','6','7','8','9','10','11'};
  ax1.XLim = [0 330];
  ax1.XTick = [0:30:330];
 
 
 
 %plot(h,k);
  
  %plot(T,s,audioTime, audioMat)

 %plot(T,s,audioTime, audioMat)
 %plot(T,s)