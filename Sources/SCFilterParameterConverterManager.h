//
//  SCFilterParameterConverterManager.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import <Foundation/Foundation.h>
#import "SCFilterParameterConverter.h"
#import <SCRecorderMac/SCRecorderMac.h>

@interface SCFilterParameterConverterManager : NSObject

- (void)addParameterConverter:(SCFilterParameterConverter *)converter forParameterType:(NSString *)parameterType;

- (SCFilterParameterConverter *)converterForParameterDescription:(SCFilterParameterDescription *)parameterDescription;
- (SCFilterParameterConverter *)converterForParameterType:(NSString *)parameterType;

+ (SCFilterParameterConverterManager *)sharedInstance;

@end
