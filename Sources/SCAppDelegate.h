//
//  SCAppDelegate.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <Cocoa/Cocoa.h>
#define kLastSavedFilterFileUrlKey @"LastSavedFilterFileUrl"

@interface SCAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (weak) IBOutlet NSMenu *filtersMenu;
- (IBAction)changeFilterDescriptionFile:(id)sender;
- (IBAction)reloadFileDescriptionFile:(id)sender;

@end
