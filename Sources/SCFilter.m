//
//  SCFilter.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <QuartzCore/QuartzCore.h>
#import "SCFilter.h"

@interface SCFilter() {
}

@end

@implementation SCFilter

- (id)initWithFilterDescription:(SCFilterDescription *)filterDescription {
    self = [super init];
    
    if (self) {
        _filterDescription = filterDescription;
        _coreImageFilter = [CIFilter filterWithName:filterDescription.name];
        [_coreImageFilter setDefaults];
        self.enabled = YES;
    }
    
    return self;
}

+ (SCFilter *)filterWithFilterDescription:(SCFilterDescription *)filterDescription {
    SCFilter *filter = [[SCFilter alloc] initWithFilterDescription:filterDescription];
    
    if (filter.coreImageFilter == nil) {
        filter = nil;
    }
    
    return filter;
}

- (id)parameterValueForParameterDescription:(SCFilterParameterDescription *)parameterDescription {
    return [_coreImageFilter valueForKey:parameterDescription.name];
}

- (void)setParameterValue:(id)value forParameterDescription:(SCFilterParameterDescription *)parameterDescription {
    [_coreImageFilter setValue:value forKey:parameterDescription.name];
    
    id<SCFilterDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(filter:didChangeParameter:)]) {
        [delegate filter:self didChangeParameter:parameterDescription];
    }
}

- (void)resetToDefaults {
    [_coreImageFilter setDefaults];
    
    id<SCFilterDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(filterDidResetToDefaults:)]) {
        [delegate filterDidResetToDefaults:self];
    }
}

@end
