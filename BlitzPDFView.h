#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface BlitzPDFView : PDFView
@property uint16_t secondsElapsed;

- (IBAction)updateSecondsElapsed:(id)sender;

@end
