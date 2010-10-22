#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "CounterView.h"

@class CounterView;

@interface BlitzPDFView : PDFView {
	NSTimeInterval secondsElapsed;
	IBOutlet CounterView *counterView;
}
@property NSTimeInterval secondsElapsed;
@property(assign) NSUInteger pageIndex;
@property(assign) BOOL running;

- (IBAction)updateSecondsElapsed:(id)sender;

@end