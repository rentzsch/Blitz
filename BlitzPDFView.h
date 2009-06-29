#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface BlitzPDFView : PDFView
{
	uint16_t secondsElapsed;
}

@property uint16_t secondsElapsed;

- (IBAction)updateSecondsElapsed:(id)sender;

@end
