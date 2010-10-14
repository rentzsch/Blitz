//
//  MyAppDelegate.m
//  Blitz
//
//  Created by Kevin Mitchell on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyAppDelegate.h"


@implementation MyAppDelegate

@synthesize windowControllers;

- (IBAction)showFloatingCounters:(id)sender
{
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
}
@end
