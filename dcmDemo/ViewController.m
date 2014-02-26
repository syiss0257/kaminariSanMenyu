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

    overlay.alpha = 0.0f;
    [self.view addSubview:overlay];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) circle:(CDCircle *)circle didMoveToSegment:(NSInteger)segment thumb:(CDCircleThumb *)thumb{

    for (CDCircleThumb* otherThumb in circle.thumbs){

        for (int i = 1; i<=5; i++) {
            otherThumb.scale = 0.1f + 0.03f*i;
            [otherThumb setNeedsDisplay];
        }
    }

    for (int t = 1; t<=5; t++) {
        
        
        double delayInSeconds = 0.01*t;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if (thumb.scale > 0.25 - 0.03f*t) {
                thumb.scale = 0.25 - 0.03f*t;

                [thumb setNeedsDisplay];;
            }
        });
        
    }
    [thumb setNeedsDisplay];

}

-(UIImage *) circle:(CDCircle *)circle iconForThumbAtRow:(NSInteger)row{
    NSString *fileString = [[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:nil] lastObject];
    
    return [UIImage imageWithContentsOfFile:fileString];
}

@end
