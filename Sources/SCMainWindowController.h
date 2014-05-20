//
//  SCMainWindowController.h
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <Cocoa/Cocoa.h>
#import "SCMediaDisplayerView.h"
#import "SCFilter.h"

@interface SCMainWindowController : NSWindowController<NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate, SCFilterDelegate>

@property (weak) IBOutlet NSTableView *filtersTableView;

@property (weak) IBOutlet SCMediaDisplayerView *mediaDisplayerView;
@property (readonly, nonatomic) NSArray *filters;

- (void)addFilter:(SCFilter *)filter;
- (void)removeFilter:(SCFilter *)filter;
- (IBAction)deleteActivated:(NSButton *)sender;

@end
