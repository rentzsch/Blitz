#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class BlitzPDFView;

@interface MyDocument : NSDocument {}
@property (retain, nonatomic) IBOutlet BlitzPDFView *pdfView;
@end
