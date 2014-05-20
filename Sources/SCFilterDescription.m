//
//  SCFilterDescription.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import "SCFilterDescription.h"
#import "SCFilterTranslator.h"

@interface SCFilterDescription() {
    NSMutableArray *_parameters;
}

@end

@implementation SCFilterDescription

- (id)initWithName:(NSString *)name andCategory:(NSString *)category {
    self = [super init];
    
    if (self) {
        _parameters = [NSMutableArray new];
        _name = name;
        _category = category;
    }
    
    return self;
}

- (void)addParameter:(SCFilterParameterDescription *)parameter {
    NSAssert(parameter != nil, @"parameter may not be nil");
    
    [_parameters addObject:parameter];
}

- (NSString *)description {
    NSMutableString *desc = [NSMutableString new];
    
    [desc appendFormat:@"Filter: %@\n", self.name];
    for (SCFilterParameterDescription *parameter in _parameters) {
        NSString *parameterDesc = parameter.description;
        [desc appendFormat:@"\t%@\n\n", [parameterDesc stringByReplacingOccurrencesOfString:@"\n" withString:@"\n\t"]];
    }
    
    return desc;
}


- (NSArray *)parameters {
    return _parameters;
}

- (NSString *)localizedCategory {
    return [SCFilterTranslator categoryName:self.category];
}

- (NSString *)localizedName {
    return [SCFilterTranslator filterName:self.name];
}

@end
