//
//  ViewController.m
//  CKCircleWidget
//
//  Created by Aileen Nielsen on 11/18/15.
//  Copyright © 2015 SunnysideProductions. All rights reserved.
//

#import "ViewController.h"
#import <math.h>
@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = self.view.frame.size.width;
    
    self.dialView = [[CKCircleView alloc] initWithFrame:CGRectMake((width - 200)/2, 100, 200, 200)];
    self.dialView.arcColor = [UIColor whiteColor];
    self.dialView.backColor = [UIColor lightGrayColor];
    self.dialView.dialColor = [UIColor whiteColor];
    self.dialView.arcRadius = 80;
    self.dialView.units = @"hours";
    self.dialView.minNum = 2;
    self.dialView.maxNum = 10;
    self.dialView.labelColor = [UIColor whiteColor];
    self.dialView.labelFont = [UIFont systemFontOfSize:20.0];
    [self.view addSubview: self.dialView];
    
    self.dialView2 = [[CKCircleView2 alloc] initWithFrame:CGRectMake((width - 200)/2, 340, 200, 200)];
    self.dialView2.arcColor = [UIColor redColor];
    self.dialView2.backColor = [UIColor clearColor];
    self.dialView2.dialColor = [UIColor redColor];
    self.dialView2.arcRadius = 80.0;
    self.dialView2.dialRadius = 20.0;
    self.dialView2.units = @"%";
    self.dialView2.arcThickness = 1.0;
    self.dialView2.labelColor = [UIColor redColor];
    self.dialView2.labelFont = [UIFont fontWithName:@"Helvetica" size:50.0];
    [self.view addSubview: self.dialView2];
    
    self.dialView3 = [[CKCircleView3 alloc] initWithFrame:CGRectMake((width - 80)/2, 580, 80, 80)];
    self.dialView3.arcColor = [UIColor purpleColor];
    self.dialView3.backColor = [UIColor greenColor];
    self.dialView3.dialColor = [UIColor yellowColor];
    self.dialView3.arcRadius = 30.0;
    self.dialView3.dialRadius = 5.0;
    self.dialView3.arcThickness = 1.0;
    self.dialView3.labelColor = [UIColor redColor];
    self.dialView3.labelFont = [UIFont fontWithName:@"Helvetica" size:10.0];
    self.dialView3.minNum = 100;
    self.dialView3.maxNum = 1000;
    [self.view addSubview: self.dialView3];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
