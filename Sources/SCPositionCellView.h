//
//  SCPositionCellView.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import "SCFilterParameterConfigurationCellView.h"

@interface SCPositionCellView : SCFilterParameterConfigurationCellView

@property (weak) IBOutlet NSButton *editButton;
@property (weak) IBOutlet NSTextField *xTextField;
@property (weak) IBOutlet NSTextField *yTextField;

@end
