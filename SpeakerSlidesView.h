//
//  SpeakerSlidesView.h
//  Blitz
//
//  Created by Timothy J. Wood on 9/20/09.
//  Copyright 2009 The Omni Group. All rights reserved.
//

#import <AppKit/NSView.h>
#import <Quartz/Quartz.h>

@interface SpeakerSlidePDFView : PDFView
@end

@interface SpeakerSlidesView : NSView
{
@private
    SpeakerSlidePDFView *_currentSlideView, *_nextSlideView;
    PDFDocument *_pdfDocument;
    NSUInteger _pageIndex;
}

@property(retain/*,setter=setPDFDocument:*/) PDFDocument *pdfDocument;
@property(assign) NSUInteger pageIndex;

@property(retain) IBOutlet PDFView *currentSlideView;
@property(retain) IBOutlet PDFView *nextSlideView;

@end
