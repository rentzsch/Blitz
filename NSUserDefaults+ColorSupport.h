//
//  NSUserDefaults+ColorSupport.h
//  Blitz
//
//  Created by Kevin Mitchell on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSUserDefaults(ColorSupport)
    - (void)setColor:(NSColor *)aColor forKey:(NSString *)aKey;
    - (NSColor *)colorForKey:(NSString *)aKey;
@end
