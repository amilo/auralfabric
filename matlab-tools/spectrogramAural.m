%begin script to retrieve spectrogram
[y,Fs]=audioread('aural30sec-008-A11.wav');



left=y(:,1); % Left channel 
right=y(:,2); % Right channel

%sound(y,Fs);

window=hamming(512);
noverlap=256;
nfft=4096;
%s= spectrogram();
[S,F,T,P]=spectrogram(left,window,noverlap,nfft,Fs,'yaxis');

%spectrogram(x,'yaxis');
surf(T,F,10*log10(P),'edgecolor','none'); 
 axis tight; 
 view(0,90);
colormap(jet);
ax = gca;
%ax.YScale = 'log' ;
 set(gca,'clim',[-110 -50]);
 xlabel('Time (Seconds)'); ylabel('Frequencies Hz');