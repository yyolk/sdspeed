//
//  f3write.h
//  sdspeed
//
//  Created by M on 16.03.13.
//  Copyright (c) 2013 Flagsoft. All rights reserved.
//

#ifndef sdspeed_f3write_h
#define sdspeed_f3write_h


extern int g_FLAG_shouldTerminate;


// -- write
void        f3write_unlink_old_files(const char *path, int start_at);
double      f3write_fill_fs(const char *path, int start_at, int progress);
double      f3write_getCurrentSpeed(void);
double      f3write_getCurrentPercent(void);
const char* f3write_getCurrentUnit(void);


// -- read
void        f3read_iterate_files(const char *path, const int *files, int start_at, int progress);
double      f3read_getReadSpeedAverage(void);
const char* f3read_getCurrentUnit(void);


#endif
