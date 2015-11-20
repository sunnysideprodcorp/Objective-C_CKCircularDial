//
//  CKCircleLabel.m
//  CKCircleWidget
//
//  Created by Aileen Nielsen on 11/20/15.
//  Copyright © 2015 SunnysideProductions. All rights reserved.
//

#import "CKCircleLabel.h"

@implementation CKCircleLabel

- (void) numberDidChangeTo: (int)num{
    self.text = [NSString stringWithFormat:@"%d %@", num, self.units ];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentNum"])
    {
        [self numberDidChangeTo:[[change valueForKey:@"new"] intValue]];
    }
    else if([keyPath isEqualToString:@"units"]){
        self.units = [change valueForKey:@"new"];
    }
}

@end
