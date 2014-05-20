//
//  SCFilterParameterConverter.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import <Foundation/Foundation.h>

typedef id(^ConverterBlock)(NSString *string);
typedef NSString *(^ObjCGeneratorBlock)(id value);

@interface SCFilterParameterConverter : NSObject

- (id)initWithConverterBlock:(ConverterBlock)convertBlock objCGeneratorBlock:(ObjCGeneratorBlock)generatorBlock;

- (id)convertFromString:(NSString *)string;

- (NSString *)generateObjCCodeForValue:(id)value;

@end
