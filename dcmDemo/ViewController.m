//
//  ViewController.m
//  dcmDemo
//
//  Created by ohtake shingo on 2014/02/22.
//  Copyright (c) 2014年 ohtake shingo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CDCircle* circle = [[CDCircle alloc] initWithFrame:CGRectMake(10 , 100, 300, 300) numberOfSegments:10 ringWidth:100.f];
    circle.dataSource = self;
    circle.delegate = self;
    CDCircleOverlayView *overlay = [[CDCircleOverlayView alloc] initWithCircle:circle];
    [self.view addSubview:circle];
    //Overlay cannot be subview of a circle because then it would turn around with the circle
    
    //ohtake_wrote
    overlay.alpha = 0.0f;
    [self.view addSubview:overlay];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) circle:(CDCircle *)circle didMoveToSegment:(NSInteger)segment thumb:(CDCircleThumb *)thumb{
    //NSLog(@"%d",segment);
    for (CDCircleThumb* otherThumb in circle.thumbs){
        //otherThumb.backgroundColor = [UIColor clearColor];
        //thumb.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        //thumb.transform = CGAffineTransformIdentity;
        otherThumb.scale = 0.25f;
        [otherThumb setNeedsDisplay];
    }
    
    //thumb.backgroundColor = [UIColor yellowColor];
    thumb.scale = 0.1f;
    [thumb setNeedsDisplay];
    //thumb.transform = CGAffineTransformMakeScale(2.0, 2.0);
    //thumb.layer.transform = CATransform3DMakeScale(2.0, 2.0, 1);
}

-(UIImage *) circle:(CDCircle *)circle iconForThumbAtRow:(NSInteger)row{
    NSString *fileString = [[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:nil] lastObject];
    
    return [UIImage imageWithContentsOfFile:fileString];
}

@end
