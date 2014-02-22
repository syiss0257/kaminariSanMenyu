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
    [self.view addSubview:overlay];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) circle:(CDCircle *)circle didMoveToSegment:(NSInteger)segment thumb:(CDCircleThumb *)thumb{
    NSLog(@"%d",segment);
}

-(UIImage *) circle:(CDCircle *)circle iconForThumbAtRow:(NSInteger)row{
    NSString *fileString = [[[NSBundle mainBundle] pathsForResourcesOfType:@"png" inDirectory:nil] lastObject];
    
    return [UIImage imageWithContentsOfFile:fileString];
}

@end
