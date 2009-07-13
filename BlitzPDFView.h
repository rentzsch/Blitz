#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class CounterView;

@interface BlitzPDFView : PDFView
{
	uint16_t secondsElapsed;
	CounterView *counterView;
}

@property uint16_t secondsElapsed;

- (void)atLastPage;
- (IBAction)updateSecondsElapsed:(id)sender;

@end
