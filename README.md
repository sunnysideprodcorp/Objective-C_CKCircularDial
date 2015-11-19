#Set it and forget it circle widget

![circle image](https://github.com/sunnysideprodcorp/Objective-C_CKCircularDial/blob/master/drawing.gif)

This circle widget, build with some UIViews, UIPanGestureRecognizer and minimal Quartz utility is easy to use. Set a min and max number as well as desired arameters for the arc, circle, and background circle you want to draw. Finally, you can adjust the font and color of the measuring number and also attach an NSString to it to indicate units. 

Here's an example setup:
```
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
```

Defaults are in place for all public properties.

To-do list:
```
1. Make opacity of each element adjustable
2. Make CKCircleView contain a background circle rather than be the background circle so arcRadius has more flexibility
3. Move inner label to its own class and use KVO to update label info
```