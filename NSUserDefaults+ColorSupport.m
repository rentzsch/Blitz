//
//  NSUserDefaults+ColorSupport.m
//  Blitz
//
//  Created by Kevin Mitchell on 10/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSUserDefaults+ColorSupport.h"

@implementation NSUserDefaults(ColorSupport)

- (void)setColor:(NSColor *)aColor forKey:(NSString *)aKey
{
    NSData *theData=[NSArchiver archivedDataWithRootObject:aColor];
    [self setObject:theData forKey:aKey];
}

- (NSColor *)colorForKey:(NSString *)aKey
{
    NSColor *theColor=nil;
    NSData *theData=[self dataForKey:aKey];
    if (theData != nil)
        theColor=(NSColor *)[NSUnarchiver unarchiveObjectWithData:theData];
    return theColor;
}

@end
