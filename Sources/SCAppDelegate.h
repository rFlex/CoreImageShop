//
//  SCAppDelegate.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <Cocoa/Cocoa.h>
#import <SCRecorderMac/SCRecorderMac.h>
#define kLastSavedFilterFileUrlKey @"LastSavedFilterFileUrl"
#define kFilterDescriptionsChangedNotification @"FilterDescriptionsChanged"

@interface SCAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (weak) IBOutlet NSMenu *filtersMenu;
@property (readonly, nonatomic) SCFilterDescriptionList *filterDescriptions;

- (IBAction)changeFilterDescriptionFile:(id)sender;
- (IBAction)reloadFileDescriptionFile:(id)sender;

+ (SCAppDelegate *)sharedInstance;

@end
