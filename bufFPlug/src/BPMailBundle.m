//
//  BPMailBundle.m
//  bufFPlug
//
//  Created by Andreas Buff on 07.12.20.
//

#import "BPMailBundle.h"

@import ObjectiveC.runtime;
@import AppKit;
#import "MVMailBundle.h"

@implementation BPMailBundle

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"

- (id)init {
    if (self = [super init]) {
        NSLog(@"init");
    }
    return self;
}

+ (void)initialize {

    Class mvMailBundleClass = NSClassFromString(@"MVMailBundle");
    assert(mvMailBundleClass);

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated"
    class_setSuperclass([self class], mvMailBundleClass);
#pragma GCC diagnostic pop

    // Makes sure init() is called.
    [BPMailBundle sharedInstance];

    // Register our plugin bundle in Apple Mail
    [[((MVMailBundle *)self) class] registerBundle];
    NSLog(@"regeistered");
}

@end
