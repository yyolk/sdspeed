//
//  FSAppDelegate.h
//  sdspeed
//
//  Created by M on 16.03.13.
//  Copyright (c) 2013 Flagsoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>





@interface FSAppDelegate : NSObject <NSApplicationDelegate> {
    __weak NSButton *UI_start;
    __weak NSTextField *UI_speedWrite;
}




@property (assign) IBOutlet NSWindow *window;


- (IBAction)UI_start_pressed:(id)sender;
@property (weak) IBOutlet NSButton *UI_start;


@property (weak) IBOutlet NSTextField *UI_writeSpeed;
@property (weak) IBOutlet NSTextField *UI_volumesName;
@property (weak) IBOutlet NSTextField *UI_writeUnit;
@property (weak) IBOutlet NSProgressIndicator *UI_progress;
@property (weak) IBOutlet NSTextField *UI_progressValue;


@property (weak) IBOutlet NSTextField *UI_readSpeed;
@property (weak) IBOutlet NSTextField *UI_readUnit;

@end
