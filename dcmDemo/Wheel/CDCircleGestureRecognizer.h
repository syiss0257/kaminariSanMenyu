
#import <UIKit/UIKit.h>

@class CDCircleThumb;
@interface CDCircleGestureRecognizer : UIGestureRecognizer 
{
    NSDate *previousTouchDate;
    double currentTransformAngle;
}


@property (nonatomic, assign) BOOL ended;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGPoint controlPoint;
@property (nonatomic, strong) CDCircleThumb *currentThumb;
@end
