#import <Cocoa/Cocoa.h>

#define UpdateSecondsElapsed @"UpdateSecondsElapsed"

@interface CounterView : NSView {
	uint16_t secondsElapsed;
}
@property uint16_t secondsElapsed;

@end
