
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define radiansToDegrees(x) ((x) / M_PI * 180)


@interface Common : NSObject


typedef enum {
    CGGradientPositionVertical = 1,
    CGGradientPositionHorizontal
} CGGradientPosition;

void drawLinearGradient(CGContextRef context, CGPathRef  path, CFArrayRef colors, CGGradientPosition position, CGFloat locations[], CGRect rect);

CGRect rectFor1PxStroke(CGRect rect);
@end
