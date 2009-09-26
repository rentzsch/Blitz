//
//  SpeakerSlidesView.m
//  Blitz
//
//  Created by Timothy J. Wood on 9/20/09.
//  Copyright 2009 The Omni Group. All rights reserved.
//

#import "SpeakerSlidesView.h"

#import <Quartz/Quartz.h>

@implementation SpeakerSlidePDFView

- (void)drawPagePost:(PDFPage *)page;
{
    // Draw a border around the page so that if it has black edges it doesn't fade into the black background.
    [[NSColor colorWithCalibratedHue:215.0f/360.0f saturation:0.75f brightness:0.75f alpha:1.0f] set];
    NSFrameRect([self bounds]);
}

@end

@interface SpeakerSlidesView (/*Private*/)
- (id)_speakerSlidesViewInit;
- (void)_layoutSlides;
- (void)_updatePages;
@end

@implementation SpeakerSlidesView

- initWithFrame:(NSRect)frame;
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    return [self _speakerSlidesViewInit];
}

- initWithCoder:(NSCoder *)coder;
{
    if (!(self = [super initWithCoder:coder]))
        return nil;
    return [self _speakerSlidesViewInit];
}

- (id)_speakerSlidesViewInit;
{
    // Nothing, oops.
    return self;
}

- (void)awakeFromNib;
{
    [self _layoutSlides];
    [_currentSlideView setBackgroundColor:[NSColor blackColor]];
    [_nextSlideView setBackgroundColor:[NSColor blackColor]];
}

- (void)dealloc;
{
    [_pdfDocument release];
    [_currentSlideView release];
    [_nextSlideView release];
    [counterView release];
    [super dealloc];
}

- (uint16_t) secondsElapsed {
    return secondsElapsed;
}

- (void)setSecondsElapsed:(uint16_t)secs {
    secondsElapsed = secs;
    counterView.secondsElapsed = secs;
    [counterView setNeedsDisplay:YES];
}

- (BOOL)running;
{
    return ([counterView superview] == self);
}
- (void)setRunning:(BOOL)running;
{
    BOOL wasRunning = (counterView != nil);
    
    if (running == wasRunning)
        return;
    
    if (running) {
        const CGFloat kSize = 80.0f;
        const CGFloat kPadding = 20.0f;
        
        NSRect frame = NSMakeRect([self bounds].size.width / 2.0 - kPadding - kSize, kPadding, kSize, kSize);
        counterView = [[CounterView alloc] initWithFrame:frame];
        
        [self addSubview: counterView];
        [counterView setNeedsDisplay: YES];
        
        [self addSubview:counterView];
    } else {
        [[counterView animator] removeFromSuperview];
        [counterView release];
        counterView = nil;
    }
}

- (IBAction)updateSecondsElapsed:(id)sender {
    self.secondsElapsed = [sender intValue];
    [self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark NSView subclass

- (BOOL)isOpaque
{
    return YES;
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize;
{
    [super resizeSubviewsWithOldSize:oldSize];
    [self _layoutSlides];
}

- (void)drawRect:(NSRect)rect;
{    
    [[NSColor blackColor] set];
    NSRectFill(self.bounds);
}

#pragma mark -
#pragma mark KVC

@synthesize currentSlideView = _currentSlideView;
@synthesize nextSlideView = _nextSlideView;

@synthesize pageIndex = _pageIndex;
- (void)setPageIndex:(NSUInteger)pageIndex;
{
    if (_pageIndex == pageIndex)
        return;
    _pageIndex = pageIndex;
    [self _updatePages];
}

@synthesize pdfDocument = _pdfDocument;
- (void)setPdfDocument:(PDFDocument *)pdfDocument;
{
    if (_pdfDocument == pdfDocument)
        return;
    
    [_pdfDocument release];
    _pdfDocument = [pdfDocument retain];

    [_currentSlideView setDocument:_pdfDocument];
    [_nextSlideView setDocument:_pdfDocument];
    [self _updatePages];
}

#pragma mark -
#pragma mark Private

- (void)_updatePages;
{
    NSUInteger pageCount = [_pdfDocument pageCount];
    PDFPage *page;
    
    page = (_pageIndex < pageCount) ? [_pdfDocument pageAtIndex:_pageIndex] : nil;
    [_currentSlideView goToPage:page];
    
    page = (_pageIndex + 1 < pageCount) ? [_pdfDocument pageAtIndex:_pageIndex + 1] : nil;
    [_nextSlideView goToPage:page];
}

- (void)_layoutSlides;
{
    NSRect bounds = self.bounds;
    NSRect leftSlideRect, rightSlideRect;
    NSDivideRect(bounds, &leftSlideRect, &rightSlideRect, bounds.size.width / 2, NSMinXEdge);
    leftSlideRect = NSIntegralRect(NSInsetRect(leftSlideRect, 16, 16));
    rightSlideRect = NSIntegralRect(NSInsetRect(rightSlideRect, 16, 16));
    
    [_currentSlideView setFrame:leftSlideRect];
    [_nextSlideView setFrame:rightSlideRect];
}

@end
