%now we see what is the first location that every participant chose.

%we see the order of locations

%function findSensor(SUF) retrieves the first 18 locations chosen and
%creates an array of 18 elements for the first 18 locations, it checks
%if the location is different from the previous one

%function interactionMode(SUF) retrieves the order of the locations among
%zeros, this means, it can be the same if the person lift the finger

%function listFirst(Array) retrieves an array of 30 elements (n=30)
%with all the first locations
%if x is the number of locations, it counts on the y the number of elements
%for each locations


%function listFirstGroups(groupArray)
%we are going to call this function inside averageGroups file.
%inside the for loop we check if any of the colums is greater than zero

firstList=[];
secondList=[];
thirdList=[];
index=0;
foundFirst=[];
foundSecond=[];
foundThird=[];

%ARR = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s'];

%for subgroup = 1:3
    
for SUF = groupArray    %we are checking among the indexes already sorted [subgroup] %SUF
    SUF = num2str(SUF);  % convert number into string
    index=index+1;    %keep track of where we are
%create a big Matrix

%foundFirst(index)=0;  %30 elements Vector % this can be dynamic but needs to be initialised
foundFirst(index)=0;
foundSecond(index)=0;%has to run for every SUF
foundThird(index)=0;

run(['sensorLog18Rev_' SUF '.m'])  %run the different aligned Matrixes

%filename = ['audio_' SUF '.bin'];   %no need for this really
%numChannels = 2;
Fs = 44100;

sensorMax = 255;
numSensors = 18;
timestampColumn = 19;
limit = 0.0;
%s = sensor(:,1:numSensors) / sensorMax; % this is to have it from 0 to 1
T = sensor(:,timestampColumn) / Fs;

if foundFirst(index) == 0 %run this only if haven't found yet

%for j=1:length(T) %check through the samples
    for k=1:numSensors
    
        if gt(sensor(10,k),0)%check if value>0  %row is 10 by design
        %if yes
        firstList(index)=k;%allocate the column number for each participant
        foundFirst(index)=foundFirst(index)+1;% column has been found, but check if there are more than one
        %store the index in an array
        end
    end
end
if (foundFirst(index) == 1) & (foundSecond(index) == 0)%run this only if we found the first

    for t = 1:length(T)
%for j=1:length(T) %check through the samples
        for k=1:numSensors
    %go through the rest of the data
            
            if ((gt(sensor(t,k),0))&(k~= firstList(index)))%check if value>0  %row is 10 by design
        %if yes
            secondList(index)=k;%allocate the column number for each participant
            foundSecond(index)=foundSecond(index)+1;% column has been found, but check if there are more than one
        %store the index in an array
            end
        end
    end
end



end
firstList
secondList
%thirdList
%foundFirst %only one location

countLocations=zeros(1,numSensors);
countLocations2=zeros(1,numSensors);
%countLocations3=zeros(1,numSensors);
%countLocations
%size(countLocations)
%size(firstList)
firstList=transpose(firstList);
secondList=transpose(secondList);%firstList.'
%thirdList=transpose(thirdList);%firstList.'
%size(firstList)

   
    for j=1:numSensors%go through Locations
        
        for i=1:length(firstList)%go through participants
   %check if Locations is present and increment
   if firstList(i)==j
       countLocations(1,j)=countLocations(1,j)+1;%increment count
   %else countLocations(1,j)=0;  
   end    
    if secondList(i)==j
       countLocations2(1,j)=countLocations2(1,j)+1;%increment count
   %else countLocations(1,j)=0;  
    end 
%    if thirdList(i)==j
%        countLocations3(1,j)=countLocations3(1,j)+1;%increment count
%    %else countLocations(1,j)=0;  
%    end 
   
   %check second location
   
    end
end   

countLocations
countLocations2
%countLocations3

names= {'FOU','TLC','GRW','QAC','PHA','CHE','UND','QMC','KWC','KWG','MKS','TUL','MKN','MST','CYS', 'WLP', 'PRS','WAT'};

%[sortedM,I]=sort(meanT,'descend');
[countSorted,I]=sort(countLocations,'descend');
countSorted2 = countLocations2(I);
%countSorted3 = countLocations3(I);
%[countSorted2,I]=sort(countLocations2,'descend');




%subplot(4,1,1)

for i=1:numSensors
    z(i,1) = countSorted(1,i);
    z(i,2) = countSorted2(1,i);
    %z(i,3) = countSorted3(1,i);
    
end
    %bar(z)  



clf
figure(1)
 %k = bar(1:1:numSensors,countLocations(1,:));
 %k = bar(1:1:numSensors,countSorted(1,:));
  k = bar(1:1:numSensors,z(:,:));
 title('Locations chosen as First or Second');
 ax2 = gca;
 set(gca,'LooseInset',get(gca,'TightInset'))
 ax2.YLim = [0,9];
 ax2.YTick = 0:1:9;
 ax2.YLabel.String= 'N. of choices';
 %ax2.YTickLabels = {'0','30','60','90','120','150','180','210'};
 ax2.XTick = [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 ];
 ax2.XLim = [0,19];
 ax2.XTickLabels = names(I);
 %ax2.XTickLabels = {'Fountain ','Trinity K.C.C.','Green Wat','Q.Anne C.','Painted H.','Chapel Entr.','Undercr.','Q. Mary C.','K.William C.','K. W. Green','Market S.','Turnpin Lane','Market N.','Market St.','Cutty S.', 'Waterside' , 'Piers', 'Water'};
%ax2.XTickLabels.FontSize = 10;
%ax2.XLabel.String= 'Locations';

 legend('First Choice','Second Choice');
 
 
