//
//  MailToolbar+BPAdditions.m
//  bufFPlug
//
//  Created by Andreas Buff on 07.12.20.
//

#import "MailToolbar+BPAdditions.h"
#import "BPMailBundle.h"

@implementation MailToolbar_BPAdditions

+ (id)bp_plistForToolbarWithIdentifier:(id)arg1 {
    id ret = [self bp_plistForToolbarWithIdentifier:arg1];

    if(![arg1 isEqualToString:@"ComposeWindow"]) {
        return ret;
    }

    NSMutableDictionary *configuration = [ret mutableCopy];
    NSMutableArray *defaultSet = [configuration[@"default set"] mutableCopy];
    [defaultSet addObject: @"bpToolbarItemIdentifier"];
    [configuration setObject:defaultSet forKey:@"default set"];

    return configuration;
}
@end
