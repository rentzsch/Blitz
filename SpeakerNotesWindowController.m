//
//  SpeakerNotesWindowController.m
//  Blitz
//
//  Created by Timothy J. Wood on 9/19/09.
//  Copyright 2009 The Omni Group. All rights reserved.
//

#import "SpeakerNotesWindowController.h"

#import <WebKit/WebKit.h>

@implementation SpeakerNotesWindowController

- initWithHTMLData:(NSData *)htmlData;
{
    if (!(self = [super initWithWindowNibName:@"SpeakerNotes"]))
        return nil;
    
    _htmlData = [htmlData copy];
    return self;
}

@synthesize webView = _webView;

- (void)dealloc;
{
    [_webView release];
    [_htmlData release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSWindowController subclass

- (void)windowDidLoad;
{
    [[_webView mainFrame] loadData:_htmlData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
}

- (void)setDocument:(NSDocument *)document;
{
    [super setDocument:document];
    
    if (document) {
        [self bind:@"pageIndex" toObject:document withKeyPath:@"pageIndex" options:nil];
    } else {
        [self unbind:@"pageIndex"];
    }
}

#pragma mark -
#pragma mark KVC

@synthesize pageIndex = _pageIndex;
- (void)setPageIndex:(NSUInteger)pageIndex;
{
    _pageIndex = pageIndex;
    //NSLog(@"speaker pageIndex = %lu", pageIndex);
}

@end
