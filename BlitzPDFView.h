#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class CounterView;

@interface BlitzPDFView : PDFView {
	uint16_t secondsElapsed;
	CounterView *counterView;
}
@property uint16_t secondsElapsed;
@property(assign) NSUInteger pageIndex;
@property(assign) BOOL running;

- (IBAction)updateSecondsElapsed:(id)sender;

@end