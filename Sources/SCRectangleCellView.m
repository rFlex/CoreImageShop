//
//  SCRectangleCellView.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 20/05/14.
//
//

#import "SCRectangleCellView.h"

@implementation SCRectangleCellView

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
}


- (IBAction)valueChanged:(NSSlider *)sender {
    CIVector *current = self.parameterValue;
    
    if (sender == self.value1) {
        self.parameterValue = [CIVector vectorWithX:sender.floatValue Y:current.Y Z:current.Z W:current.W];
    } else if (sender == self.value2) {
        self.parameterValue = [CIVector vectorWithX:current.X Y:sender.floatValue Z:current.Z W:current.W];
    } else if (sender == self.value3) {
        self.parameterValue = [CIVector vectorWithX:current.X Y:current.Y Z:sender.floatValue W:current.W];
    } else {
        self.parameterValue = [CIVector vectorWithX:current.Z Y:current.Y Z:current.Z W:sender.floatValue];
    }
}

- (IBAction)textFieldValueChanged:(NSTextField *)sender {
    CIVector *current = self.parameterValue;
    
    if (sender == self.valueTextField1) {
        self.parameterValue = [CIVector vectorWithX:sender.floatValue Y:current.Y Z:current.Z W:current.W];
    } else if (sender == self.valueTextField2) {
        self.parameterValue = [CIVector vectorWithX:current.X Y:sender.floatValue Z:current.Z W:current.W];
    } else if (sender == self.valueTextField3) {
        self.parameterValue = [CIVector vectorWithX:current.X Y:current.Y Z:sender.floatValue W:current.W];
    } else {
        self.parameterValue = [CIVector vectorWithX:current.Z Y:current.Y Z:current.Z W:sender.floatValue];
    }
}

- (void)rebuild {
    [super rebuild];
    
//    CIVector *minValue = (CIVector *)self.parameter.minValue;
//    CIVector *maxValue = (CIVector *)self.parameter.maxValue;
    CIVector *minValue = [CIVector vectorWithX:0 Y:0 Z:0 W:0];
    CIVector *maxValue = [CIVector vectorWithX:1 Y:1 Z:1 W:1];
    
    self.value1.minValue = minValue.X;
    self.value1.maxValue = maxValue.X;
    self.value2.minValue = minValue.Y;
    self.value2.maxValue = maxValue.Y;
    self.value3.minValue = minValue.Z;
    self.value3.maxValue = maxValue.Z;
    self.value4.minValue = minValue.W;
    self.value4.maxValue = maxValue.W;
}

- (void)updateWithParameterValue:(id)parameterValue {
    [super updateWithParameterValue:parameterValue];
    
    CIVector *vector = parameterValue;
    self.valueTextField1.floatValue = self.value1.floatValue = vector.X;
    self.valueTextField2.floatValue = self.value2.floatValue = vector.Y;
    self.valueTextField3.floatValue = self.value3.floatValue = vector.Z;
    self.valueTextField4.floatValue = self.value4.floatValue = vector.W;
}


@end
