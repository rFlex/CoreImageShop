//
//  SCFilterParameterConverterManager.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import "SCFilterParameterConverterManager.h"

@interface SCFilterParameterConverterManager() {
    NSMutableDictionary *_parameterConverters;
}

@end

@implementation SCFilterParameterConverterManager

- (id)init {
    self = [super init];
    
    if (self) {
        _parameterConverters = [NSMutableDictionary new];
        
        SCFilterParameterConverter *numberConverter = [[SCFilterParameterConverter alloc] initWithConverterBlock:^id(NSString *string) {
            return [NSNumber numberWithDouble:string.doubleValue];
        } objCGeneratorBlock:^NSString *(NSNumber *value) {
            return [NSString stringWithFormat:@"[NSNumber numberWithDouble:%f]", value.doubleValue];
        }];
        
        [self addParameterConverter:numberConverter forParameterType:@"CIAttributeTypeDistance"];
        [self addParameterConverter:numberConverter forParameterType:@"CIAttributeTypeScalar"];
        [self addParameterConverter:numberConverter forParameterType:@"CIAttributeTypeTime"];
        [self addParameterConverter:numberConverter forParameterType:@"CIAttributeTypeAngle"];
        
        SCFilterParameterConverter *vectorConverter = [[SCFilterParameterConverter alloc] initWithConverterBlock:^id(NSString *string) {
            return [CIVector vectorWithString:string];
        } objCGeneratorBlock:^NSString *(CIVector *value) {
            return [NSString stringWithFormat:@"[CIVector vectorWithString:%@]", value.stringRepresentation];
        }];
        
        [self addParameterConverter:vectorConverter forParameterType:@"CIAttributeTypeOffset"];
        [self addParameterConverter:vectorConverter forParameterType:@"CIAttributeTypePosition"];
        [self addParameterConverter:vectorConverter forParameterType:@"CIAttributeTypeRectangle"];
        
        SCFilterParameterConverter *colorVector = [[SCFilterParameterConverter alloc] initWithConverterBlock:^id(NSString *string) {
            return [CIColor colorWithString:string];
        } objCGeneratorBlock:^NSString *(CIColor *value) {
            return [NSString stringWithFormat:@"[CIColor colorWithString:%@]", value.stringRepresentation];
        }];
        
        [self addParameterConverter:colorVector forParameterType:@"CIAttributeTypeOpaqueColor"];
    
        
    }
    
    return self;
}

- (void)addParameterConverter:(SCFilterParameterConverter *)converter forParameterType:(NSString *)parameterType {
    [_parameterConverters setObject:converter forKey:parameterType];
}

- (SCFilterParameterConverter *)converterForParameterDescription:(SCFilterParameterDescription *)parameterDescription {
    return [self converterForParameterType:parameterDescription.type];
}

- (SCFilterParameterConverter *)converterForParameterType:(NSString *)parameterType {
    return [_parameterConverters objectForKey:parameterType];
}

+ (SCFilterParameterConverterManager *)sharedInstance {
    static SCFilterParameterConverterManager *_sharedInstance = nil;
    
    if (_sharedInstance == nil) {
        _sharedInstance = [[SCFilterParameterConverterManager alloc] init];
    }
    
    return _sharedInstance;
}

@end
