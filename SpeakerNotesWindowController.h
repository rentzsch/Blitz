//
//  SpeakerNotesWindowController.h
//  Blitz
//
//  Created by Timothy J. Wood on 9/19/09.
//  Copyright 2009 The Omni Group. All rights reserved.
//

#import <AppKit/NSWindowController.h>

@class PDFDocument;
@class WebView;
@class SpeakerSlidesView;

@interface SpeakerNotesWindowController : NSWindowController
{
@private
    WebView *_webView;
    NSData *_htmlData;
    NSUInteger _pageIndex;
    SpeakerSlidesView *_slidesView;
}

- initWithHTMLData:(NSData *)htmlData;

@property(retain) IBOutlet WebView *webView;
@property(retain) IBOutlet SpeakerSlidesView *slidesView;
@property(readwrite, setter=setPageIndex:) NSUInteger pageIndex;

- (void)changeFont:(id)sender;
- (void)setPageIndex:(NSUInteger)pageIndex;

@end
