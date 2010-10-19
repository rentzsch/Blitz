#import <Cocoa/Cocoa.h>

#define UpdateSecondsElapsed @"UpdateSecondsElapsed"
#define kCounterViewRingForeground @"CounterViewRingForeground"
#define kCounterViewRingBackground @"CounterViewRingBackground"
#define kCounterViewWedgeForeground @"CounterViewWedgeForeground"
#define kCounterViewWedgeBackground @"CounterViewWedgeBackground"

@interface CounterView : NSView {
	uint16_t secondsElapsed;
    NSColor *ringForeground;
    NSColor *ringBackground;
    NSColor *wedgeForeground;
    NSColor *wedgeBackground;
}
@property uint16_t secondsElapsed;
@property (retain) NSColor *ringForeground;
@property (retain) NSColor *ringBackground;
@property (retain) NSColor *wedgeForeground;
@property (retain) NSColor *wedgeBackground;
@end
