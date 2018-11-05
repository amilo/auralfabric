Aural Fabric study version. 
author: Alessia Milo.

This program logs the data captured by the sensing areas as integers (sensorLog.m).
It also records a binary raw file (audio.bin) as sent to stereo audio out, ready for alignment and analysis in matlab.
The tools for analysis can be found [here](https://github.com/amilo/auralfabric/tree/master/matlab-tools).

This software was used with some variations in the study documented here:

Milo, A., Bryan-Kinns, N., & Reiss, J. D. (2017, October). Influences of a key on soundwalk exploration with a textile sonicmap. In Audio Engineering Society Convention 143. Audio Engineering Society. [paper](http://www.eecs.qmul.ac.uk/~josh/documents/2017/Milo%20-%20AES143.pdf)


It can be set to stop after a specific range of time in render.cpp line 310.

It needs to be linked with the recordings listed in at line 100 of render.cpp.

The recordings can be found [here](https://freesound.org/people/vertex_wave/packs/25307/).



