//
//  BPMCMessage.m
//  bufFPlug
//
//  Created by Andreas Buff on 08.12.20.
//

#import "BPMCMessage.h"

#import "BPMailBundle.h"

#import "NSObject+ClassInjection.h"
#import "MCMutableMessageHeaders.h"
#import "MCMessageBody.h"
#import "MCMimePart.h"
#import "ECSubject.h"
#import "MessageViewer+BPSwizzle.h"

NSString * const kMessageHeaders = @"MessageHeaders";
NSString * const kMessageBody = @"MessageBody";

typedef NSDictionary<NSString *, NSString *> HeadersDictionary;
typedef NSMutableDictionary<NSString *, NSString *> MutableHeadersDictionary;

@class ECMimePart;

@implementation BPMCMessage

static NSMutableDictionary<MCMessage*,MCMessageHeaders*> * _Nonnull mcHeadersForMcMessge;

+ (void)load {
    [self transferSubclassesFromSuperclass];
}

//- (instancetype)init {
//    if (self = [super init]) {
//        mcHeadersForMcMessge = [NSMutableDictionary new];
//    }
//    return self;
//}
//
///// Overwriten method. This method is called several times after the user selected a certain mail in
///// the list of mails. Returns the headers related to the message.
///// @param arg1 Fetch the remaining data if not present
///// @return The headers as MCMessageHeaders
//- (id)headersFetchIfNotAvailable:(BOOL)arg1 {
//    // Call super if other actions are taking place
//    [super headersFetchIfNotAvailable:arg1];
//
//    if (!mcHeadersForMcMessge[self]) {
//        MCMessageHeaders *headers = [self getHeaders];
//        if (headers) {
//            mcHeadersForMcMessge[self] = headers;
//            [MessageViewer_BP updateOurToolbarItemWithHeaders:headers];
//        } else {
//            assert(false);
//        }
//    }
//    MCMessageHeaders *messageHeaders = mcHeadersForMcMessge[self];
//
//    return messageHeaders;
//}
//
//- (MCMessageHeaders *)getHeaders {
//    NSData *allMessageData = [self messageDataFetchIfNotAvailable:YES newDocumentID:nil];
//    MCMimePart *topLevelMimePart = [[MCMimePart alloc] initWithEncodedData:allMessageData];
//    [topLevelMimePart parse];
//
//    //    MCMessageBody *messageBody = [topLevelMimePart messageBody];
//
//    MCMessageHeaders *messageHeaders = [[MCMessageHeaders alloc]
//                                        initWithHeaderData:topLevelMimePart.headerData
//                                        encodingHint:0];
//    return  messageHeaders;
//}

@end
