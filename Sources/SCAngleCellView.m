//
//  SCAngleCellView.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import "SCAngleCellView.h"

@implementation SCAngleCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (IBAction)valueChanged:(NSSlider *)sender {
    self.parameterValue = [NSNumber numberWithDouble:sender.doubleValue];
}

- (IBAction)textFieldValueChanged:(NSTextField *)sender {
    self.parameterValue = [NSNumber numberWithDouble:sender.doubleValue];
}

- (void)rebuild {
    [super rebuild];
    
    self.valueSlider.minValue = self.parameter.minValueAsDouble;
    self.valueSlider.maxValue = self.parameter.maxValueAsDouble;
}

- (void)updateWithParameterValue:(id)parameterValue {
    NSNumber *number = parameterValue;
    self.valueSlider.doubleValue = number.doubleValue;
    self.valueTextField.doubleValue = number.doubleValue;
}

@end
