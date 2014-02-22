

#import <UIKit/UIKit.h>
#import "CDCircle.h"
#import "CDCircleThumb.h"
@interface CDCircleOverlayView : UIView {
    CDCircleThumb  *overlayThumb;
}
@property (nonatomic, strong) CDCircle *circle;
@property (nonatomic, assign) CGPoint controlPoint;
@property (nonatomic, assign) CGPoint buttonCenter;
@property (nonatomic, strong) CDCircleThumb *overlayThumb;

-(id) initWithCircle: (CDCircle *) cicle;

@end
