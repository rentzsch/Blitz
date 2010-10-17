#import <Cocoa/Cocoa.h>

#define UpdateSecondsElapsed @"UpdateSecondsElapsed"
#define kCounterViewRingForeground @"CounterViewRingForeground"
#define kCounterViewRingBackground @"CounterViewRingBackground"
#define kCounterViewWedgeForeground @"CounterViewWedgeForeground"
#define kCounterViewWedgeBackground @"CounterViewWedgeBackground"

@interface CounterView : NSView {
	uint16_t secondsElapsed;
}
@property uint16_t secondsElapsed;

@end
