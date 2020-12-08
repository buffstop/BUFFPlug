//
//  BPMailBundle.h
//  bufFPlug
//
//  Created by Andreas Buff on 07.12.20.

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

#import "MCMessage.h"
#import "MCMessageHeaders.h"

static NSToolbarItem * _Nonnull ourToolbarItem;

NS_ASSUME_NONNULL_BEGIN

@interface BPMailBundle : NSObject

@end

#pragma mark - Singleton

@interface BPMailBundle (NoImplementation)
// Prevent "incomplete implementation" warning.
+ (id)sharedInstance;
@end

NS_ASSUME_NONNULL_END
