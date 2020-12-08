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

NSString * const kMessageHeaders = @"MessageHeaders";
NSString * const kMessageBody = @"MessageBody";

typedef NSDictionary<NSString *, NSString *> HeadersDictionary;
typedef NSMutableDictionary<NSString *, NSString *> MutableHeadersDictionary;

@class ECMimePart;

@implementation BPMCMessage

+ (void)load {
    [self transferSubclassesFromSuperclass];
}

/// Overwriten method. This method is called several times after the user selected a certain mail in
/// the list of mails. Returns the headers related to the message.
/// @param arg1 Fetch the remaining data if not present
/// @return The headers as MCMessageHeaders
- (id)headersFetchIfNotAvailable:(BOOL)arg1 {
    // Call super if other actions are taking place
    [super headersFetchIfNotAvailable:arg1];

    if (!mcHeadersForMcMessge[self]) {
        mcHeadersForMcMessge[self] = [self getHeaders];
    }
    MCMessageHeaders *messageHeaders = mcHeadersForMcMessge[self];

    return messageHeaders;
}

- (MCMessageHeaders *)getHeaders {
    NSData *allMessageData = [self messageDataFetchIfNotAvailable:YES newDocumentID:nil];
    MCMimePart *topLevelMimePart = [[MCMimePart alloc] initWithEncodedData:allMessageData];
    [topLevelMimePart parse];

    //    MCMessageBody *messageBody = [topLevelMimePart messageBody];

    MCMessageHeaders *messageHeaders = [[MCMessageHeaders alloc]
                                        initWithHeaderData:topLevelMimePart.headerData
                                        encodingHint:0];
    return  messageHeaders;
}

/// Overwriten method. This method is called several times after the user selected a certain mail in
/// the list of mails. Returns the body related to the message.
/// @param arg1 Fetch the remaining data if not present
/// @param arg2 Update the message flags
/// @param arg3 Allows getting partial data from the body. Not 100%, but related with data from
/// attachments
/// @param arg4 New in 10.15. I don't know exactly what it does.
/// @return The body as MCMessageBody
//- (id)bodyFetchIfNotAvailable:(BOOL)arg1
//                  updateFlags:(BOOL)arg2
//                 allowPartial:(BOOL)arg3
//    skipSignatureVerification:(BOOL)arg4 {
//    [super bodyFetchIfNotAvailable:arg1
//                       updateFlags:arg2
//                      allowPartial:arg3
//         skipSignatureVerification:arg4];
//
////    // Call once
////    if (!currentMessageheaders) {
////        [self getCompleteMessage];
////    }
////
////    // Get from ivar
////    MCMessageBody *body = (MCMessageBody *)[self getIvar:kMessageBody];
////
////    return body;
//}



//- (MCMessageHeaders *)mcMessageHearders {
//    NSData *allMessageData = [self messageDataFetchIfNotAvailable:YES newDocumentID:nil];
//    MCMimePart *topLevelMimePart = [[MCMimePart alloc] initWithEncodedData:allMessageData];
//    [topLevelMimePart parse];
//
////    MCMessageBody *messageBody = [topLevelMimePart messageBody];
//
//    MCMessageHeaders *messageHeaders = [[MCMessageHeaders alloc]
//                                        initWithHeaderData:topLevelMimePart.headerData
//                                        encodingHint:0];
//    return messageHeaders;
//}

///// Functions that tries to mimic the future process:
/////  - MCMessage -> pEpMessage -> pEp Engine -> new pEpMessage -> new MCMessage
//- (void)decrypt {
//
//    // Get the whole  message
//    PEPMessage encryptedMessage = [self allEncryptedMessage];
//
//    //Headers as a key/value:string/string
//    HeadersDictionary *headersDictionary = [encryptedMessage.headers headersDictionary];
//
//    // Decrypt
//    PEPMessage decryptedMessage = [self decryptMessageFromPEPEngine:encryptedMessage];
//
//    // EngineMessage -> MCMessage
//    [self setingIvarsFromDecryptedMessage:decryptedMessage];
//}




/// Retrieves the whole message
/// @return The whole message as PEPMessage
//- (PEPMessage)allEncryptedMessage {
//    NSData *allMessageData = [self messageDataFetchIfNotAvailable:YES newDocumentID:nil];
//    MCMimePart *topLevelMimePart = [[MCMimePart alloc] initWithEncodedData:allMessageData];
//    [topLevelMimePart parse];
//
//    MCMessageBody *messageBody = [topLevelMimePart messageBody];
//
//    MCMessageHeaders *messageHeaders = [[MCMessageHeaders alloc]
//                                        initWithHeaderData:topLevelMimePart.headerData
//                                        encodingHint:0];
//
//    PEPMessage encryptedMessage = { messageHeaders, messageBody };
//
//    return encryptedMessage;
//}


///// Modifies the body and the headers of the message, trying to simulate a message that comes from
///// the pEp engine
///// @param encryptedMessage The whole message as PEPMessage
///// @return The simulated message returned from the pEp engine.
//- (PEPMessage)decryptMessageFromPEPEngine:(PEPMessage)encryptedMessage {
//    PEPMessage decryptedMessage;
//
//    MCMessageBody *messageBody = encryptedMessage.body;
//    NSMutableString *newLMF = [NSMutableString stringWithString:@"<h3>I have all the message</h3>"];
//    if (messageBody) {
//        [newLMF appendString:messageBody.html];
//    }
//    messageBody.html = newLMF;
//    decryptedMessage.body = messageBody;
//
//    MCMutableMessageHeaders *messageHeaders = [encryptedMessage.headers mutableCopy];
//    /// Remove header
//    [messageHeaders removeHeaderForKey:@"x-google-smtp-source"];
//    /// Add header
//    [messageHeaders setHeader:@"PEP Rules" forKey:@"pep-awesome-header"];
//    /// Modify header
//    [messageHeaders setHeader:@"mail@pep.rules" forKey:@"return-path"];
//    NSString *originalSubject = [messageHeaders firstHeaderForKey:@"subject"];
//    [messageHeaders
//     setHeader:[NSString stringWithFormat:@"%@ - PEPMessage", originalSubject]
//     forKey:@"subject"];
//
//    originalSubject = self.subject.subjectString;
//    ECSubject *newSubject = [ECSubject subjectWithString:
//                             [NSString stringWithFormat:@"%@ - PEPList", originalSubject]];
//    [self setSubject:newSubject];
//
//    decryptedMessage.headers = [messageHeaders copy];
//
//    return decryptedMessage;
//}
//
//
///// Setting the ivars to use them later
///// @param decryptedMessage The simulated message returned from the pEp engine.
//- (void)setingIvarsFromDecryptedMessage:(PEPMessage)decryptedMessage {
//    [self setIvar:kMessageHeaders value:decryptedMessage.headers assign:NO];
//    [self setIvar:kMessageBody value:decryptedMessage.body assign:NO];
//}
//
//// MARK: - Private methods
//
///// Transforms a boolean to its string representation
///// @param theBoolean The boolean
///// @return The string representation
//- (NSString *)stringFromBoolean:(BOOL)theBoolean {
//    return theBoolean ? @"YES" : @"NO";
//}

@end
