

#define deceleration_multiplier 30.0f

#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioServices.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "CDCircle.h"
#import "CDCircleGestureRecognizer.h"
#import "CDCircleOverlayView.h"
#import "Common.h"
//#import "CDCircleThumb.h"



@implementation CDCircleGestureRecognizer

@synthesize rotation = rotation_, controlPoint;
@synthesize ended;
@synthesize currentThumb;
int circleDirection = 0;//0:方向なし　1:右回り　2:左回り

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CDCircle *view = (CDCircle *) [self view];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:view];

    
   // Fail when more than 1 finger detected.
   if ([[event touchesForGestureRecognizer:self] count] > 1 || ([view.path containsPoint:point] == YES )) {
      [self setState:UIGestureRecognizerStateFailed];
   }
    self.ended = NO;
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

   if ([self state] == UIGestureRecognizerStatePossible) {
      [self setState:UIGestureRecognizerStateBegan];
   } else {
      [self setState:UIGestureRecognizerStateChanged];
   }

   // We can look at any touch object since we know we 
   // have only 1. If there were more than 1 then 
   // touchesBegan:withEvent: would have failed the recognizer.
   UITouch *touch = [touches anyObject];

   // To rotate with one finger, we simulate a second finger.
   // The second figure is on the opposite side of the virtual
   // circle that represents the rotation gesture.

    CDCircle *view = (CDCircle *) [self view];
   CGPoint center = CGPointMake(CGRectGetMidX([view bounds]), CGRectGetMidY([view bounds]));
   CGPoint currentTouchPoint = [touch locationInView:view];
   CGPoint previousTouchPoint = [touch previousLocationInView:view];
    previousTouchDate = [NSDate date];
    CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
   [self setRotation:angleInRadians];
    currentTransformAngle = atan2f(view.transform.b, view.transform.a);

    
    
    
    for (CDCircleThumb *thumb in view.thumbs) {
        CGPoint point = [thumb convertPoint:thumb.centerPoint toView:nil];
        CDCircleThumb *shadow = view.overlayView.overlayThumb;
        CGRect shadowRect = [shadow.superview convertRect:shadow.frame toView:nil];
        
        if (CGRectContainsPoint(shadowRect, point) == YES) {
            
            float kyori = CGRectGetMidX(shadowRect)-shadowRect.origin.x;//定数
            thumb.scale = 0.15/kyori*fabs(CGRectGetMidX(shadowRect)-point.x)+0.1;
            
//            
//            thumb.scale = 0.4;
//            thumb.scale = 0.25 - 0.15;
            //NSLog(@"%f",thumb.scale);
            [thumb setNeedsDisplay];
//            if (thumb.tag==5) {
//                NSLog(@"%f",(CGRectGetMidX(shadowRect)-point.x));
//                //thumb.backgroundColor = [UIColor redColor];
//                //self.state = UIGestureRecognizerStateEnded;
//                //self.state = UIGestureRecognizerStateCancelled;
//                if (fabs((CGRectGetMidX(shadowRect)-point.x))<15) {
//                    [self touchesEnded:[NSSet set] withEvent:[UIEvent alloc]];
//                }
//                //[self touchesEnded:[NSSet set] withEvent:[UIEvent alloc]];
//                //self.state =  UIGestureRecognizerStateBegan;
//                //                self.enabled = NO;
//                //                self.enabled =YES;
//            }
            NSLog(@"VVVVVVVVVV%f",(CGRectGetMidX(shadowRect)-point.x));
            if (thumb.tag==0) {
                //NSLog(@"VVVVVVVVVV%f",(CGRectGetMidX(shadowRect)-point.x));
                if (fabs((CGRectGetMidX(shadowRect)-point.x))<15) {
                                           if ((CGRectGetMidX(shadowRect)-point.x)>-5) {
                                               //circleDirection = 0;
                                            } else {
                                               //circleDirection = 0;
                                             [self touchesEnded:[NSSet set] withEvent:[UIEvent alloc]];
                                            }

                }
                
             }
            
        }else if(thumb.tag==9){
            
            if (fabs((CGRectGetMidX(shadowRect)-point.x))<15 && point.y<100) {
                NSLog(@"PPPPPPPPPPPPPPPPPP");
                if ((CGRectGetMidX(shadowRect)-point.x)<-5) {
                    //circleDirection = 0;
                } else {
                    //circleDirection = 0;
                    [self touchesEnded:[NSSet set] withEvent:[UIEvent alloc]];
                }
            }} else {
            //thumb.backgroundColor = [UIColor clearColor];
        }
    }
    ;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

   // Perform final check to make sure a tap was not misinterpreted.
   if ([self state] == UIGestureRecognizerStateChanged) {
    
       
       CDCircle *view = (CDCircle *) [self view];
       CGFloat flipintime = 0;
       CGFloat angle = 0;
       if (view.inertiaeffect == YES) {
           CGFloat angleInRadians = atan2f(view.transform.b, view.transform.a) - currentTransformAngle;
           double time = [[NSDate date] timeIntervalSinceDate:previousTouchDate];
           double velocity = angleInRadians/time;
           CGFloat a = deceleration_multiplier;
           
            flipintime = fabs(velocity)/a; 
           
           
           
            angle = (velocity*flipintime)-(a*flipintime*flipintime/2);
           
           if (angle>M_PI/2 || (angle<0 && angle<-1*M_PI/2)) {
               if (angle<0) {
                   angle =-1 * M_PI/2.1f;
               }    
               else { angle = M_PI/2.1f; }
               
               flipintime = 1/(-1*(a/2*velocity/angle));
           }

       }
       

       [UIView animateWithDuration:flipintime delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
           
           [view setTransform:CGAffineTransformRotate(view.transform,angle)];


       } completion:^(BOOL finished) {
           for (CDCircleThumb *thumb in view.thumbs) {
               
               NSLog(@"RRRRRRRRR%f",radiansToDegrees(atan2(view.transform.a, view.transform.b)));
               CGPoint point = [thumb convertPoint:thumb.centerPoint toView:nil];
               CDCircleThumb *shadow = view.overlayView.overlayThumb;
               CGRect shadowRect = [shadow.superview convertRect:shadow.frame toView:nil];
               
               if (CGRectContainsPoint(shadowRect, point) == YES) {
//                   NSLog(@"ZZZZZZZZZZZZZZZ%d",thumb.tag);
//                   if (thumb.tag==5) {
//                       thumb.backgroundColor = [UIColor yellowColor];
//                   }
                   
                   CGPoint pointInShadowRect = [thumb convertPoint:thumb.centerPoint toView:shadow];
                   if (CGPathContainsPoint(shadow.arc.CGPath, NULL, pointInShadowRect, NULL)) {
                       CGAffineTransform current = view.transform;

                    CGFloat deltaAngle= - degreesToRadians(180) + atan2(view.transform.a, view.transform.b) + atan2(thumb.transform.a, thumb.transform.b);
                       //CGFloat deltaAngle= degreesToRadians(180) + atan2(view.transform.a, view.transform.b) + atan2(thumb.transform.a, thumb.transform.b);

                       //NSLog(@"EEEEEEEEES%f",radiansToDegrees(deltaAngle));
                       //deltaAngle = degreesToRadians(180);
                       //deltaAngle =0;
                       
                        [UIView animateWithDuration:0.2f animations:^{
                       
                            [view setTransform:CGAffineTransformRotate(current, deltaAngle)];
                        }];
 
                       SystemSoundID soundID;
                       NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iPod Click" ofType:@"aiff"];
                       
                       NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
                       AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &soundID);
                       AudioServicesPlaySystemSound(soundID);

                       self.currentThumb = thumb;
                       //Delegate method
                       [view.delegate circle:view didMoveToSegment:thumb.tag thumb:thumb];
                       self.ended = YES;
                       break;
                   }
                   //thumb.backgroundColor = [UIColor blueColor];
               }
//               else {
//                   thumb.backgroundColor = [UIColor redColor];
//               }
           }
;
       }];


       currentTransformAngle = 0;
       
       
              
     [self setState:UIGestureRecognizerStateEnded];  
       
   } else {
       
       //button押した時の処理
       
       CDCircle *view = (CDCircle *)[self view];
       UITouch *touch = [touches anyObject];
       
       for (CDCircleThumb *thumb in view.thumbs) {
           
           CGPoint touchPoint = [touch locationInView:thumb];
           if (CGPathContainsPoint(thumb.arc.CGPath, NULL, touchPoint, NULL)) {
               
               CGFloat deltaAngle= - degreesToRadians(180) + atan2(view.transform.a, view.transform.b) + atan2(thumb.transform.a, thumb.transform.b);
               CGAffineTransform current = view.transform;
               [UIView animateWithDuration:0.3f animations:^{
                   [view setTransform:CGAffineTransformRotate(current, deltaAngle)];
               } completion:^(BOOL finished) {
                   
                   SystemSoundID soundID;
                   NSString *filePath = [[NSBundle mainBundle] pathForResource:@"iPod Click" ofType:@"aiff"];
                   
                   NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
                   AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl, &soundID);
                   AudioServicesPlaySystemSound(soundID);

                   self.currentThumb = thumb;
                   //Delegate method
                   [view.delegate circle:view didMoveToSegment:thumb.tag thumb:thumb];
                   self.ended = YES;
                   
               }];
               
               break;
           }
           
       }
       
       [self setState:UIGestureRecognizerStateFailed];
   }
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   [self setState:UIGestureRecognizerStateFailed];
}
@end


//NSLog(@"SSSSSSSSSS%f",(CGRectGetMidX(shadowRect)-point.x));
//                    CGPoint v = [self velocityInView:thumb];
//                    NSLog(@"PPPPPPPPP%f",v.x);
//                    CGPoint p = [self translationInView:view];
//                    NSLog(@"KKKKKKKKKKK%f",p.x);
//                    double delayInSeconds = 0.03;
//                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//
//                        NSLog(@"SSSSSSSSSS%f",(CGRectGetMidX(shadowRect)-point.x));
//
//                    });

//                    if (circleDirection == 0) {
//                        NSLog(@"0000000000");
//                        if ((CGRectGetMidX(shadowRect)-point.x)>=0) {
//                            circleDirection = 1;
//                        } else if((CGRectGetMidX(shadowRect)-point.x)<0){
//                            circleDirection = 2;
//                        }
//
//                        //[self touchesEnded:[NSSet set] withEvent:[UIEvent alloc]];
//
//                    } else if(circleDirection == 1){
//                        NSLog(@"1111111111");
//                        if ((CGRectGetMidX(shadowRect)-point.x)<0) {
//                            //circleDirection = 0;
//                        } else {
//                            //circleDirection = 0;
//                          [self touchesEnded:[NSSet set] withEvent:[UIEvent alloc]];
//                        }
//
//                    } else if(circleDirection == 2){
//                        NSLog(@"22222222222");
//                        if ((CGRectGetMidX(shadowRect)-point.x)<0) {
//                            //circleDirection = 0;
//                        } else {
//                            //circleDirection = 0;
//                            [self touchesEnded:[NSSet set] withEvent:[UIEvent alloc]];
//                        }
//                    }
//                    //[self touchesEnded:[NSSet set] withEvent:[UIEvent alloc]];
//                    //[self setState:UIGestureRecognizerStateFailed];
//                    if ((CGRectGetMidX(shadowRect)-point.x)<0) {
//
//                    } else {
//                        [self touchesEnded:[NSSet set] withEvent:[UIEvent alloc]];
//                    }



//
//           CDCircleThumb *thumb = [view.thumbs objectAtIndex:5];
//           CGPoint point2 = [thumb convertPoint:thumb.centerPoint toView:nil];
//           CDCircleThumb *shadow = view.overlayView.overlayThumb;
//           CGRect shadowRect = [shadow.superview convertRect:shadow.frame toView:nil];
//

//       for (CDCircleThumb *thumb in view.thumbs) {
//           CGPoint point = [thumb convertPoint:thumb.centerPoint toView:nil];
//           CDCircleThumb *shadow = view.overlayView.overlayThumb;
//           CGRect shadowRect = [shadow.superview convertRect:shadow.frame toView:nil];
//
//           if (CGRectContainsPoint(shadowRect, point) == YES) {
//               if (thumb.tag == 5) {
//                   angle =0;
//                   NSLog(@"jjjjjjjjjjj");
//                   [self setState:UIGestureRecognizerStateEnded];
//                   return;
//
//               }
//
//           }
//       }




//NSLog(@"SSSSSSSSS%f",radiansToDegrees(angle));
//angle =0;
//return;
//NSLog(@"EEEEEEEEES%f",radiansToDegrees(angle));


//NSLog(@"RRRRRRRRR%f",radiansToDegrees(atan2(view.transform.a, view.transform.b) + atan2(thumb.transform.a, thumb.transform.b)));
//                       CGFloat deltaAngle;
//                       if (radiansToDegrees(atan2(view.transform.a, view.transform.b))<90 && 0<radiansToDegrees(atan2(view.transform.a, view.transform.b))) {
//                          //deltaAngle= - degreesToRadians(0) + atan2(view.transform.a, view.transform.b) + atan2(thumb.transform.a, thumb.transform.b);
//                           deltaAngle =- degreesToRadians(180) + atan2(view.transform.a, view.transform.b) + atan2(thumb.transform.a, thumb.transform.b)-angle;
//                       } else{
//                           deltaAngle= - degreesToRadians(180) + atan2(view.transform.a, view.transform.b) + atan2(thumb.transform.a, thumb.transform.b);
// }


//           if (CGRectContainsPoint(shadowRect, point2) == YES) {
//               //NSLog(@"ZZZZZZZZZZZZZZZ%d",thumb.tag);
//                   thumb.backgroundColor = [UIColor yellowColor];
//               }
//           for (CDCircleThumb *thumb in view.thumbs) {
//
//
//               CGPoint point2 = [thumb convertPoint:thumb.centerPoint toView:nil];
//               CDCircleThumb *shadow = view.overlayView.overlayThumb;
//               CGRect shadowRect = [shadow.superview convertRect:shadow.frame toView:nil];
//
//               if (CGRectContainsPoint(shadowRect, point2) == YES) {
//                   NSLog(@"ZZZZZZZZZZZZZZZ%d",thumb.tag);
//                   if (thumb.tag==5) {
//                       thumb.backgroundColor = [UIColor yellowColor];
//                   }}}

