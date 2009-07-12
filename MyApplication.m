#import "MyApplication.h"

@implementation MyApplication

- (void)sendEvent:(NSEvent*)theEvent {
	// Eat all the scrollWheel events, we don't want the PDFView to scroll
	if (theEvent.type != NSScrollWheel)
		[super sendEvent:theEvent];
}

@end
