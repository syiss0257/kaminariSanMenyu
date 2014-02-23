
#define kIconViewWidth 30
#define kIconViewHeight 30

#import "Common.h"
#import "CDCircleThumb.h"
#import <QuartzCore/QuartzCore.h>
@implementation CDCircleThumb
@synthesize sRadius, lRadius, yydifference, arc, separatorColor,  centerPoint;
//@synthesize iconView;
@synthesize gradientFill, gradientColors, arcColor;
@synthesize colorsLocations;



- (id)initWithShortCircleRadius:(CGFloat)shortRadius longRadius:(CGFloat)longRadius numberOfSegments: (CGFloat) sNumber

{
    //Calculating suitable frame
        //Variables
    
    CGRect frame;
    
    CGFloat width;
    CGFloat height;
    //
    CGFloat fstartAngle = 270 - ((360/sNumber)/2);
    CGFloat fendAngle = 270 + ((360/sNumber)/2);
    //
    CGFloat startAngle = degreesToRadians(fstartAngle);
    CGFloat endAngle = degreesToRadians(fendAngle);
    
    
    UIBezierPath *bigArc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(longRadius, longRadius) radius:longRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
    UIBezierPath *smallArc = [UIBezierPath bezierPathWithArcCenter:CGPointMake(longRadius, longRadius) radius:shortRadius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
            // Start of calculations
    if ((fendAngle - fstartAngle) <= 180) {
            width = bigArc.bounds.size.width;
        height = smallArc.currentPoint.y ;
        frame = CGRectMake(0, 0, width, height);
    }
    if ((fendAngle - fstartAngle) > 269) {
        frame = CGRectMake(0, 0, bigArc.bounds.size.width, bigArc.bounds.size.height);
    }
            //End of calculations
    
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        sRadius = shortRadius;
        lRadius = longRadius;
        numberOfSegments = sNumber;
        CGFloat y = (lRadius - sRadius)/2.00;
        CGFloat xi = 0.5;
        CGFloat yi = y/frame.size.height;
        self.layer.anchorPoint = CGPointMake(xi, yi);
        self.gradientFill = YES;

        self.arcColor = [UIColor blackColor];
        
        self.centerPoint = CGPointMake(CGRectGetMidX(self.bounds), y);

        self.gradientColors =  [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor,(id)[UIColor grayColor].CGColor,  nil];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    [self.arcColor setStroke];
    [self.arcColor setFill];
    //Angles
    
    CGFloat clockwiseStartAngle = degreesToRadians((270 - ((360/numberOfSegments)/2)));
    CGFloat clockwiseEndAngle = degreesToRadians((270 + ((360/numberOfSegments)/2)));
    
    CGFloat nonClockwiseStartAngle = clockwiseEndAngle;
    CGFloat nonClockwiseEndAngle = clockwiseStartAngle;
      
    CGPoint center = CGPointMake(CGRectGetMidX(rect), lRadius);

    self.arc = [UIBezierPath bezierPathWithArcCenter: center radius:lRadius startAngle:clockwiseStartAngle endAngle:clockwiseEndAngle clockwise:YES];

    [arc addArcWithCenter:center radius:sRadius startAngle:nonClockwiseStartAngle endAngle:nonClockwiseEndAngle clockwise:NO];
    [arc closePath];
    [arc fill];

    [[UIColor lightGrayColor] setStroke];
    [[UIColor redColor] setFill];

}

-(BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return NO;
}

@end
