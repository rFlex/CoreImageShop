//
//  SCFilterParameterConfigurationCellView.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import <QuartzCore/QuartzCore.h>
#import "SCFilterParameterConfigurationCellView.h"

@implementation SCFilterParameterConfigurationCellView

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

- (void)rebuild {
    if (_parameter != nil) {
        [self updateWithParameterValue:self.parameterValue];        
    }
}

- (void)updateWithParameterValue:(id)parameterValue {
    
}

- (void)setParameterValue:(id)parameterValue {
    [_filter setParameterValue:parameterValue forParameterDescription:_parameter];
    
    [self updateWithParameterValue:parameterValue];
}

- (id)parameterValue {
    return [_filter.coreImageFilter valueForKey:_parameter.name];
}

@end
