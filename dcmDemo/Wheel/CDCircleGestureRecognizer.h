
#import <UIKit/UIKit.h>

@class CDCircleThumb;
//@interface CDCircleGestureRecognizer : UIGestureRecognizer
@interface CDCircleGestureRecognizer : UIGestureRecognizer
{
    NSDate *previousTouchDate;
    double currentTransformAngle;
    //int circleDirection;//0:方向なし　1:右回り　2:左回り
}


@property (nonatomic, assign) BOOL ended;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGPoint controlPoint;
@property (nonatomic, strong) CDCircleThumb *currentThumb;
@end
