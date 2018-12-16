SUF='110';
run(['sensorLog18Revbb_' SUF '.m'])

numSensors = 18;
timestampColumn = 19;
Fs=44100;



length(sensor)
oldNumRows=length(sensor);

%oldNumRows=10759;

for r = 1:5000
      
      sensor(oldNumRows+r,19) = 9684164+(r*896); 
          
      sensor(oldNumRows+r,1:18)=0;
    
        
end
        
length(sensor)

