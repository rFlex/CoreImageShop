//
//  SCFilterDescriptionParser.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import "SCFilterDescriptionParser.h"
#import "SCFilterParameterConverterManager.h"

@interface SCFilterDescriptionParser() {
    NSCharacterSet *_letterSet;
    NSScanner *_scanner;
}

@end

@implementation SCFilterDescriptionParser

- (BOOL)parseCategory {
    NSString *category = nil;
    if ([_scanner scanCharactersFromSet:_letterSet intoString:&category]) {
        while ([self parseFilter:category]) {
            
        }
        
        return _error == nil;
    }
    
    return NO;
}

+ (NSError*)createError:(NSString*)errorDescription {
    return [NSError errorWithDomain:@"SCFilterDescriptionParser" code:200 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
}


- (BOOL)parseParameter:(SCFilterDescription *)filterDescription {
    if ([_scanner scanString:@"\t\t" intoString:nil]) {
        NSString *parameter = nil;
        
        if ([_scanner scanCharactersFromSet:_letterSet intoString:&parameter]) {
            SCFilterParameterDescription *parameterDescription = [[SCFilterParameterDescription alloc] initWithName:parameter];
            
            if ([_scanner scanString:@":" intoString:nil]) {
                NSString *type = nil;
                if ([_scanner scanCharactersFromSet:_letterSet intoString:&type]) {
                    parameterDescription.type = type;
                    
                    
                    if ([_scanner scanString:@"(" intoString:nil]) {
                        NSString *valueRange = nil;
                        if ([_scanner scanUpToString:@")\n" intoString:&valueRange]) {
                            if ([_scanner scanString:@")" intoString:nil]) {
                                NSArray *components = [valueRange componentsSeparatedByString:@"->"];
                                
                                if (components.count == 2) {
                                    NSString *minValue = [components objectAtIndex:0];
                                    NSString *maxValue = [components objectAtIndex:1];
                                    
                                    SCFilterParameterConverter *converter = [[SCFilterParameterConverterManager sharedInstance] converterForParameterType:type];
                                    parameterDescription.minValue = [converter convertFromString:minValue];
                                    parameterDescription.maxValue = [converter convertFromString:maxValue];
                                } else {
                                    _error = [SCFilterDescriptionParser createError:@"Expected two identifiers"];
                                }
                            } else {
                                _error = [SCFilterDescriptionParser createError:@"Expected ')' at the end of the line"];
                            }
                        } else {
                            _error = [SCFilterDescriptionParser createError:@"Expected ')' at the end of the line"];
                        }
                    }
                } else {
                    _error = [SCFilterDescriptionParser createError:@"Expected type after ':'"];
                }
            } else {
                _error = [SCFilterDescriptionParser createError:[NSString stringWithFormat:@"Expected a parameter type after %@", parameter ]];
            }
            
            [filterDescription addParameter:parameterDescription];
            
            return _error == nil;
        }
    }
    
    return NO;
}

- (BOOL)parseFilter:(NSString *)category {
    if ([_scanner scanString:@"\t" intoString:nil]) {
        NSString *filterName = nil;
        if ([_scanner scanCharactersFromSet:_letterSet intoString:&filterName]) {
            SCFilterDescription *filterDescription = [[SCFilterDescription alloc] initWithName:filterName andCategory:category];
            
            while ([self parseParameter:filterDescription]) {
                
            }
            
            [_filterDescriptionList addFilterDescription:filterDescription];
            
            return _error == nil;
            
        }
    }
    
    return NO;
}

- (BOOL)parse {
    NSAssert(_fileUrl != nil, @"The file url must be set");
    _error = nil;
    
    NSError *error = nil;
    NSString *fileContent = [NSString stringWithContentsOfURL:_fileUrl encoding:NSUTF8StringEncoding error:&error];
    
    if (error != nil) {
        _error = error;
        return NO;
    }
    
    _scanner = [NSScanner scannerWithString:fileContent];
    _scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@"\n \r"];

    _filterDescriptionList = [[SCFilterDescriptionList alloc] init];
    
    _letterSet = [NSCharacterSet letterCharacterSet];
    while (!_scanner.isAtEnd) {
        if (![self parseCategory]) {
            break;
        }
    }
    
    return YES;
}

@end
