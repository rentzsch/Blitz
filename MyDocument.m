#import "MyDocument.h"
#import "BlitzPDFView.h"

@interface MyDocument ()
@property (retain, nonatomic) PDFDocument *pdfDocument;
@property (retain, nonatomic) NSTimer *timer;
@end

@implementation MyDocument
@synthesize pdfDocument, pdfView, timer;

- (void)windowControllerDidLoadNib:(NSWindowController*)controller_ {
    [super windowControllerDidLoadNib:controller_];
    
    if (!self.pdfDocument) {
        self.pdfDocument = [[PDFDocument alloc] init];
    }
    [self.pdfView setDocument:self.pdfDocument];
    
    self.pdfView.secondsElapsed = 0;
    self.timer = [[NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(updateElapsedTimer:)
                                            userInfo:nil
                                             repeats:YES] retain];
}

- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
    //return [self.pdfDocument writeToURL:absoluteURL];
    [self doesNotRecognizeSelector:_cmd]; // Renounce writing the PDF to disk.
    return NO;
}

- (BOOL)readFromURL:(NSURL *)initWithURL ofType:(NSString *)typeName error:(NSError **)outError {
    self.pdfDocument = [[PDFDocument alloc] initWithURL:initWithURL];
    return self.pdfDocument ? YES : NO;
}

- (void)updateElapsedTimer:(NSTimer*)timer_ {
    if (self.pdfView.secondsElapsed != 0 && (self.pdfView.secondsElapsed % 15 == 0)) {
        [self.pdfView goToNextPage:nil];
    }
    self.pdfView.secondsElapsed += 1;
    [self.pdfView setNeedsDisplay:YES];
}

//--

- (NSString *)windowNibName {
    return @"MyDocument";
}

- (void)dealloc {
    self.pdfDocument = nil;
    [self.timer invalidate];
    self.timer = nil;
    [super dealloc];
}

@end
