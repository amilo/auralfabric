/*
 ____  _____ _        _    
| __ )| ____| |      / \   
|  _ \|  _| | |     / _ \  
| |_) | |___| |___ / ___ \ 
|____/|_____|_____/_/   \_\

The platform for ultra-low latency audio and sensor processing

http://bela.io

A project of the Augmented Instruments Laboratory within the
Centre for Digital Music at Queen Mary University of London.
http://www.eecs.qmul.ac.uk/~andrewm

(c) 2016 Augmented Instruments Laboratory: Andrew McPherson,
  Astrid Bin, Liam Donovan, Christian Heinrichs, Robert Jack,
  Giulio Moro, Laurel Pardue, Victor Zappi. All rights reserved.

The Bela software is distributed under the GNU Lesser General Public License
(LGPL 3.0), available here: https://www.gnu.org/licenses/lgpl-3.0.txt
*/


#include <Bela.h>
#include <cmath>
#include <Scope.h>
#include <SampleStream.h>
#include <WriteFile.h>
#include "I2C_MPR121.h"

#define NUM_CHANNELS 2    // NUMBER OF CHANNELS IN THE FILE
#define BUFFER_LEN 44100   // BUFFER LENGTH
#define NUM_STREAMS 24  // NUMBER OF PLAYBACK STREAMS

// How many pins there are
#define NUM_TOUCH_PINS 12 // (NUM_TOUCH_PINS*NUM_SENSORS) MUST BE < NUM_STREAMS
// How many mpr121 sensors
#define NUM_SENSORS 2
// Define this to print data to terminal
#undef DEBUG_MPR121

/* MPR121 */
// Change this to change how often the MPR121 is read (in Hz)
int readInterval = 50;
// Change this threshold to set the minimum amount of touch
int threshold = 75; //40
// This array holds the continuous sensor values
int sensorValue[NUM_SENSORS][NUM_TOUCH_PINS];
int sensorValue_prev[NUM_SENSORS][NUM_TOUCH_PINS];
int mpr121Address[NUM_SENSORS] = { 0x5A, 0x5B };

I2C_MPR121 mpr121[NUM_SENSORS];			// Object to handle MPR121 sensing
AuxiliaryTask i2cTask;		// Auxiliary task to read I2C
int readCount = 0;			// How long until we read again...
int readIntervalSamples = 0; // How many samples between reads


/* SUPER DODGY HACKY STUFF */

int doNotTrigger11 = 0;
int triggered10or11 = 0;
int triggered4or5 = 0;
int triggered1or2 = 0;

// Auxiliary task to read the I2C board
void readMPR121(void*)
{
    for(int s=0;s<NUM_SENSORS;s++) {
    	for(int i = 0; i < NUM_TOUCH_PINS; i++) {
    		sensorValue[s][i] = -(mpr121[s].filteredData(i) - mpr121[s].baselineData(i));
    		sensorValue[s][i] -= threshold;
    		if(sensorValue[s][i] <= 0)
    			sensorValue[s][i] = 0;
    // 		else
    // 		    sensorValue[s][i] = 1;
#ifdef DEBUG_MPR121
	    	rt_printf("%d ", sensorValue[s][i]);
#endif
    	}
    }
#ifdef DEBUG_MPR121
	rt_printf("\n");
#endif
	
	// You can use this to read binary on/off touch state more easily
	//rt_printf("Touched: %x\n", mpr121.touched());
}

int gCount = 0;

/* SAMPLE READING */
SampleStream *sampleStream[NUM_STREAMS];
AuxiliaryTask gFillBuffersTask;
int gStopThreads = 0;
int gTaskStopped = 0;
// int gCount = 0;
static float fadeTime = 0.5; // Fade-in/out time in seconds
static const char* filenames[] = { 
                                  "A_0_C_Fountain.wav"                 // A_0
                                  ,"A_1_C_CharlesOutside.wav"                      // A_1
                                  ,"A_1_C_CharlesOutside.wav"                      // A_2  // use A_1 rec here
                                  ,"A_3_C_GreenWaterside.wav"                      // A_3
                                  ,"A_5_C_QueenAnnCourt.wav"                      // A_4
                                  ,"A_5_C_QueenAnnCourt.wav"                      // A_5  // use A_5
                                  ,"A_6_C_PaintedHall_edit.wav"          // A_6
                                  ,"A_7_A_MaryChapel.wav"          // A_7
                                  ,"A_8_A_Undercroft_edit.wav"          // A_8
                                  ,"A_9_C_MaryCourt.wav"          // A_9
                                  ,"A_10_C_PaintedHallCourt_edit.wav"          // A_10
                                  ,"A_11_C_OutsidePaintedHallGreen.wav"          // A_11
                                  ,"B_0_C_MarketSouth.wav"          // B_0
                                  ,"waves.wav"                       // B_1
                                  ,"B_3_A_MarketShort.wav"          // B_2
                                  ,"B_5_A_ExitMarket.wav"            // B_3
                                  ,"waves.wav"                       // B_4
                                  ,"B_5_A_ExitMarket.wav"            // B_5
                                  ,"B_6_C_CuttySark.wav"            // B_6
                                  ,"waves.wav"                      // B_7
                                  ,"B_8_C_WaterListening.wav"       // B_8
                                  ,"B_9_C_Boat1and2.wav"              // B_9
                                  ,"waves.wav"                      // B_10
                                  ,"B_11_C_Water.wav"                // B_11
                                 };

void fillBuffers(void*) {
    for(int i=0;i<NUM_STREAMS;i++) {
        if(sampleStream[i]->bufferNeedsFilled())
            sampleStream[i]->fillBuffer();
    }
}

// WriteFile audioFile;
// WriteFile sensorFile;

bool setup(BelaContext *context, void *userData)
{
    // audioFile.init("audio.bin");
    // audioFile.setFileType(kBinary);
    // audioFile.setFormat("%.f %.f %.f"); // workaround to increase the circular buffer size
    // const int strLength = 200;
    // char format[strLength];
    // int pos = 0;
    // for(int n = 0; n < NUM_SENSORS * NUM_TOUCH_PINS + 1; ++n){
    //     pos += snprintf(&format[pos], strLength - pos, "%%.0f ");
    // }
    // pos += sprintf(&format[pos], "\n");
    // if(pos > strLength){
    //     printf("Overflow\n");
    //     return false;
    // }
    // sensorFile.init("sensorLog.m");
    // sensorFile.setFileType(kText);
    // sensorFile.setHeader("sensor = [\n");
    // sensorFile.setFormat(format);
    // sensorFile.setFooter("];\n");
    // sensorFile.setEcho(true);
    // sensorFile.setEchoInterval(100);
    
    // MPR121
    for(int s=0;s<NUM_SENSORS;s++) {
        if(!mpr121[s].begin(1, mpr121Address[s])) {
    		rt_printf("Error initialising MPR121\n");
    		return false;
    	}
    	for(int i=0;i<NUM_TOUCH_PINS;i++) {
    	    sensorValue[s][i] = 0;
	        sensorValue_prev[s][i] = 0;
	    }
    }
	
	i2cTask = Bela_createAuxiliaryTask(readMPR121, 50, "bela-mpr121", NULL);
	readIntervalSamples = context->audioSampleRate / readInterval;
    
    // SAMPLES
    for(int i=0;i<NUM_STREAMS;i++) {
        sampleStream[i] = new SampleStream(filenames[i],NUM_CHANNELS,BUFFER_LEN);
    }
    
    // Initialise sample buffer task
	if((gFillBuffersTask = Bela_createAuxiliaryTask(&fillBuffers, 90, "fill-buffer", NULL)) == 0)
		return false;
	
	return true;
}

void render(BelaContext *context, void *userData)
{
    doNotTrigger11 = 0;
    triggered10or11 = 0;
    triggered4or5 = 0;
    triggered1or2 = 0;
	// schedule touch sensor readings
	if(++readCount >= readIntervalSamples) {
		readCount = 0;
		Bela_scheduleAuxiliaryTask(i2cTask);
	}
    // check if buffers need filling
    Bela_scheduleAuxiliaryTask(gFillBuffersTask);
    
    /* print values */
	// const int logArraySize = NUM_SENSORS * NUM_TOUCH_PINS + 1;
 //   static float logArray[logArraySize];
 //   if(++gCount>=441 / context->audioFrames) {
	//     int idx = 0;
 //       for(int s=0;s<NUM_SENSORS;s++) {
 //           for(int i=0;i<NUM_TOUCH_PINS;i++) {
 //           	logArray[idx++] = sensorValue[s][i];
 //               // rt_printf("[%d %d] ",i,sensorValue[s][i]);
 //           }
 //       }
 //       gCount = 0;
	//     logArray[idx++] = context->audioFramesElapsed;
	//     sensorFile.log(logArray, logArraySize);
 //   }
    
    
    for(int s=0;s<NUM_SENSORS;s++) {
        for(int i=0;i<NUM_TOUCH_PINS;i++) {

            if( s==1 && (i==1 || i==4 || i==7) ) {} // don't check these pins
            else {
                if((sensorValue[s][i] && !(sensorValue_prev[s][i])) || (!sensorValue[s][i] && (sensorValue_prev[s][i])) ) {
                    
                    if(s==1 && i==9) {
                        if(sensorValue[s][i])
                            doNotTrigger11 = 1;
                    }
                    
                    if(doNotTrigger11 && s==1 && i==11)
                        sampleStream[i+s*NUM_TOUCH_PINS]->togglePlaybackWithFade(0.0f,fadeTime);
                    else {
                        if(s==1 && i==10) {             // trigger 10 or 11 (B)
                            if(sensorValue[s][i])
                                triggered10or11 = 1;
                        } else if(s==1 && i==11) {
                            if(sensorValue[s][i])
                                triggered10or11 = 1;
                            sampleStream[i+s*NUM_TOUCH_PINS]->togglePlaybackWithFade(triggered10or11,fadeTime);
                        } else if(s==0 && i==4) {       // trigger 4 or 5 (A)
                            if(sensorValue[s][i])
                                triggered4or5 = 1;
                        } else if(s==0 && i==5) {
                            if(sensorValue[s][i])
                                triggered4or5 = 1;
                            sampleStream[i+s*NUM_TOUCH_PINS]->togglePlaybackWithFade(triggered4or5,fadeTime);
                        } else if(s==0 && i==1) {       // trigger 1 or 2 (A)
                            if(sensorValue[s][i])
                                triggered1or2 = 1;
                        } else if(s==0 && i==2) {
                            if(sensorValue[s][i])
                                triggered1or2 = 1;
                            sampleStream[i+s*NUM_TOUCH_PINS]->togglePlaybackWithFade(triggered1or2,fadeTime);
                        } else {
                            sampleStream[i+s*NUM_TOUCH_PINS]->togglePlaybackWithFade(sensorValue[s][i]?1.0f:0.0f,fadeTime);
                        }
                    }
                    
                    /* // print on trigger
                    rt_printf("Value of sensor %d on board %d is %d previous was %d\n",i,s,sensorValue[s][i],sensorValue_prev[s][i]);
                    for(int s=0;s<NUM_SENSORS;s++) {
                        for(int i=0;i<NUM_TOUCH_PINS;i++) {
                            rt_printf("[%d %d] ",i,sensorValue[s][i]);
                        }
                    }
                    rt_printf("\n");
                    */
                    
                }
                sensorValue_prev[s][i] = sensorValue[s][i];
            }
        }
    }
    
    // // ***** remove this -- it's just a demonstration
    // // random playback toggling
    // for(int s=0;s<NUM_SENSORS;s++) {
    //     for(int i=0;i<NUM_STREAMS;i++) {
    //         // randomly pauses/unpauses + fades in/out streams
    //         if((rand() / (float)RAND_MAX)>0.99999999999999) {
    //             sampleStream[s*NUM_SENSORS+i]->togglePlaybackWithFade(0.1);
    //             rt_printf("toggling playback\n");
    //         }
    //     //         // the above function can also be overloaded specifying the state
    //     //         // of playback to toggle - i.e. togglePlaybackWithFade(1,0.1)
    //     //         // same applies to togglePlayback()
    //     //     /*
    //     //      * demonstrates dynamically reloading samples
    //     //      * (TODO: this should really be done in a separate thread)
    //     //      */
    //     //     // if((rand() / (float)RAND_MAX)>0.9999) {
    //     //     //     // only change sample if sampleStream isn't playing
    //     //     //     if(!sampleStream[i]->isPlaying())
    //     //     //         sampleStream[i]->openFile("chimes_stereo.wav",NUM_CHANNELS,BUFFER_LEN);
    //     //     // }
    //     }
    // }
    // *****
    
    for(unsigned int n = 0; n < context->audioFrames; n++) {
        for(int i=0;i<NUM_STREAMS;i++) {
            // process frames for each sampleStream objects (get samples per channel below)
            sampleStream[i]->processFrame();
        }
        float outLog = 0;
    	for(unsigned int channel = 0; channel < context->audioOutChannels; channel++) {
    	    
            float out = 0;
            for(int i=0;i<NUM_STREAMS;i++) {
                // get samples for each channel from each sampleStream object
                out += sampleStream[i]->getSample(channel);
            }
            // you may need to attenuate the output depending on the amount of streams playin
            audioWrite(context, n, channel, out);
            outLog += out;
    	}
    	// audioFile.log(out); //log audio
    }
}


void cleanup(BelaContext *context, void *userData)
{
    for(int i=0;i<NUM_STREAMS;i++) {
        delete sampleStream[i];
    }
}


/**
\example sampleStreamerMulti/render.cpp

Multiple playback of large wav files
---------------------------

This is an extension of the sampleStreamer example. Functionality of opening
files, managing buffers, retrieving samples etc. is built into the `sampleStream`
class, making it easier to have multiple playback streams at the same time.
Streams can be paused/unpaused with the option of fading in/out the playback.


*/
