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

@interface SlidesWindowController : NSWindowController <QLPreviewPanelDataSource, QLPreviewPanelDelegate>
{
    IBOutlet BlitzPDFView *pdfView;
    QLPreviewPanel *previewPanel;
}

@property (retain, nonatomic) IBOutlet BlitzPDFView *pdfView;

@end
