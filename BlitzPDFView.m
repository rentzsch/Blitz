#import "BlitzPDFView.h"

@implementation BlitzPDFView
@dynamic secondsElapsed;

- (void)drawPagePost:(PDFPage*)page {
}

- (void)dealloc {
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
    BOOL wasRunning = ![counterView isHidden];
    
    if (running == wasRunning)
        return;
    
    if (running) {
        [[counterView animator] setHidden:NO];

        [counterView setNeedsDisplay: YES];
    } else {
        [[counterView animator] setHidden:YES];
    }
}

- (IBAction)updateSecondsElapsed:(id)sender {
    self.secondsElapsed = [sender intValue];
    [self setNeedsDisplay:YES];
}

- (NSUInteger)pageIndex;
{
    if (!self.document)
        return NSNotFound;
    return [self.document indexForPage:self.currentPage];
}
- (void)setPageIndex:(NSUInteger)pageIndex;
{
    NSUInteger pageCount = [self.document pageCount];
    PDFPage *page = nil;
    if (pageCount > 0) {
        if (pageIndex >= pageCount)
            pageIndex = pageCount - 1;
        page = [self.document pageAtIndex:pageIndex];
    }
    
    [self goToPage:page];
}

@end