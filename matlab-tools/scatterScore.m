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
T=0;
activeMat=[];
%count = zeros(3000,1,30);
%timeArray =[];
%function averageGroups(groupArray)
%%

%%

clf
index=0;
%ARR = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s'];
sumVector=[];
T=0;
activeMat=[];
bigT=[];
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
% 
%  fid=fopen([filename],'r');
% 
%  %offset = 4739824; %samples
%  %str='alignTime_' SUF ;
%  
%  offset = alignTime;
%  %offset = x;
%  offsetOfBytes = offset*4*numChannels;
%    
%  
%   %audio = fread(fid, 'float');
%   % audio = fread(fid, 'float');
%    
%   audio = fseek(fid,offsetOfBytes,'bof');
%   audio = fread(fid, 'float');
%   %position = ftell(fid)
%  fclose(fid);
%  %audio = vec2mat(audio, numChannels);
%  audioMat = vec2mat(audio, numChannels);
% %sound(audioMat,Fs);


 %25 columns. 1-24 are sensors and 25 is timestamp ( in samples)

s = sensor(:,1:numSensors) / sensorMax; % this is to have it from 0 to 1

T = sensor(1:14500,timestampColumn) / Fs;

activated = gt(sensor(:,1:numSensors),0) ; % matrix of 0 and 1 for each column (sensor)
%transposing the matrix would create rows for sensors and columns for data
%points.
% this would eventually lead to create a column vector having as rows the
% sensors



   sumVector(index,:) = sum(activated,1); 
   
   %activeMat(:,:,index)=activated(:,:);
   for x=1:14500
       for c=1:numSensors
   activeMat(x,c,index)=activated(x,c);
   bigT(x,index)=T(x);
       end
   end
   
   size(activeMat)
   size(bigT)
        
%sumVector


end
%%
bigT=repmat(T,30,1)
%size(T)
Y=activeMat(:,1,:);
size(Y)

%%
%index = [1:30];
for i=1:30
%A=[1 4]
  %for i=1:2
      %for i=[1 10]
          %for i=[1 10]


 %subplot(3,10,i)

 figure(i)
 
 for j = 1:numSensors
     
    scatter (bigT(:,i), activeMat(:,j,i)*j,  's','LineWidth',1);
    hold on
 end
 
 
 
  %hA = scatter (bigT(:,i), activeMat(:,1,index)*1,  's','LineWidth',1);
%subplot(2,1,1);
 %h = plot(audioTime(1:10:end), audioMat(1:10:end,2), T, count,  '.-');
 % h = scatter (T, activated(:,1)*1,  's','LineWidth',1);
%   hold
%    h1 = scatter (T, activated(:,2)*2,  's');
%     h2 = scatter (T, activated(:,3)*3,  's');
%     h3 = scatter (T, activated(:,4)*4,  's');
% 
%     h5 = scatter (T, activated(:,5)*5,  's');
% 
%     h6 = scatter (T, activated(:,6)*6,  's');
%     h7 = scatter (T, activated(:,7)*7,  's');
%     h8 = scatter (T, activated(:,8)*8,  's');
%     h9 = scatter (T, activated(:,9)*9,  's');
%     h10 = scatter (T, activated(:,10)*10,  's');
%     h11 = scatter (T, activated(:,11)*11,  's');
%     h12 = scatter (T, activated(:,12)*12,  's');
%     h13 = scatter (T, activated(:,13)*13,  's');
%     h14 = scatter (T, activated(:,14)*14,  's');
%     h15 = scatter (T, activated(:,15)*15,  's');
%     h16 = scatter (T, activated(:,16)*16,  's');
%     h17 = scatter (T, activated(:,17)*17,  's');
%     h18 = scatter (T, activated(:,18)*18,  's');


 % h = plot(audioTime(1:10:end), audioMat(1:10:end,2), T,(s>0)/10, T, count, '.-');
  %h = plot(A,T);
 %col = [0.95 0.95 0.95]; 
%  col = [0.9 0.9 0.9];
%  set(h(1), 'Color', col)
hold off
  ax1 = gca;
  ax1.YLim = [0.5 18.5];
  ax1.YTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
  ax1.XLim = [-5 305];
  %if (i==1)||(i==11)||(i==21)
  %names= {'FOU','TLC','GRW','QAC','PHA','CHE','UND','QMC','KWC','KWG','MKS','TUL','MKN','MST','CYS', 'WLP', 'PRS','WAT'}
   names = {'Fountain ','Trinity Cons..','Green Wat.','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market South','Turnpin Lane','Market North','Market St.','Cutty S.', 'Water List.' , 'Piers', 'Water'};
  %end
 ax1.YTickLabels = names;
  %ax1.YTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market South','Turnpin Lane','Market North','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
  %end
grid on
%drawnow
%filename = ['score_' i '.png'];
%print('-dpng', filename)
%print('-deps', '-r200', ['sc_' num2str(i+100) '.eps'])
%print('-dpng', '-r200', ['sco_' num2str(i+100) '.png'])
end



 %%
  make_it_tight = true;
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.03], [0.1 0.05], [0.05 0.02]);
if ~make_it_tight,  clear subplot;  end
  
 %%

%%
%index = [1:30];
%for i=1:30
%A=[1 4]
  %for i=1:2
      %for i=[1 10]
          %for i=[1 10]
subplot(1,3,1)

 %figure(i)
 i=7;
 
 for j = 1:numSensors
     
    scatter (bigT(:,i), activeMat(:,j,i)*j,  's','LineWidth',1);
    hold on
 end
 
 hold off
  ax1 = gca;
  ax1.YLim = [0.5 18.5];
  ax1.YTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
  ax1.XLabel.String= 'Time (s), P. 1'; 
  ax1.XLim = [-5 305];
  %if (i==1)||(i==11)||(i==21)
  names= {'FOU','TLC','GRW','QAC','PHA','CHE','UND','QMC','KWC','KWG','MKS','TUL','MKN','MST','CYS', 'WLP', 'PRS','WAT'}
   %names = {'Fountain ','Trinity Cons.','Green Wat.','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market South','Turnpin Lane','Market North','Market St.','Cutty S.', 'Water List.' , 'Piers', 'Water'};
  %end
 ax1.YTickLabels = names;
  %ax1.YTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market South','Turnpin Lane','Market North','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
  %end
grid on
 

 subplot(1,3,2)

 %figure(i)
 i=27;
 
 for j = 1:numSensors
     
    scatter (bigT(:,i), activeMat(:,j,i)*j,  's','LineWidth',1);
    hold on
 end
 
 hold off
  ax1 = gca;
  ax1.YLim = [0.5 18.5];
  ax1.YTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
  ax1.XLim = [-5 305];
  ax1.XLabel.String= 'Time (s), P. 2'; 
  %if (i==1)||(i==11)||(i==21)
  %names= {'FOU','TLC','GRW','QAC','PHA','CHE','UND','QMC','KWC','KWG','MKS','TUL','MKN','MST','CYS', 'WLP', 'PRS','WAT'}
   %names = {'Fountain ','Trinity Cons.','Green Wat.','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market South','Turnpin Lane','Market North','Market St.','Cutty S.', 'Water List.' , 'Piers', 'Water'};
  %end
 %ax1.YTickLabels = names;
  %ax1.YTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market South','Turnpin Lane','Market North','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
  %end
grid on
 
 
 subplot(1,3,3)

 %figure(i)
 i=2;
 
 for j = 1:numSensors
     
    scatter (bigT(:,i), activeMat(:,j,i)*j,  's','LineWidth',1);
    hold on
 end
 
 
 
  %hA = scatter (bigT(:,i), activeMat(:,1,index)*1,  's','LineWidth',1);
%subplot(2,1,1);
 %h = plot(audioTime(1:10:end), audioMat(1:10:end,2), T, count,  '.-');
 % h = scatter (T, activated(:,1)*1,  's','LineWidth',1);
%   hold
%    h1 = scatter (T, activated(:,2)*2,  's');
%     h2 = scatter (T, activated(:,3)*3,  's');
%     h3 = scatter (T, activated(:,4)*4,  's');
% 
%     h5 = scatter (T, activated(:,5)*5,  's');
% 
%     h6 = scatter (T, activated(:,6)*6,  's');
%     h7 = scatter (T, activated(:,7)*7,  's');
%     h8 = scatter (T, activated(:,8)*8,  's');
%     h9 = scatter (T, activated(:,9)*9,  's');
%     h10 = scatter (T, activated(:,10)*10,  's');
%     h11 = scatter (T, activated(:,11)*11,  's');
%     h12 = scatter (T, activated(:,12)*12,  's');
%     h13 = scatter (T, activated(:,13)*13,  's');
%     h14 = scatter (T, activated(:,14)*14,  's');
%     h15 = scatter (T, activated(:,15)*15,  's');
%     h16 = scatter (T, activated(:,16)*16,  's');
%     h17 = scatter (T, activated(:,17)*17,  's');
%     h18 = scatter (T, activated(:,18)*18,  's');


 % h = plot(audioTime(1:10:end), audioMat(1:10:end,2), T,(s>0)/10, T, count, '.-');
  %h = plot(A,T);
 %col = [0.95 0.95 0.95]; 
%  col = [0.9 0.9 0.9];
%  set(h(1), 'Color', col)
hold off
  ax1 = gca;
  ax1.YLim = [0.5 18.5];
  ax1.YTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
   ax1.XLabel.String= 'Time (s), P. 3';  
  ax1.XLim = [-5 305];
  %if (i==1)||(i==11)||(i==21)
  %names= {'FOU','TLC','GRW','QAC','PHA','CHE','UND','QMC','KWC','KWG','MKS','TUL','MKN','MST','CYS', 'WLP', 'PRS','WAT'}
   %names = {'Fountain ','Trinity Cons..','Green Wat.','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market South','Turnpin Lane','Market North','Market St.','Cutty S.', 'Water List.' , 'Piers', 'Water'};
  %end
 %ax1.YTickLabels = names;
  %ax1.YTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market South','Turnpin Lane','Market North','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
  %end
grid on
%drawnow
%filename = ['score_' i '.png'];
%print('-dpng', filename)
%print('-deps', '-r200', ['sc_' num2str(i+100) '.eps'])
%print('-dpng', '-r200', ['sco_' num2str(i+100) '.png'])
%end