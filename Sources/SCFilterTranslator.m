//
//  SCFilterTranslator.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import "SCFilterTranslator.h"

@implementation SCFilterTranslator

+ (NSString *)camelCaseToHumanReadable:(NSString *)name {
    NSCharacterSet *uppercaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
    NSMutableString *output = [[NSMutableString alloc] init];
    
    NSUInteger lastFoundUpperCase = 0;
    for (NSUInteger i = 0, count = name.length; i < count; i++) {
        unichar c = [name characterAtIndex:i];
        
        if ([uppercaseSet characterIsMember:c]) {
            NSUInteger len = i - lastFoundUpperCase;
            if (len > 0) {
                NSString *word = [name substringWithRange:NSMakeRange(lastFoundUpperCase, len)];
                [output appendString:word];
                [output appendString:@" "];
            }
            
            lastFoundUpperCase = i;
        }
    }

    NSUInteger remain = name.length - lastFoundUpperCase;
    if (remain > 0) {
        [output appendString:[name substringWithRange:NSMakeRange(lastFoundUpperCase, name.length - lastFoundUpperCase)]];
    }
    
    return output;
}

+ (NSString *)categoryName:(NSString *)name {
    return [self camelCaseToHumanReadable:[name substringFromIndex:10]];
}

+ (NSString *)filterName:(NSString *)filterName {
    return [self camelCaseToHumanReadable:[filterName substringFromIndex:2]];
}

+ (NSString *)parameterName:(NSString *)parameterName {
    return [parameterName substringFromIndex:5];
}

@end
