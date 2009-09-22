#import "MyDocument.h"

#import "SlidesWindowController.h"
#import "SpeakerNotesWindowController.h"
#import "BlitzPDFView.h"

@interface NSObject (UndocumentedQuickLookUI)
- (id)_previewView; // -[QLPreviewPanelController _previewView]
- (id)displayBundle; // -[QLDisplayBundle displayBundle];
- (PDFDocument*)pdfDocument; // -[QLDisplayBundle pdfDocument]
@end

@interface MyDocument ()
@property (retain, nonatomic) PDFDocument *pdfDocument;
@property (retain, nonatomic) NSTimer *timer;
@property (nonatomic) BOOL isInFullScreenMode;
@property(assign) NSUInteger secondsElapsed;
@property(assign,readwrite) BOOL running;
@end

@implementation MyDocument
@synthesize pdfDocument, timer, isInFullScreenMode, secondsElapsed, running;
@synthesize pageIndex;

- (void)toggleFullScreenMode {
    SlidesWindowController *slides = [self.windowControllers objectAtIndex:0];
    SpeakerNotesWindowController *notes = [self.windowControllers objectAtIndex:1];

    NSView *slidesView = slides.pdfView;
    NSView *notesView = notes.window.contentView;

    if (self.isInFullScreenMode) {
        [slidesView exitFullScreenModeWithOptions:nil];
        [notesView exitFullScreenModeWithOptions:nil];
        self.isInFullScreenMode = NO;
    } else {
        // Notes are on the MacBook Pro main screen at 1920x1200, slides are on the projector at 1280x720.
        // For now, assuming that we don't need to change display resolutions and that these will be the only two displays and that the main screen will be the one for the notes.
        NSScreen *notesScreen = [NSScreen mainScreen];
        NSScreen *slidesScreen = nil;
        for (NSScreen *screen in [NSScreen screens]) {
            if (screen != notesScreen) {
                slidesScreen = screen;
                break;
            }
        }

        if (!notesScreen || !slidesScreen) {
            NSInteger rc = NSRunAlertPanel(@"Missing a screen", @"Unable to find both a note and slide screen", @"Cancel", @"Run Slides", nil);
            if (rc == NSAlertDefaultReturn)
                return;
            slidesScreen = [NSScreen mainScreen];
            notesScreen = nil;
        }
        
        if (notesScreen) {
            NSLog(@"notes %@ on %@ %@", notes, notesScreen, NSStringFromRect([notesScreen frame]));
            [notesView enterFullScreenMode:notesScreen withOptions:nil];
        }
        NSLog(@"slides %@ on %@ %@", slides, slidesScreen, NSStringFromRect([slidesScreen frame]));
        [slidesView enterFullScreenMode:slidesScreen withOptions:nil];
        
        [NSCursor setHiddenUntilMouseMoves:YES];
        
        self.isInFullScreenMode = YES;
    }
}

- (void)initPDFView {
    self.isInFullScreenMode = NO;
    [self toggleFullScreenMode];
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
    
    //[pdfDisplayBundlePDFDocument writeToFile:@"/tmp/key.pdf"];
    
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
    // Note: Could check typename here, but sometimes it comes back com.adobe.pdf
    self.pdfDocument = [[PDFDocument alloc] initWithURL:initWithURL];
    return self.pdfDocument ? YES : NO;
#endif
}

- (void)updateElapsedTimer:(NSTimer*)timer_ {
    if (self.secondsElapsed != 0 && (self.secondsElapsed % SECONDS_PER_SLIDE == 0)) {
        // Triggers page change in associated speaker notes window controller
        self.pageIndex++;
        if (self.pageIndex >= pdfDocument.pageCount) {
            self.running = NO;
            [timer_ invalidate];
        }
    }
    
    self.secondsElapsed += 1;
}

- (void)makeWindowControllers;
{
    // Slides
    {
        SlidesWindowController *slides = [[SlidesWindowController alloc] initWithWindowNibName:@"Slides"];
        [self addWindowController:slides];
        [slides release];
    }
    
    // Extract the notes from the Keynote file, converting to HTML. Duct tape and bailing wire.
    {
        NSURL *fileURL = [self fileURL];
        NSString *filePath = [fileURL path];
        
        // If opening the .pdf file, open adjacent .key file instead
        if ([[filePath pathExtension] isEqual:@"pdf"])
        {
            filePath = [[filePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"key"];
        }
        
        NSString *xslPath = [[NSBundle mainBundle] pathForResource:@"presenter-notes" ofType:@"xsl"];
        // CDATA wrapping that xsltproc adds seems to mess up the Javascript, so remove it.
        NSString *command = [NSString stringWithFormat:@"/usr/bin/unzip -p '%s' index.apxl | xsltproc '%s' - | sed -e 's/<!\\[CDATA\\[//' -e 's/]]>//'",
                             [[NSFileManager defaultManager] fileSystemRepresentationWithPath:filePath],
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

- (void)dealloc {
    self.pdfDocument = nil;
    [self.timer invalidate];
    self.timer = nil;
    [super dealloc];
}

- (IBAction)start:(id)sender;
{
    self.running = YES;
    self.secondsElapsed = 0.0;
    self.timer = [[NSTimer scheduledTimerWithTimeInterval:1.0
                                                   target:self
                                                 selector:@selector(updateElapsedTimer:)
                                                 userInfo:nil
                                                  repeats:YES] retain];
}

@end
