//
//  MyAppDelegate.h
//  Blitz
//
//  Created by Kevin Mitchell on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyAppDelegate : NSObject {
    NSMutableArray *windowControllers;
}

@property (retain) NSMutableArray *windowControllers;

- (IBAction)showFloatingCounters:(id)sender;

@end
