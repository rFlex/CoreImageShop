//
//  SCFilterTranslator.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <Foundation/Foundation.h>

@interface SCFilterTranslator : NSObject

+ (NSString *)camelCaseToHumanReadable:(NSString *)name;
+ (NSString *)categoryName:(NSString *)name;
+ (NSString *)filterName:(NSString *)filterName;
+ (NSString *)parameterName:(NSString *)parameterName;

@end
