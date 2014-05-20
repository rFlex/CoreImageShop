//
//  SCFilterGroup+Serialization.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 20/05/14.
//
//

#import "SCFilterGroup.h"

@interface SCFilterGroup (Serialization)

+ (SCFilterGroup *)filterGroupWithSCFilters:(NSArray *)array;

+ (SCFilterGroup *)filterGroupWithData:(NSData *)data;

@end
