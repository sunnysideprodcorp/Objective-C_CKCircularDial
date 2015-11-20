//
//  CKCircleLabel.h
//  CKCircleWidget
//
//  Created by Aileen Nielsen on 11/20/15.
//  Copyright © 2015 SunnysideProductions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKCircleLabel : UILabel
@property NSString *units;

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end
