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
    
    NSDictionary *value = [self.filter.coreImageFilter.attributes  objectForKey:self.parameterName];
    
    self.valueSlider.minValue = ((NSNumber *)[value objectForKey:kCIAttributeSliderMin]).doubleValue;
    self.valueSlider.maxValue = ((NSNumber *)[value objectForKey:kCIAttributeSliderMax]).doubleValue;
}

- (void)updateWithParameterValue:(id)parameterValue {
    NSNumber *number = parameterValue;
    self.valueSlider.doubleValue = number.doubleValue;
    self.valueTextField.doubleValue = number.doubleValue;
}

@end
