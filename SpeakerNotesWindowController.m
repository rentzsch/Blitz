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
    
    _pageIndex = (NSUInteger)-1;
    _htmlData = [htmlData copy];
    return self;
}

@synthesize webView = _webView;
@synthesize slidesView = _slidesView;

- (void)dealloc;
{
    [_webView release];
    [_slidesView release];
    [_htmlData release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSWindowController subclass

- (void)windowDidLoad;
{
    [super windowDidLoad];
    
    self.pageIndex = 0; // set the first media style and load the results
}

- (void)setDocument:(NSDocument *)document;
{
    [super setDocument:document];
    
    if (document) {
        [self window]; // make sure we have a _slidesView...
        
        [self bind:@"pageIndex" toObject:document withKeyPath:@"pageIndex" options:nil];
        [_slidesView bind:@"pdfDocument" toObject:document withKeyPath:@"pdfDocument" options:nil];
        [_slidesView bind:@"pageIndex" toObject:document withKeyPath:@"pageIndex" options:nil];
    } else {
        [self unbind:@"pageIndex"];
        [_slidesView unbind:@"pdfDocument"];
        [_slidesView unbind:@"pageIndex"];
    }
}

#pragma mark -
#pragma mark KVC

@synthesize pageIndex = _pageIndex;
- (void)setPageIndex:(NSUInteger)pageIndex;
{
    _pageIndex = pageIndex;
    //NSLog(@"speaker pageIndex = %lu", pageIndex);
    
    // Horrifying but easy!
    NSString *mediaStyle = [NSString stringWithFormat:@"mBGSlide%lu", _pageIndex];
    [_webView setMediaStyle:mediaStyle];
    [[_webView mainFrame] loadData:_htmlData MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:nil];
}

@end
