//
//  ConversationMember-BPSwizzle.m
//  bufFPlug
//
//  Created by Andreas Buff on 16.12.20.
//

#import "ConversationMember-BPSwizzle.h"

#import "MCMessageHeaders.h"
#import "MessageViewer+BPSwizzle.h"

@implementation ConversationMember_BP

- (MCMessageHeaders *)bp_headers{
    MCMessageHeaders *headers = [self bp_headers];
    if (headers.allHeaderKeys.count > 3) {
        [MessageViewer_BP updatePopoverWithHeaders:headers];
    }

    return [self bp_headers];
}

@end
