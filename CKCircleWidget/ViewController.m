//
//  ViewController.m
//  CKCircleWidget
//
//  Created by Aileen Nielsen on 11/18/15.
//  Copyright © 2015 SunnysideProductions. All rights reserved.
//

#import "ViewController.h"
#import "CKCircleView.h"
#import <math.h>
@interface ViewController () <UIGestureRecognizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dialView = [[CKCircleView alloc] initWithFrame:self.view.frame];
    [self.view addSubview: self.dialView];
    
    UIPanGestureRecognizer *pv = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.dialView addGestureRecognizer:pv];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handlePan:(UIPanGestureRecognizer *)pv {
    //CGPoint translation = [pv translationInView:self.view];
    CGPoint translation = [pv locationInView:self.view];
    CGFloat x_displace = translation.x - self.dialView.center.x;
    CGFloat y_displace = -1.0*(translation.y - self.dialView.center.y);
    double radius = pow(x_displace, 2) + pow(y_displace, 2);
    radius = pow(radius, .5);
    double angle = 180/M_PI*asin(x_displace/radius);
    if (x_displace > 0 && y_displace < 0){
        angle = 180 - angle;
    }
    else if (x_displace < 0){
        if(y_displace > 0){
            angle = 360.0 + angle;
        }
        else if(y_displace <= 0){
            angle = 180 + -1.0*angle;
        }
    }
    NSLog(@"moving to this angle %f", angle);
    [self.dialView moveCircleToAngle:angle];
}

@end
