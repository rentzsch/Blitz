//
//  SpeakerNotesWindowController.h
//  Blitz
//
//  Created by Timothy J. Wood on 9/19/09.
//  Copyright 2009 The Omni Group. All rights reserved.
//

#import <AppKit/NSWindowController.h>

@class WebView;

@interface SpeakerNotesWindowController : NSWindowController
{
@private
    WebView *_webView;
    NSData *_htmlData;
    NSUInteger _pageIndex;
}

- initWithHTMLData:(NSData *)htmlData;

@property(retain) IBOutlet WebView *webView;
@property(readwrite) NSUInteger pageIndex;

@end
