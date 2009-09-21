#import "MyDocument.h"
#import "BlitzPDFView.h"
#import "SpeakerNotesWindowController.h"

@interface NSObject (UndocumentedQuickLookUI)
- (id)_previewView; // -[QLPreviewPanelController _previewView]
- (id)displayBundle; // -[QLDisplayBundle displayBundle];
- (PDFDocument*)pdfDocument; // -[QLDisplayBundle pdfDocument]
@end

@interface MyDocument ()
@property (retain, nonatomic) PDFDocument *pdfDocument;
@property (retain, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL isInFullScreenMode;
@end

@implementation MyDocument
@synthesize pdfView, pdfDocument, timer, isInFullScreenMode;
@synthesize pageIndex;

- (void)toggleFullScreenMode {
	if (self.isInFullScreenMode) {
		[self.pdfView exitFullScreenModeWithOptions: nil];
		self.isInFullScreenMode = NO;
	}
	else {
        // TODO
		//NSWindow *window = [[[self windowControllers] objectAtIndex:0] window];
		//self.isInFullScreenMode = [self.pdfView enterFullScreenMode: window.screen withOptions: nil];
	}
}

- (void)initPDFView {
    [self.pdfView setDocument:self.pdfDocument];
    
    self.pdfView.secondsElapsed = 0;
    self.timer = [[NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(updateElapsedTimer:)
                                                 userInfo:nil
                                                  repeats:YES] retain];
    self.isInFullScreenMode = NO;
    [self toggleFullScreenMode];
}

- (void)windowControllerDidLoadNib:(NSWindowController*)controller_ {
    [super windowControllerDidLoadNib:controller_];
    if (self.pdfDocument) {
        [self initPDFView];
    }
}

- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
    //return [self.pdfDocument writeToURL:absoluteURL];
    [self doesNotRecognizeSelector:_cmd]; // Renounce writing the PDF to disk.
    return NO;
}

#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5
- (void)pollPDFPageCount:(NSTimer*)timer_ {
    id myQLPreviewPanelController = [[QLPreviewPanel sharedPreviewPanel] windowController];
    //NSLog(@"myQLPreviewPanelController: %@", myQLPreviewPanelController);
    
    id myQLPreviewView = [myQLPreviewPanelController _previewView];
    //NSLog(@"myQLPreviewView: %@", myQLPreviewView);
    
    id myQLDisplayBundle = [myQLPreviewView displayBundle];
    //NSLog(@"myQLDisplayBundle: %@", myQLDisplayBundle);
    
    PDFDocument *pdfDisplayBundlePDFDocument = [myQLDisplayBundle pdfDocument];
    
    [pdfDisplayBundlePDFDocument writeToFile:@"/tmp/key.pdf"];
    
    //NSLog(@"pdfDisplayBundlePDFDocument: %@", pdfDisplayBundlePDFDocument);
    
    NSLog(@"pageCount: %d", [pdfDisplayBundlePDFDocument pageCount]);
    if ([pdfDisplayBundlePDFDocument pageCount] >= 20) {
        [timer_ invalidate];
        self.pdfDocument = pdfDisplayBundlePDFDocument;
        [self initPDFView];
        [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
    }
}
#endif

- (BOOL)readFromURL:(NSURL *)initWithURL ofType:(NSString *)typeName error:(NSError **)outError {
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5
    if ([typeName isEqualToString:@"PDFDocument"]) {
        self.pdfDocument = [[PDFDocument alloc] initWithURL:initWithURL];
        return self.pdfDocument ? YES : NO;
    }
    else if ([typeName isEqualToString:@"KeynoteDocument"]) {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
        // Poor man's window-hiding since we can't immediately orderOut the panel (crashes):
        [[QLPreviewPanel sharedPreviewPanel] setFrameTopLeftPoint:NSMakePoint(-5000, -5000)];
        
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(pollPDFPageCount:)
                                       userInfo:nil
                                        repeats:YES];
        
        return YES;
    } 
    else {
        return NO;
    }
#else
    self.pdfDocument = [[PDFDocument alloc] initWithURL:initWithURL];
    return self.pdfDocument ? YES : NO;
#endif
}

- (void)updateElapsedTimer:(NSTimer*)timer_ {
    if (self.pdfView.secondsElapsed != 0 && (self.pdfView.secondsElapsed % SECONDS_PER_SLIDE == 0)) {
        if ([self.pdfView canGoToNextPage]) {
            [self.pdfView goToNextPage:nil];
            
            // Triggers page change in associated speaker notes window controller
            self.pageIndex = [[self.pdfView document] indexForPage:self.pdfView.currentPage];
        }
        else {
            [self.pdfView atLastPage];
            [timer_ invalidate];
        }
    }
    self.pdfView.secondsElapsed += 1;
    [self.pdfView setNeedsDisplay:YES];
}

//--

#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5
- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
    previewPanel = [panel retain];
    panel.delegate = self;
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel {
    [previewPanel release];
    previewPanel = nil;
}

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel*)panel {
    return 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    return [self fileURL];
    //return [NSURL fileURLWithPath:@"/Users/wolf/code/github/Blitz/blitz-example.pdf"];//[selectedDownloads objectAtIndex:index];
}
#endif

//--

- (void)makeWindowControllers;
{
    [super makeWindowControllers];
    
    
    // Extract the notes from the Keynote file, converting to HTML. Duct tape and bailing wire.
    {
        NSURL *fileURL = [self fileURL];
        
        NSString *xslPath = [[NSBundle mainBundle] pathForResource:@"presenter-notes" ofType:@"xsl"];
        NSString *command = [NSString stringWithFormat:@"/usr/bin/unzip -p '%s' index.apxl | xsltproc '%s' -",
                             [[NSFileManager defaultManager] fileSystemRepresentationWithPath:[fileURL path]],
                             [[NSFileManager defaultManager] fileSystemRepresentationWithPath:xslPath]];
        NSTask *task = [[[NSTask alloc] init] autorelease];
        
        NSPipe *pipe = [NSPipe pipe];
        [task setLaunchPath:@"/bin/sh"];
        [task setArguments:[NSArray arrayWithObjects:@"-c", command, nil]];
        [task setStandardInput:[NSFileHandle fileHandleWithNullDevice]];
        [task setStandardOutput:[pipe fileHandleForWriting]];
        
        [task launch];
        
        [[pipe fileHandleForWriting] closeFile]; // have to close our copy of the writing endpoint or we won't get EOF when reading.
        NSData *htmlData = [[pipe fileHandleForReading] readDataToEndOfFile];
        
        [task waitUntilExit];
        
        //NSLog(@"html = %@", [[[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding] autorelease]);
        
        SpeakerNotesWindowController *speakerNotes = [[SpeakerNotesWindowController alloc] initWithHTMLData:htmlData];
        [self addWindowController:speakerNotes];
        
        // Don't -showWindow: since that'll make us key; the main window needs to stay key so that the QuickLook hack will work.
        [[speakerNotes window] orderBack:nil];
        [speakerNotes release];
    }
}

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
