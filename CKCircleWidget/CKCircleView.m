//
//  CKCircleView.m
//  CKCircleWidget
//
//  Created by Aileen Nielsen on 11/18/15.
//  Copyright © 2015 SunnysideProductions. All rights reserved.
//

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

#import "CKCircleView.h"
#import <math.h>
@implementation CKCircleView


- (void) drawRect:(CGRect)rect {
    NSLog(@"DRAWING RECT");
    CGFloat width = 50;
    UIColor *color =[UIColor blueColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, width);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    UIBezierPath *path = [self createArcPathWithAngle:self.angle atPoint:self.center withRadius:self.radius];

    CGContextRef *ref =  UIGraphicsGetCurrentContext();
    path.lineWidth = 5;
    if(self.angle > 1)[path stroke];

}


- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.userInteractionEnabled = YES;
        self.minNum = 0;
        self.maxNum = 100;
        self.currentNum = self.minNum;
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        CGFloat radius = 10;
        self.circle = [[UIView alloc] initWithFrame:CGRectMake((width - radius*2)/2, height*.25, radius*2, radius*2)];
        self.circle.layer.cornerRadius = radius;
        self.circle.backgroundColor = [UIColor redColor];
        self.circle.userInteractionEnabled = YES;
        [self addSubview: self.circle];
        self.radius = 100;
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/3, height/2 - width/6, width/3, width/3)];
        self.numberLabel.text = [NSString stringWithFormat:@"%d", self.currentNum];
        self.numberLabel.center = self.center;
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.font = [UIFont fontWithName:@"Arial" size:30.0];
        
        self.backgroundColor = [UIColor yellowColor];
        [self moveCircleToAngle:0];
        [self addSubview:self.numberLabel];
        
        [self setNeedsDisplay];

    }
    
    return self;
}


- (void) moveCircleToAngle: (double)angle{
    self.angle = angle;
    [self setNeedsDisplay];
    CGPoint newCenter = self.center;
    NSLog(@"here is center: %f and %f", self.center.x, self.center.y);
    NSLog(@"here is radius %f and angle: %f", self.radius, angle);
    newCenter.y += self.radius * sin(M_PI/180 * (angle - 90));
    newCenter.x += self.radius * cos(M_PI/180 * (angle - 90));
    NSLog(@"here is suggested movement for x %f and for y %f for this angle: %f", self.radius * cos(M_PI/180 * angle - 90),  self.radius * sin(M_PI/180 * angle - 90), angle-90);
        NSLog(@"here is new center: %f and %f", newCenter.x, newCenter.y);
    self.circle.center = newCenter;
    self.currentNum = self.minNum + (self.maxNum - self.minNum)*(angle/360.0);
    self.numberLabel.text = [NSString stringWithFormat:@"%d", self.currentNum];

}


- (UIBezierPath *)createArcPathWithAngle:(double)angle atPoint: (CGPoint) point withRadius: (float) radius
{
    float endAngle = (float)(((int)angle + 270 + 1)%360);
    NSLog(@"end angle is %f", endAngle);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithArcCenter:point
                                                         radius:radius
                                                     startAngle:DEGREES_TO_RADIANS(270)
                                                       endAngle:DEGREES_TO_RADIANS(endAngle)
                                                      clockwise:YES];
    return aPath;
}



@end
