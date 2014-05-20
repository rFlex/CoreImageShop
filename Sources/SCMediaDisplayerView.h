//
//  SCMediaDisplayerView.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <Cocoa/Cocoa.h>
#import "SCFilterGroup.h"

#define kMediaDisplayerClickNotification @"MediaDisplayerClicked"
#define kMediaDisplayerClickLocationKey @"MediaDisplayerClickLocation"

@interface SCMediaDisplayerView : NSView

@property (strong, nonatomic) NSURL *mediaUrl;
@property (readonly, nonatomic) NSError *error;
@property (strong, nonatomic) SCFilterGroup *filterGroup;

@end
