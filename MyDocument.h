#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class BlitzPDFView;

#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5
@interface MyDocument : NSDocument <QLPreviewPanelDataSource, QLPreviewPanelDelegate> {
#else
@interface MyDocument : NSDocument {
#endif
	IBOutlet BlitzPDFView *pdfView;
	@private PDFDocument *pdfDocument;
	@private NSTimer *timer;
    @private BOOL isInFullScreenMode;
    
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5
    QLPreviewPanel *previewPanel;
#endif
    
    NSUInteger pageIndex;
}

@property (retain, nonatomic) IBOutlet BlitzPDFView *pdfView;
@property (readwrite) NSUInteger pageIndex;

@end
