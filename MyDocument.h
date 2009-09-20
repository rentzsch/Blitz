#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface MyDocument : NSDocument {
	@private PDFDocument *pdfDocument;
	@private NSTimer *timer;
    @private BOOL isInFullScreenMode;
    
    
    NSUInteger secondsElapsed;
    NSUInteger pageIndex;
    BOOL running;
}

@property (readwrite) NSUInteger pageIndex;
@property (readonly) BOOL running;

@end
