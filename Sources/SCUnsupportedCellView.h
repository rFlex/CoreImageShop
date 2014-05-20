//
//  SCUnsupportedCellView.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import <Cocoa/Cocoa.h>
#import "SCFilterParameterConfigurationCellView.h"

@interface SCUnsupportedCellView : SCFilterParameterConfigurationCellView

@property (weak) IBOutlet NSTextField *errorTextField;

@end
