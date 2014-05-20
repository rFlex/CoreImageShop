//
//  SCFilterParameterConverter.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import "SCFilterParameterConverter.h"

@interface SCFilterParameterConverter() {
    ConverterBlock _converterBlock;
    ObjCGeneratorBlock _generatorBlock;
}

@end

@implementation SCFilterParameterConverter

- (id)initWithConverterBlock:(ConverterBlock)convertBlock objCGeneratorBlock:(ObjCGeneratorBlock)generatorBlock {
    self = [super init];
    
    if (self) {
        _converterBlock = [convertBlock copy];
        _generatorBlock = [generatorBlock copy];
    }
    
    return self;
}

- (NSString *)generateObjCCodeForValue:(id)value {
    if (_generatorBlock != nil) {
        return _generatorBlock(value);
    }
    
    return nil;
}

- (id)convertFromString:(NSString *)string {
    if (_converterBlock != nil) {
        return _converterBlock(string);
    }
    
    return nil;
}

@end
