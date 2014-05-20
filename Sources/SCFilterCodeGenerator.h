//
//  SCFilterCodeGenerator.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FilterCodeGeneratorOutputSystemIOS,
    FilterCodeGeneratorOutputSystemMac
} FilterCodeGeneratorOutputSystem;

@interface SCFilterCodeGenerator : NSObject

@property (strong, nonatomic) NSArray *filters;
@property (readonly, nonatomic) NSString *generatedHeaderCode;
@property (readonly, nonatomic) NSString *generatedImplementationCode;
@property (assign, nonatomic) FilterCodeGeneratorOutputSystem outputSystem;

- (void)generateCode:(NSString *)filterName;
- (void)saveTo:(NSURL *)url;

@end
