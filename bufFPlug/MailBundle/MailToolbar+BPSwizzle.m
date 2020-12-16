//
//  MailToolbar+BPSwizzle.m
//  buFPlug
//
//  Created by Andreas Buff on 08.12.20.
//

#import "MailToolbar+BPSwizzle.h"
#import <AppKit/AppKit.h>

NSString* const bpToolbarItemIdentifier = @"bpToolbarItemIdentifier";

@implementation MailToolbar_BP

+ (id)bp__plistForToolbarWithIdentifier:(id)arg1 {
    id ret = [self bp__plistForToolbarWithIdentifier:arg1];

    if(![arg1 isEqualToString:@"MainWindow"])
        return ret;

    NSMutableDictionary *configuration = [ret mutableCopy];
    NSMutableArray *defaultSet = [configuration[@"default set"] mutableCopy];
    if (![defaultSet containsObject:bpToolbarItemIdentifier]) {
        [defaultSet addObject:bpToolbarItemIdentifier];
        [configuration setObject:defaultSet forKey:@"default set"];
    }

    return configuration;
}

@end
