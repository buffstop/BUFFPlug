////
////  MessageViewer+BPSwizzle.h
////  buFPlug
////
////  Created by Andreas Buff on 08.12.20.
////

#import <Foundation/Foundation.h>

#import "MCMessageHeaders.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageViewer_BP : NSObject

+ (void)updateOurToolbarItemWithHeaders:(MCMessageHeaders*)newHeaders;

@end

NS_ASSUME_NONNULL_END
