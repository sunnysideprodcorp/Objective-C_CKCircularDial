//
//  CKCircleView.h
//  CKCircleWidget
//
//  Created by Aileen Nielsen on 11/18/15.
//  Copyright © 2015 SunnysideProductions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKCircleView : UIView
@property int currentNum;
@property int minNum;
@property int maxNum;
@property double angle;
@property CGFloat radius;
@property UIView *circle;
@property UILabel *numberLabel;
- (void) moveCircleToAngle: (double)angle;
@end
