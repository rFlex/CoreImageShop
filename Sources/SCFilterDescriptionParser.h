//
//  SCFilterDescriptionParser.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <Foundation/Foundation.h>
#import "SCFilterDescriptionList.h"

@interface SCFilterDescriptionParser : NSObject

@property (strong, nonatomic) NSURL *fileUrl;

@property (readonly, nonatomic) SCFilterDescriptionList *filterDescriptionList;
@property (readonly, nonatomic) NSError *error;

- (BOOL)parse;

@end
