//
//  SCFilterConfiguratorWindowController.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 19/05/14.
//
//

#import <Cocoa/Cocoa.h>
#import <SCRecorderMac/SCRecorderMac.h>

@interface SCFilterConfiguratorWindowController : NSWindowController<NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *parametersTableView;
@property (strong, nonatomic) SCFilter *filter;
@property (weak) IBOutlet NSScrollView *parametersScrollView;

- (void)refreshSettingsValue;

@end
