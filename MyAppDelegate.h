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
    NSUInteger secondsElapsed;
    KeynoteApplication *keynote;
}

@property (retain) NSMutableArray *windowControllers;
@property (retain) KeynoteApplication *keynote;
@property (assign) NSUInteger secondsElapsed;

- (IBAction)showFloatingCounters:(id)sender;

@end
