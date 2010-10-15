//
//  MyAppDelegate.m
//  Blitz
//
//  Created by Kevin Mitchell on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyAppDelegate.h"
#import "CounterView.h"

@implementation MyAppDelegate

@synthesize windowControllers;
@synthesize secondsElapsed;
@synthesize keynote;

- (void) advanceSlide {
    [[[keynote slideshows] objectAtIndex:0] advance];
}

- (void) tick:(NSTimer*) timer {
    if (self.secondsElapsed < 5 * 60)
        self.secondsElapsed += 1;

    NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithUnsignedInt:self.secondsElapsed],
                              @"secondsElapsed",
                              0, nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateSecondsElapsed
                                                        object:self
                                                      userInfo:userInfo];

    if ((self.secondsElapsed % SECONDS_PER_SLIDE == 0))
        [self advanceSlide];
}

- (IBAction)showFloatingCounters:(id)sender
{
    self.keynote = [SBApplication applicationWithBundleIdentifier:@"com.apple.iWork.Keynote"];

    self.windowControllers = [NSMutableArray array];
    
    for (NSScreen *screen in [NSScreen screens])
    {
        NSWindowController *controller = [[[NSWindowController alloc] initWithWindowNibName:@"CounterWindow"] autorelease];
        [windowControllers addObject:controller];
        
        NSRect screenFrame = [screen frame];
        NSWindow *window = [controller window];
        NSRect windowFrame = [window frame];
        NSPoint windowOrigin;
        windowOrigin.x = screenFrame.origin.x + screenFrame.size.width - windowFrame.size.width - 20;

        if ([screen isEqual:[NSScreen mainScreen]])
            windowOrigin.y = screenFrame.origin.y + screenFrame.size.height - windowFrame.size.height - 40;
        else
             windowOrigin.y = screenFrame.origin.y + 20;

        [window setFrameOrigin:windowOrigin];
        
        // This makes it float.
        [window setLevel:CGShieldingWindowLevel()];
        
        [controller showWindow:self];
    }

    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];

}
@end
