% this will create a variable called "sensor"
% clf


function conversion_align_newset(SUF)
% ='x';
SUF = num2str(SUF);
run(['sensorLog_' SUF '.m'])

numSensors = 24;
timestampColumn = 25;
Fs=44100;
columns=[];
alignStart=0;
alignTime=0;
startingRow=0;
length(sensor)

for r = 1:length(sensor)
    
  %for (c = 1:numSensors)
      
     if alignStart == 0 
             
         %alignStart =  any(sensor(r)); 
         
         A = any(sensor(r,1:numSensors));
         if A
         %alignTime = sensor(r,25)-Fs;
         alignTime = sensor(r-10,25)-Fs;
          %alignStart = 2;
          alignStart=2;
          startingRow=r-10;%allow 1 sec space
          %disp('I found a row different from zero here at row');
          fprintf('I found a row different from zero here at row %d and timestamp %d, second %f',r,alignTime, alignTime/44100);
         
         else
          %disp('I found nothing');
         end
         
     else
    end
     
  %end 
end     

alignTime  
startingRow  ; %allow some margin for the audio
newZero=startingRow;
startingRow
newlength = length(sensor)-startingRow;
newlength

  for r = 1:newlength
          
        columns(r,1) = sensor(r+newZero, 1);
        m23 = max(sensor(r+newZero,2),sensor(r+newZero,3));
        columns(r,2) = m23;
        columns(r,3) = sensor(r+newZero, 4);
        m56 = max(sensor(r+newZero,5),sensor(r+newZero,6));
        columns(r,4) = m56;
        columns(r,5:10) = sensor(r+newZero, 7:12);
        columns(r,11) = sensor(r+newZero, 13);
        columns(r,12:13) = sensor(r+newZero, 15:16);
        %columns(r,14:17) = sensor(r+newZero, 18:21);
        columns(r,14:15) = sensor(r+newZero, 18:19);
       
        columns(r,16) = sensor(r+newZero, 21);
        columns(r,17) = sensor(r+newZero, 22);
        if sensor(r+newZero, 22)==0;
            m2324=max(sensor(r+newZero,23),sensor(r+newZero,24));
        columns(r,18) = m2324;
        else 
        columns(r,18) = sensor(r+newZero, 23);
        end
        columns(r,19) = sensor(r+newZero, 25)-alignTime;
        
end
        
columns = columns.';
fileID = fopen(['sensorLog18Rev_' SUF '.m'],'w');

fprintf(fileID,'sensor = [\n');
fprintf(fileID,'%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n',columns);
fprintf(fileID,'];\n');
%fprintf(fileID,'alignTime_%s= %d ;',SUF,alignTime);
fprintf(fileID,'alignTime = %d ;',alignTime);
fclose(fileID);
end
