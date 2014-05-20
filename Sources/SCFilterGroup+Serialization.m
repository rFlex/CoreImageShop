//
//  SCFilterGroup+Serialization.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 20/05/14.
//
//

#import "SCFilterGroup+Serialization.h"
#import "SCFilter.h"

@implementation SCFilterGroup (Serialization)

+ (SCFilterGroup *)filterGroupWithSCFilters:(NSArray *)filters {
    SCFilterGroup *filterGroup = [[SCFilterGroup alloc] init];
    for (SCFilter *filter in filters) {
        if (filter.enabled) {
            [filterGroup addFilter:filter.coreImageFilter];
        }
    }
    
    return filterGroup;
}

+ (SCFilterGroup *)filterGroupWithData:(NSData *)data {
    return [SCFilterGroup filterGroupWithSCFilters:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
}

@end
