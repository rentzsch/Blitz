//
//  MyAppDelegate.h
//  Blitz
//
//  Created by Kevin Mitchell on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Keynote.h"

@interface MyAppDelegate : NSObject {
    NSMutableArray *windowControllers;
    NSWindowController *preferencesWindowController;
    NSTimeInterval secondsElapsed;
    KeynoteApplication *keynote;
    bool running;
    NSTimer *timer;
}

@property (retain) NSMutableArray *windowControllers;
@property (retain) NSWindowController *preferencesWindowController;
@property (retain) KeynoteApplication *keynote;
@property (assign, setter=setSecondsElapsed:) NSTimeInterval secondsElapsed;
@property (assign) bool running;
@property (retain) NSTimer *timer;

- (IBAction)startStopReset:(id)sender;
- (void) setSecondsElapsed:(NSTimeInterval)elapsed;

- (IBAction)showFloatingCounters:(id)sender;
- (IBAction)showPreferences:(id)sender;

@end
