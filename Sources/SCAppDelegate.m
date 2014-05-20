//
//  SCAppDelegate.m
//  CoreImageShop
//
//  Created by Simon CORSIN on 16/05/14.
//
//

#import <AVFoundation/AVFoundation.h>
#import "SCAppDelegate.h"
#import "SCFilterDescriptionParser.h"
#import "SCFilterTranslator.h"
#import "SCMainWindowController.h"
#import "SCFilterCodeGenerator.h"

#define kFilterDescriptionFileUrlKey @"FilterDescriptionFileUrl"

@interface SCAppDelegate() {
    SCFilterDescriptionList *_filterDescriptions;
    SCMainWindowController *_mainVC;
    NSURL *_filterDescriptionURL;
}

@end

@implementation SCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:kFilterDescriptionFileUrlKey];
    
    if (url != nil) {
        [self openFilterDescriptions:[NSURL URLWithString:url]];
    }
    
    [self openProject];
}

- (void)openProject {
    SCMainWindowController *mainViewController = [[SCMainWindowController alloc] initWithWindowNibName:@"SCMainWindowController"];
    [mainViewController showWindow:nil];
    _mainVC = mainViewController;
}

- (IBAction)exportCode:(id)sender {
    if (_mainVC != nil) {
        NSSavePanel *savePen = [NSSavePanel savePanel];
    
        NSComboBox *comboBox = [[NSComboBox alloc] init];
        comboBox.frame = CGRectMake(0, 0, 70, 25);
        [comboBox addItemWithObjectValue:@"iOS"];
        [comboBox addItemWithObjectValue:@"OSX"];
        [comboBox selectItemAtIndex:0];
        [comboBox sizeToFit];
        
        savePen.accessoryView = comboBox;
        
        [savePen beginWithCompletionHandler:^(NSInteger result) {
            if (result == NSOKButton) {
                NSURL *url = savePen.URL;
                
                NSString *fileName = [url.lastPathComponent stringByDeletingPathExtension];
                
                SCFilterCodeGenerator *codeGenerator = [[SCFilterCodeGenerator alloc] init];
                codeGenerator.filters = _mainVC.filters;
                
                if ([comboBox.stringValue isEqualToString:@"OSX"]) {
                    codeGenerator.outputSystem = FilterCodeGeneratorOutputSystemMac;
                } else {
                    codeGenerator.outputSystem = FilterCodeGeneratorOutputSystemIOS;
                }
                
                [codeGenerator generateCode:fileName];
                [codeGenerator saveTo:url];
            }
        }];
    }
}

- (void)updateForFilterDescriptions:(SCFilterDescriptionList *)descriptionFilter {
    for (NSMenuItem *menuItem in self.filtersMenu.itemArray) {
        if (menuItem.isSeparatorItem) {
            break;
        }
        [self.filtersMenu removeItem:menuItem];
    }
    
    _filterDescriptions = descriptionFilter;
    
    for (NSString *category in descriptionFilter.allCategories) {
        NSString *categoryTitle = [SCFilterTranslator categoryName:category];
        NSMenuItem *categoryMenuItem = [[NSMenuItem alloc] initWithTitle:categoryTitle action:nil keyEquivalent:@""];
        
        NSMenu *menu = [[NSMenu alloc] initWithTitle:category];
        categoryMenuItem.submenu = menu;
        
        NSUInteger index = 0;
        for (SCFilterDescription *filter in [descriptionFilter filterDescriptionsForCategory:category]) {
            NSMenuItem *filterItem = [[NSMenuItem alloc] initWithTitle:filter.localizedName action:nil keyEquivalent:@""];
            
            filterItem.tag = filter.filterId;
            filterItem.target = self;
            filterItem.action = @selector(addFilterFired:);
            
            [menu addItem:filterItem];
        }
        
        [self.filtersMenu insertItem:categoryMenuItem atIndex:index++];
    }
}

- (void)addFilterFired:(NSMenuItem *)item {
    SCFilterDescription *filterDescription = [_filterDescriptions filterDescriptionForId:item.tag];
    
    SCFilter *filter = [SCFilter filterWithFilterDescription:filterDescription];
    
    if (filter != nil) {
        [_mainVC addFilter:filter];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Unable to add filter" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Filter %@ not found in system", filterDescription.name];
        [alert runModal];
    }
}

- (void)openFilterDescriptions:(NSURL *)fileUrl {
    SCFilterDescriptionParser *parser = [[SCFilterDescriptionParser alloc] init];
    parser.fileUrl = fileUrl;
    
    if ([parser parse]) {
        SCFilterDescriptionList *descriptionFilter = parser.filterDescriptionList;

        [self updateForFilterDescriptions:descriptionFilter];
        [[NSUserDefaults standardUserDefaults] setObject:fileUrl.absoluteString forKey:kFilterDescriptionFileUrlKey];
        
        _filterDescriptionURL = fileUrl;
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:@"Failed to open filter descriptions file" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Error: %@", parser.error.localizedDescription];
        [alert runModal];
    }

}

- (IBAction)changeFilterDescriptionFile:(id)sender {
    NSOpenPanel *open = [NSOpenPanel openPanel];
    
    open.canChooseDirectories = NO;
    open.allowedFileTypes = @[@"cis"];
    open.allowsMultipleSelection = NO;
    
    if (_filterDescriptionURL != nil) {
        open.directoryURL = _filterDescriptionURL;
    }
    
    [open beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *url = open.URL;
            [self openFilterDescriptions:url];
        }
    }];
}

- (IBAction)reloadFileDescriptionFile:(id)sender {
    if (_filterDescriptionURL != nil) {
        [self openFilterDescriptions:_filterDescriptionURL];        
    }
}
@end
