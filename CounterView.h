#import <Cocoa/Cocoa.h>

#define UpdateSecondsElapsed @"UpdateSecondsElapsed"
#define kCounterViewRingForeground @"CounterViewRingForeground"
#define kCounterViewRingBackground @"CounterViewRingBackground"
#define kCounterViewWedgeForeground @"CounterViewWedgeForeground"
#define kCounterViewWedgeBackground @"CounterViewWedgeBackground"

@interface CounterView : NSView {
	NSTimeInterval secondsElapsed;
    NSColor *ringForeground;
    NSColor *ringBackground;
    NSColor *wedgeForeground;
    NSColor *wedgeBackground;
}
@property NSTimeInterval secondsElapsed;
@property (retain) NSColor *ringForeground;
@property (retain) NSColor *ringBackground;
@property (retain) NSColor *wedgeForeground;
@property (retain) NSColor *wedgeBackground;
@end
