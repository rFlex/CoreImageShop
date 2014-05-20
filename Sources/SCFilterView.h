//
//  SCFilterView.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <Cocoa/Cocoa.h>

@interface SCFilterView : NSTableCellView

@property (assign) IBOutlet NSTextField *title;
@property (weak) IBOutlet NSButton *settingsButton;
@property (weak) IBOutlet NSButton *enabledCheckbox;

@end
