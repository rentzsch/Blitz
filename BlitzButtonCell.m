//
//  BlitzButton.m
//  Blitz
//
//  Created by Timothy J. Wood on 9/20/09.
//  Copyright 2009 The Omni Group. All rights reserved.
//

#import "BlitzButtonCell.h"

static void OSAppendRoundedRect(CGContextRef ctx, NSRect rect, CGFloat radius)
{
    NSPoint topMid      = NSMakePoint(NSMidX(rect), NSMaxY(rect));
    NSPoint topLeft     = NSMakePoint(NSMinX(rect), NSMaxY(rect));
    NSPoint topRight    = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
    NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
    
    CGContextMoveToPoint(ctx, topMid.x, topMid.y);
    CGContextAddArcToPoint(ctx, topLeft.x, topLeft.y, rect.origin.x, rect.origin.y, radius);
    CGContextAddArcToPoint(ctx, rect.origin.x, rect.origin.y, bottomRight.x, bottomRight.y, radius);
    CGContextAddArcToPoint(ctx, bottomRight.x, bottomRight.y, topRight.x, topRight.y, radius);
    CGContextAddArcToPoint(ctx, topRight.x, topRight.y, topLeft.x, topLeft.y, radius);
    CGContextClosePath(ctx);
}

@implementation BlitzButtonCell

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView*)controlView;
{    
    // White with a blue shadow to try to show up on white or black slides, and we have a black background in the slide preview area that this overlays.
    [NSGraphicsContext saveGraphicsState];
    {
        BOOL pressed = [self isHighlighted];
        
        [[NSColor colorWithCalibratedWhite:1.0f alpha:(pressed ? 0.80f : 0.6f)] set];
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        
        [shadow setShadowBlurRadius:(pressed ? 3.0f : 6.0f)];
        
        [shadow setShadowOffset:NSZeroSize];
        [shadow setShadowColor:[NSColor blueColor]];
        [shadow set];

        NSRect bezelFrame = NSInsetRect(frame, 3, 3);
        CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
        OSAppendRoundedRect(ctx, bezelFrame, NSHeight(bezelFrame)/2.0);
        CGContextFillPath(ctx);
    }
    [NSGraphicsContext restoreGraphicsState];
}

@end
