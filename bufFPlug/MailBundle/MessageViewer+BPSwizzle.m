////
////  MessageViewer+BPSwizzle.m
////  buFPlug
////
////  Created by Andreas Buff on 08.12.20.
////
#import "MessageViewer+BPSwizzle.h"

#import <AppKit/AppKit.h>
#import "MailToolbar+BPSwizzle.h"


@implementation MessageViewer_BP

- (NSToolbarItem *)bp_toolbar:(NSToolbar *)arg1 itemForItemIdentifier:(NSString *)arg2 willBeInsertedIntoToolbar:(BOOL)arg3 {
    if (![arg2 isEqualToString:bpToolbarItemIdentifier]) {
        return [self bp_toolbar:arg1 itemForItemIdentifier:arg2 willBeInsertedIntoToolbar:arg3];
    }
    // Make sure our toolbar item was not already added
    for(NSToolbarItem *item in [arg1 items]) {
        if([item.itemIdentifier isEqualToString:bpToolbarItemIdentifier])
            return nil;
    }

    NSSize toolbarItemSize = NSMakeSize(75.0, 23.0);
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:bpToolbarItemIdentifier];
    //    [item setView:securityMethodAccessoryView];
    item.title = @"Feature 1";
    item.minSize = toolbarItemSize;

    item.target = self;
    item.action = @selector(toolbarItemAction:);
    return item;
}

- (void)toolbarItemAction:(id *)sender {
    NSLog(@"Clicked!");
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Feature 1";
    alert.informativeText = @"Done!";
    [alert addButtonWithTitle:@"Check"];
    [alert runModal];
}

- (NSArray *)bp_toolbarAllowedItemIdentifiers:(NSToolbar *)arg1 {
    NSMutableArray *allowedIdentifiers = [self bp_toolbarAllowedItemIdentifiers:arg1].mutableCopy;
    if (![allowedIdentifiers containsObject:bpToolbarItemIdentifier]) {
        // Only if not in already
        [allowedIdentifiers addObject:bpToolbarItemIdentifier];
    }
    return allowedIdentifiers;
}

- (void)bp_toolbarWillAddItem:(NSNotification *)arg1 {
    NSToolbarItem *item = arg1.userInfo[@"item"];
    if ([item.itemIdentifier isEqualToString:bpToolbarItemIdentifier]) {
        // We might get a handle on it here to update it later
    }
    [self bp_toolbarWillAddItem:arg1];
}
@end
