#import "CounterView.h"
#import "NSUserDefaults+ColorSupport.h"

@implementation CounterView
@synthesize secondsElapsed;
@synthesize ringForeground;
@synthesize ringBackground;
@synthesize wedgeForeground;
@synthesize wedgeBackground;

- (void) updateSecondsElapsed:(NSNotification*) note {
    NSNumber* secondsElapsedValue = [[note userInfo] valueForKey:@"secondsElapsed"];
    self.secondsElapsed = [secondsElapsedValue doubleValue];
    [self setNeedsDisplay:YES];
}

- (void) awakeFromNib {
    NSUserDefaultsController *userDefaultsController = [NSUserDefaultsController sharedUserDefaultsController];
    NSDictionary *bindingOptions = [NSDictionary dictionaryWithObject:NSUnarchiveFromDataTransformerName
                                                               forKey:NSValueTransformerNameBindingOption];

    [self     bind:@"ringForeground"
          toObject:userDefaultsController
       withKeyPath:@"values.CounterViewRingForeground"
           options:bindingOptions];

    [userDefaultsController addObserver:self
                             forKeyPath:@"values.CounterViewRingForeground"
                                options:0
                                context:nil];

    [self     bind:@"ringBackground"
          toObject:userDefaultsController
       withKeyPath:@"values.CounterViewRingBackground"
           options:bindingOptions];

    [userDefaultsController addObserver:self
                             forKeyPath:@"values.CounterViewRingBackground"
                                options:0
                                context:nil];

    [self     bind:@"wedgeForeground"
          toObject:userDefaultsController
       withKeyPath:@"values.CounterViewWedgeForeground"
           options:bindingOptions];

    [userDefaultsController addObserver:self
                             forKeyPath:@"values.CounterViewWedgeForeground"
                                options:0
                                context:nil];

    [self     bind:@"wedgeBackground"
          toObject:userDefaultsController
       withKeyPath:@"values.CounterViewWedgeBackground"
           options:bindingOptions];

    [userDefaultsController addObserver:self
                             forKeyPath:@"values.CounterViewWedgeBackground"
                                options:0
                                context:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSecondsElapsed:)
                                                 name:UpdateSecondsElapsed
                                               object:nil];
}

- (void) dealloc {
    NSUserDefaultsController *userDefaultsController = [NSUserDefaultsController sharedUserDefaultsController];
    [userDefaultsController removeObserver:self
                                forKeyPath:@"values.CounterViewRingForeground"];
    [userDefaultsController removeObserver:self
                                forKeyPath:@"values.CounterViewRingBackground"];
    [userDefaultsController removeObserver:self
                                forKeyPath:@"values.CounterViewWedgeForeground"];
    [userDefaultsController removeObserver:self
                                forKeyPath:@"values.CounterViewWedgeBackground"];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#define threeOclock		0.0f
#define twelveOclock	90.0f
#define nineOclock		180.0f
#define sixOclock		270.0f

- (void)drawRect:(NSRect)rect {
    [[NSColor clearColor] set];
    NSRectFill([self frame]);

    const CGFloat kOuterRingWidth = 8.0f;
    
    NSColor *outerSlideElapsedWedgeColor = [[ringForeground retain] autorelease];
    
    NSRect bounds = [self bounds];
    NSPoint center = NSMakePoint(NSMidX(bounds), NSMidY(bounds));
    
    bounds = NSInsetRect(bounds, 6.0, 6.0);
    
    {
        NSBezierPath *outerSlideRingBackground = [NSBezierPath bezierPathWithOvalInRect:bounds];
        
        NSShadow *shadow = [[[NSShadow alloc] init] autorelease];
        [shadow setShadowBlurRadius:6.0];
        [shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.50]];
        [shadow setShadowOffset:NSMakeSize(2.0, -2.0)];
        [shadow set];
        
        [self.ringBackground set];
        [outerSlideRingBackground fill];
        
        shadow = [[[NSShadow alloc] init] autorelease];
        [shadow set];
    }
    
    CGFloat degreesElapsed;
    {
        NSBezierPath *outerSlideElapsedWedge = [NSBezierPath bezierPath];
        [outerSlideElapsedWedge moveToPoint:center];
        
        float slideSeconds = fmod(self.secondsElapsed, SECONDS_PER_SLIDE);
        if (slideSeconds < 0.0001f) {
            if (self.secondsElapsed == 0) {
                degreesElapsed = 0;
            } else {
                degreesElapsed = 360;
            }
        } else {
            degreesElapsed = (slideSeconds * 360.0f) / SECONDS_PER_SLIDE;
        }
        
        [outerSlideElapsedWedge appendBezierPathWithArcWithCenter:center
                                                           radius:bounds.size.width / 2.0f
                                                       startAngle:twelveOclock-degreesElapsed
                                                         endAngle:twelveOclock];
        [outerSlideElapsedWedge lineToPoint:center];
        [outerSlideElapsedWedge closePath];
        
        [outerSlideElapsedWedgeColor set];
        [outerSlideElapsedWedge fill];
    }
    
    NSRect innerCircleBounds = NSInsetRect(bounds, kOuterRingWidth, kOuterRingWidth);
    {
        NSBezierPath *innerTalkCircleBackground = [NSBezierPath bezierPathWithOvalInRect:innerCircleBounds];
        
        [self.wedgeBackground set];
        [innerTalkCircleBackground fill];
    }
    
    {
        NSBezierPath *innerTalkElapsedWedge = [NSBezierPath bezierPath];
        [innerTalkElapsedWedge moveToPoint:center];
        
        CGFloat degreesElapsed = ((CGFloat)self.secondsElapsed * 360.0f) / (SECONDS_PER_SLIDE * NUMBER_OF_SLIDES);
        [innerTalkElapsedWedge appendBezierPathWithArcWithCenter:center
                                                          radius:innerCircleBounds.size.width / 2.0f
                                                      startAngle:twelveOclock-degreesElapsed
                                                        endAngle:twelveOclock];
        [innerTalkElapsedWedge lineToPoint:center];
        [innerTalkElapsedWedge closePath];
        
        [wedgeForeground set];
        [innerTalkElapsedWedge fill];
    }
    
    {
        const CGFloat dotSize = 10.0f;
        NSRect dotBounds = NSMakeRect(-dotSize/2, (bounds.size.width/2)-dotSize+1, dotSize, dotSize);
        NSRect glowBounds = NSInsetRect(dotBounds, -5.0f, -5.0f);
        
        NSBezierPath *outerSlideElapsedDotGlow = [NSBezierPath bezierPathWithOvalInRect:glowBounds];
        NSBezierPath *outerSlideElapsedDot = [NSBezierPath bezierPathWithOvalInRect:dotBounds];
        
        NSGradient *glowGradient = [[[NSGradient alloc] initWithColorsAndLocations:
                                     [outerSlideElapsedWedgeColor colorWithAlphaComponent:0.99f], 0.00,
                                     [outerSlideElapsedWedgeColor colorWithAlphaComponent:0.02f], 0.80,
                                     [outerSlideElapsedWedgeColor colorWithAlphaComponent:0.01f], 1.00,
                                     nil] autorelease];
        NSGradient *dotGradient = [[[NSGradient alloc] initWithStartingColor:[NSColor whiteColor]
                                                                 endingColor:outerSlideElapsedWedgeColor] autorelease];
        
        [[NSGraphicsContext currentContext] saveGraphicsState]; {
            NSAffineTransform *transform = [NSAffineTransform transform];
            
            // translate and rotate graphics state (order is important, translate first before rotating)
            [transform translateXBy:center.x yBy:center.y];
            [transform rotateByDegrees:-degreesElapsed];
            [transform concat];
            
            [glowGradient drawInBezierPath:outerSlideElapsedDotGlow relativeCenterPosition:NSZeroPoint];
            [dotGradient drawInBezierPath:outerSlideElapsedDot relativeCenterPosition:NSZeroPoint];
        } [[NSGraphicsContext currentContext] restoreGraphicsState];
    }
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay:YES];
}

// http://www.cocoadev.com/index.pl?PreventWindowOrdering
- (BOOL)shouldDelayWindowOrderingForEvent:(NSEvent *)theEvent;
{
    return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent;
{
    return YES;
}
@end
