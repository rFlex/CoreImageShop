//
//  SCFilterParameter.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import "SCFilterParameterDescription.h"
#import "SCFilterTranslator.h"

@implementation SCFilterParameterDescription

- (id)initWithName:(NSString *)name {
    self = [super init];
    
    if (self) {
        _name = name;
    }
    
    return self;
}

- (NSString *)description {
    NSMutableString *desc = [NSMutableString new];
    
    [desc appendFormat:@"Name: %@\n", self.name];
    [desc appendFormat:@"Type: %@\n", self.type];
    [desc appendFormat:@"Min Value: %@\n", self.minValue];
    [desc appendFormat:@"Max Value: %@", self.maxValue];
    
    return desc;
}

- (NSString *)localizedName {
    return [SCFilterTranslator parameterName:self.name];
}

- (double)minValueAsDouble {
    return ((NSNumber *)self.minValue).doubleValue;
}

- (double)maxValueAsDouble {
    return ((NSNumber *)self.maxValue).doubleValue;
}

@end
