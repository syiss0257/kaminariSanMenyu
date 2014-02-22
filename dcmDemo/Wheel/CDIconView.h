
#import <UIKit/UIKit.h>

@interface CDIconView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, setter = setIsSelected:) BOOL selected;
@property (nonatomic, strong) UIColor *highlitedIconColor;
-(void) setIsSelected:(BOOL)isSelected; 

@end
