#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class BlitzPDFView;

@interface MyDocument : NSDocument 
{
	IBOutlet BlitzPDFView *pdfView;
	@private PDFDocument *pdfDocument;
	@private NSTimer *timer;
}

@property (retain, nonatomic) IBOutlet BlitzPDFView *pdfView;

@end
