//
//  SlidesWindowController.h
//  Blitz
//
//  Created by Timothy J. Wood on 9/20/09.
//  Copyright 2009 The Omni Group. All rights reserved.
//

#import <AppKit/NSWindowController.h>
#import <Quartz/Quartz.h>

@class BlitzPDFView;

#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5
@interface SlidesWindowController : NSWindowController <QLPreviewPanelDataSource, QLPreviewPanelDelegate>
#else
@interface SlidesWindowController : NSWindowController
#endif
{
    IBOutlet BlitzPDFView *pdfView;
#if MAC_OS_X_VERSION_MIN_REQUIRED > MAC_OS_X_VERSION_10_5
    QLPreviewPanel *previewPanel;
#endif
}

@property (retain, nonatomic) IBOutlet BlitzPDFView *pdfView;

@end
