//
//  CKCircleView3.m
//  CKCircleWidget
//
//  Created by Aileen Nielsen on 11/18/15.
//  Copyright © 2015 SunnysideProductions. All rights reserved.
//

// this will be finished once I find out how to center text within a frame in CoreText

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

#import "CKCircleView3.h"
#import <math.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface CKCircleView3 () <UIGestureRecognizerDelegate>
@property CGPoint trueCenter;
@property UILabel *numberLabel;
@property int currentNum;
@property double angle;
@property UIView *circle;

@end

@implementation CKCircleView3



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
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*.1, height/2 - width/6, width*.8, width/3)];
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
    
    
    
    
    //    create attributed string
    NSString *textString = @"cauchy kun and fawn";
    CFMutableAttributedStringRef attrStr = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrStr, CFRangeMake(0, 0), (CFStringRef) textString);
    
    //    create font
    CTFontRef font = CTFontCreateWithName(CFSTR("Times New Roman"), 16, NULL);
    
    //    create paragraph style and assign text alignment to it
    //CTTextAlignment alignment = kCTJustifiedTextAlignment;
    CTTextAlignment alignment = kCTTextAlignmentCenter;
    CTParagraphStyleSetting _settings[] = {    {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment} };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(_settings, sizeof(_settings) / sizeof(_settings[0]));
    
    //    set paragraph style attribute
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle);
    
    //    set font attribute
    CFAttributedStringSetAttribute(attrStr, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font);
    

    
    
    
    
   // CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0f, -1.0f)); // http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
    CGMutablePathRef path2 = CGPathCreateMutable(); //1
    CGPathAddRect(path2, NULL, self.numberLabel.frame);
    
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"%d %@", self.currentNum, self.units]]; //2
    
    /*
    //    set paragraph style attribute
    CFAttributedStringSetAttribute(attString, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTParagraphStyleAttributeName, paragraphStyle);
    
    //    set font attribute
    CFAttributedStringSetAttribute(attString, CFRangeMake(0, CFAttributedStringGetLength(attrStr)), kCTFontAttributeName, font);
    */
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString); //3
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter,
                             CFRangeMake(0, [attString length]), path2, NULL);
    
    CTFrameDraw(frame, context); //4
    
    CFRelease(frame); //5
    CFRelease(path2);
    CFRelease(framesetter);
    

    
    
    
    
    
    //    release paragraph style and font
    CFRelease(paragraphStyle);
    CFRelease(font);
    
    
    
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
    self.numberLabel.textColor = self.labelColor;
    
    [self moveCircleToAngle:0];
    [self setNeedsDisplay];
    
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
    self.currentNum = self.minNum + (self.maxNum - self.minNum)*(angle/360.0);
    self.numberLabel.text = [NSString stringWithFormat:@"%d %@", self.currentNum, self.units];
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
