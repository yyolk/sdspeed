//
//  FSAppDelegate.m
//  sdspeed
//
//  Created by M on 16.03.13.
//  Copyright (c) 2013 Flagsoft. All rights reserved.
//

#import "FSAppDelegate.h"


#include "utils.h"
#include "f3write.h"





@implementation FSAppDelegate

@synthesize UI_start;
@synthesize UI_progress;
@synthesize UI_progressValue;

@synthesize UI_volumesName;

@synthesize UI_writeSpeed;
@synthesize UI_writeUnit;

@synthesize UI_readSpeed;
@synthesize UI_readUnit;


NSOperationQueue *opQueue=nil;

NSThread *otherThread = nil;
NSTimer *myTimer = nil;
NSTimer *myTimerStopThread = nil;
NSString *g_VOLUMES_DRIVE_NAME = nil;

int g_FLAG_shouldTerminate = 0;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

    
    

    NSArray *keys = [NSArray arrayWithObjects:NSURLVolumeNameKey, NSURLVolumeIsRemovableKey, nil];
    NSArray *urls = [[NSFileManager defaultManager] mountedVolumeURLsIncludingResourceValuesForKeys:keys options:0];
        NSString *volumeName;
    for (NSURL *url in urls) {
        NSError *error;
        NSNumber *isRemovable;

        [url getResourceValue:&isRemovable forKey:NSURLVolumeIsRemovableKey error:&error];
        if ([isRemovable boolValue]) {
            [url getResourceValue:&volumeName forKey:NSURLVolumeNameKey error:&error];
            NSLog(@"DEBUG: %@", volumeName);
        }
    }
    
    
    g_VOLUMES_DRIVE_NAME = [NSString stringWithFormat:@"/Volumes/%@", volumeName];  //  "/Volumes/NO NAME"

    [UI_volumesName setStringValue:g_VOLUMES_DRIVE_NAME];

}


- (void)updateUI:(NSTimer*)timer
{

    [UI_writeSpeed setStringValue:[NSString stringWithFormat:@"%.2f", f3write_getCurrentSpeed()]];
    [UI_writeUnit setStringValue:[NSString stringWithFormat:@"%s", f3write_getCurrentUnit()]];
    
    
    [UI_progress setDoubleValue:f3write_getCurrentPercent()];
    [UI_progressValue setStringValue:[NSString stringWithFormat:@"%.1f %%", f3write_getCurrentPercent()]];
    
    
}

- (IBAction)UI_start_pressed:(id)sender {

    //[UI_start state] == NSOnState

    
    [UI_start setTitle:@"Please wait..."];
    
    
    if ( [otherThread isExecuting] ) {

        NSLog(@"Thread is working...");

    } else {

        [UI_start setEnabled:NO];
        
        otherThread = [[NSThread alloc] initWithTarget:self selector:@selector(startTheBackgroundJob:) object:nil];
        [otherThread start];
        

        // -- start UI update timer
        
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(updateUI:)
                                                 userInfo:nil
                                                  repeats:YES];
        
    }

    
    
    /*
    myTimerStopThread = [NSTimer scheduledTimerWithTimeInterval:12.0
                                               target:self
                                             selector:@selector(threadStop:)
                                             userInfo:nil
                                              repeats:NO];
     */

    
}


/*- (void)threadStop:(id)arg
{
    NSLog(@"STOP");
    g_FLAG_shouldTerminate = 1;
    //[otherThread cancel];
}*/



- (void)startTheBackgroundJob:(id)arg
{
    int start_at;
    int progress;
    
    start_at = 0;
    double speed_write = 0.0;

    
    //[NSThread sleepForTimeInterval:3];
    

    
    
    // -- reset UI values
    [UI_readSpeed setStringValue:[NSString stringWithFormat:@"%.2f", 0.0]];
    [UI_readUnit setStringValue:[NSString stringWithFormat:@"%s", "NA"]];

    

    
    
    //
    // -- write test
    //
    
    
    f3write_unlink_old_files([g_VOLUMES_DRIVE_NAME UTF8String], start_at);
    
    
    /* If stdout isn't a terminal, supress progress. */
	//progress = isatty(STDOUT_FILENO);
    progress=1;
    speed_write = f3write_fill_fs([g_VOLUMES_DRIVE_NAME UTF8String] , start_at, progress);
    NSLog(@"AV SPEED: %f", speed_write);

    //
    // -- all done
    //
    
    [myTimer invalidate];
        
    [UI_writeSpeed setStringValue:[NSString stringWithFormat:@"%.2f", speed_write]];
    
    [UI_start setEnabled:YES];
    [UI_start setTitle:@"Start"];


    [UI_progress setDoubleValue:100.0];
    [UI_progressValue setStringValue:[NSString stringWithFormat:@"%.1f %%", 100.0]];

    
    
    
    
    
    
    //
    // -- read test
    //

    int read_start_at;
	const char *read_path;
	const int *read_files;
	int read_progress;
    
    
    read_start_at = 0;
    read_path = [g_VOLUMES_DRIVE_NAME UTF8String];
    
    read_files = ls_my_files(read_path, read_start_at);
	//If stdout isn't a terminal, supress progress.
	read_progress = isatty(STDOUT_FILENO);
    read_progress = 1;
	f3read_iterate_files(read_path, read_files, read_start_at, read_progress);
	free((void *)read_files);

    
    [UI_readSpeed setStringValue:[NSString stringWithFormat:@"%.2f", f3read_getReadSpeedAverage()]];
    [UI_readUnit setStringValue:[NSString stringWithFormat:@"%s", f3read_getCurrentUnit()]];

    
    // -- clean up files
    f3write_unlink_old_files([g_VOLUMES_DRIVE_NAME UTF8String], 0);
    
}


@end
