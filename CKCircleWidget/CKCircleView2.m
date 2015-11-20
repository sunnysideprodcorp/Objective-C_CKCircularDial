//
//  CKCircleView2.m
//  CKCircleWidget
//
//  Created by Aileen Nielsen on 11/18/15.
//  Copyright © 2015 SunnysideProductions. All rights reserved.
//

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

#import "CKCircleView2.h"
#import <math.h>
#import <QuartzCore/QuartzCore.h>
#import "CKCircleLabel.h"

@interface CKCircleView2 () <UIGestureRecognizerDelegate>
@property CGPoint trueCenter;
@property CKCircleLabel *numberLabel;

@property double angle;
@property UIView *circle;

@end

@implementation CKCircleView2



# pragma mark view appearance setup

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        // overall view settings
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        
        // setting default values
        self.minNum = 0;
        self.maxNum = 100;
        self.currentNum = self.minNum;
        self.units = @"";
        
        // determine true center of view for calculating angle and setting up arcs
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        self.trueCenter = CGPointMake(width/2, height/2);
        
        // radii settings
        self.dialRadius = 10;
        self.arcRadius = 50;
        self.outerRadius = MIN(width, height)/2;
        self.arcThickness = 5.0;
        
        self.circle = [[UIView alloc] initWithFrame:CGRectMake((width - self.dialRadius*2)/2, height*.25, self.dialRadius*2, self.dialRadius*2)];
        self.circle.userInteractionEnabled = YES;
        [self addSubview: self.circle];
        
        // number label tracks progress around the circle
        self.numberLabel = [[CKCircleLabel alloc] initWithFrame:CGRectMake(width*.1, height/2 - width/6, width*.8, width/3)];
        self.numberLabel.text = [NSString stringWithFormat:@"%d %@", self.currentNum, self.units];
        self.numberLabel.center = self.trueCenter;
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.labelFont =[ UIFont fontWithName:@"Arial" size:15.0];
        self.numberLabel.font = self.labelFont;
        [self addSubview:self.numberLabel];
        
        // pan gesture detects circle dragging
        UIPanGestureRecognizer *pv = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:pv];
        
        self.arcColor = [UIColor redColor];
        self.backColor = [UIColor yellowColor];
        self.dialColor = [UIColor blueColor];
        self.labelColor = [UIColor blackColor];
        

        
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect {
    UIColor *color = self.arcColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    UIBezierPath *path = [self createArcPathWithAngle:self.angle atPoint:self.trueCenter withRadius:self.arcRadius];
    path.lineWidth = self.arcThickness;
    if(self.angle > 1)[path stroke];
    
}

- (void) willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    
    self.arcRadius = MIN(self.arcRadius, self.outerRadius - self.dialRadius);
    
    // background circle
    self.layer.cornerRadius = self.outerRadius;
    self.backgroundColor = self.backColor;
    
    // dial
    self.circle.frame =  CGRectMake((self.frame.size.width - self.dialRadius*2)/2, self.frame.size.height*.25, self.dialRadius*2, self.dialRadius*2);
    self.circle.layer.cornerRadius = self.dialRadius;
    self.circle.backgroundColor = self.dialColor;
    
    // label
    self.numberLabel.font = self.labelFont;
    self.numberLabel.text = [NSString stringWithFormat:@"%d %@", self.currentNum, self.units];
    self.numberLabel.units = self.units;
    self.numberLabel.textColor = self.labelColor;
    
    [self moveCircleToAngle:0];
    [self setNeedsDisplay];

    // KVO
    [self addObserver:self.numberLabel forKeyPath:@"currentNum" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.numberLabel forKeyPath:@"units" options:NSKeyValueObservingOptionNew context:nil];

    
}

# pragma mark deallocation

- (void) dealloc {
    [self removeObserver:self.numberLabel forKeyPath:@"units"];
    [self removeObserver:self.numberLabel forKeyPath:@"currentNum"];
}

# pragma mark move circle in response to pan gesture

- (void) moveCircleToAngle: (double)angle{
    self.angle = angle;
    [self setNeedsDisplay];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGPoint newCenter = CGPointMake(width/2, height/2);
    
    newCenter.y += self.arcRadius * sin(M_PI/180 * (angle - 90));
    newCenter.x += self.arcRadius * cos(M_PI/180 * (angle - 90));
    self.circle.center = newCenter;
    self.currentNum = (self.minNum + (self.maxNum - self.minNum)*(angle/360.0));
    NSLog(@"inside move circle current numb is %d", self.currentNum);
  //  self.numberLabel.text = [NSString stringWithFormat:@"%d %@", self.currentNum, self.units];
}


- (UIBezierPath *)createArcPathWithAngle:(double)angle atPoint: (CGPoint) point withRadius: (float) radius
{
    float endAngle = (float)(((int)angle + 270 + 1)%360);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:point
                                                         radius:radius
                                                     startAngle:DEGREES_TO_RADIANS(270)
                                                       endAngle:DEGREES_TO_RADIANS(endAngle)
                                                      clockwise:YES];
    return aPath;
}

# pragma mark detect pan and determine angle of pan location vs. center of circular revolution

- (void) handlePan:(UIPanGestureRecognizer *)pv {
    
    CGPoint translation = [pv locationInView:self];
    CGFloat x_displace = translation.x - self.trueCenter.x;
    CGFloat y_displace = -1.0*(translation.y - self.trueCenter.y);
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
    
    [self moveCircleToAngle:angle];
}


@end
