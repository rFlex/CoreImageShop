//
//  SCAppDelegate.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <Cocoa/Cocoa.h>

@interface SCAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSMenu *filtersMenu;
- (IBAction)changeFilterDescriptionFile:(id)sender;
- (IBAction)reloadFileDescriptionFile:(id)sender;

@end
