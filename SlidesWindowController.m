//
//  SlidesWindowController.m
//  Blitz
//
//  Created by Timothy J. Wood on 9/20/09.
//  Copyright 2009 The Omni Group. All rights reserved.
//

#import "SlidesWindowController.h"

#import "BlitzPDFView.h"

@interface SlidesWindowController (/*Private*/)
@end

@implementation SlidesWindowController

@synthesize pdfView;

- (void)setDocument:(NSDocument *)document;
{
    [super setDocument:document];
    
    if (document) {
        [self window]; // make sure our nib is loaded
        [self.pdfView bind:@"document" toObject:document withKeyPath:@"pdfDocument" options:nil];
        [self.pdfView bind:@"secondsElapsed" toObject:document withKeyPath:@"secondsElapsed" options:nil];
        [self.pdfView bind:@"pageIndex" toObject:document withKeyPath:@"pageIndex" options:nil];
        [self.pdfView bind:@"running" toObject:document withKeyPath:@"running" options:nil];
    } else {
        [self.pdfView unbind:@"document"];
        [self.pdfView unbind:@"secondsElapsed"];
        [self.pdfView unbind:@"pageIndex"];
        [self.pdfView unbind:@"running"];
    }
}

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
    return [self.document fileURL];
    //return [NSURL fileURLWithPath:@"/Users/wolf/code/github/Blitz/blitz-example.pdf"];//[selectedDownloads objectAtIndex:index];
}


@end
