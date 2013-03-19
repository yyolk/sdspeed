sdspeed
=======
Measures the effective read and write speed of SD memory cards. sdspeed runs on Mac OS X.

Version and Author
==================
sdspeed 1.0 (18.MAR.2013) by Michael Mustun <michael.mustun@gmail.com>

Compile
=======
Just fire up Xcode and compile it.

Author System
-------------
- Mac OS X 10.8.3 on MacBook Pro with one SD memory card slot
- Xcode 4.6.1

Usage
=====
1. Insert the SD memory card
2. Start sdspeed, the card should be recognized
3. Hit start. It will first make a write speed test and after that a read speed test. 
   After all, the average of the write and read speed test is showed
4. You can run the test again or just quit the application CMD+Q or red button as usual

Todo
====
- Recognize SD card after sdspeed is started. (Maybe timer, check every second for a card)
- Display read speed while read test is running. Add also progress bar.

Credits
=======
The model behind this user interface is based on F3 - Fight Flash Fraud Version 2.2 by 
Michel Machado who wrote an open source alternative to h2testw and released the code 
under GNU General Public License (GPL) version 3. For more information about F3 please 
visit http://oss.digirati.com.br/f3/
