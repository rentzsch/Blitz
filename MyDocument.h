#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface MyDocument : NSDocument {
	@private PDFDocument *pdfDocument;
	@private NSTimer *timer;
    @private BOOL isInFullScreenMode;
    
    
    NSTimeInterval secondsElapsed;
    NSUInteger pageIndex;
    BOOL running;
}

@property (readwrite) NSUInteger pageIndex;
@property (readonly) BOOL running;

- (IBAction)start:(id)sender;

@end
