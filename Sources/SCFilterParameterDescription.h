//
//  SCFilterParameter.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <Foundation/Foundation.h>

@interface SCFilterParameterDescription : NSObject

@property (readonly, nonatomic) NSString *name;
@property (readonly, nonatomic) NSString *localizedName;
@property (copy, nonatomic) NSString *type;
@property (strong, nonatomic) id minValue;
@property (strong, nonatomic) id maxValue;

@property (readonly, nonatomic) double minValueAsDouble;
@property (readonly, nonatomic) double maxValueAsDouble;

- (id)initWithName:(NSString *)name;

@end
