//
//     Generated by class-dump 3.5 (64 bit) (Debug version compiled Jun  9 2015 22:53:21).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2014 by Steve Nygard.
//

//#import <objc/NSObject.h>

#import "MCAttachmentDataSource-Protocol.h"
//#import <MailCore/NSURLSessionDownloadDelegate-Protocol.h>

@class NSDate, NSError, NSNumber, NSPort, NSProgress, NSString, NSURL;

@interface MCRemoteURLAttachmentDataSource : NSObject <NSURLSessionDownloadDelegate, MCAttachmentDataSource>
{
    BOOL _isAutoArchiveAttachment;
    BOOL _isMailDropIndividualImage;
    BOOL _isMailDropImageArchive;
    NSProgress *_downloadProgress;
    NSURL *_remoteURL;
    NSPort *_downloadPort;
    NSError *_downloadError;
    NSNumber *_fileSize;
    NSDate *_downloadURLExpiration;
    NSURL *_attachmentsDirectory;
    /* FIXME: CDUnknownBlockType -> id */
    id _fileWrapperCompletionBlock;
    NSString *_filename;
    NSString *_preferredFilename;
}

@property(readonly, copy, nonatomic) NSString *preferredFilename; // @synthesize preferredFilename=_preferredFilename;
@property(readonly, copy, nonatomic) NSString *filename; // @synthesize filename=_filename;
/* FIXME: CDUnknownBlockType -> id */
@property(copy, nonatomic) id fileWrapperCompletionBlock; // @synthesize fileWrapperCompletionBlock=_fileWrapperCompletionBlock;
@property(readonly, nonatomic) NSURL *attachmentsDirectory; // @synthesize attachmentsDirectory=_attachmentsDirectory;
@property(readonly, nonatomic) BOOL isMailDropImageArchive; // @synthesize isMailDropImageArchive=_isMailDropImageArchive;
@property(readonly, nonatomic) BOOL isMailDropIndividualImage; // @synthesize isMailDropIndividualImage=_isMailDropIndividualImage;
@property(readonly, nonatomic) BOOL isAutoArchiveAttachment; // @synthesize isAutoArchiveAttachment=_isAutoArchiveAttachment;
@property(readonly, nonatomic) NSDate *downloadURLExpiration; // @synthesize downloadURLExpiration=_downloadURLExpiration;
@property(readonly, nonatomic) NSNumber *fileSize; // @synthesize fileSize=_fileSize;
@property(retain, nonatomic) NSError *downloadError; // @synthesize downloadError=_downloadError;
@property(readonly, nonatomic) NSPort *downloadPort; // @synthesize downloadPort=_downloadPort;
@property(retain, nonatomic) NSURL *remoteURL; // @synthesize remoteURL=_remoteURL;
@property(retain, nonatomic) NSProgress *downloadProgress; // @synthesize downloadProgress=_downloadProgress;
//- (void).cxx_destruct;
- (void)URLSession:(id)arg1 task:(id)arg2 didCompleteWithError:(id)arg3;
- (void)URLSession:(id)arg1 downloadTask:(id)arg2 didWriteData:(long long)arg3 totalBytesWritten:(long long)arg4 totalBytesExpectedToWrite:(long long)arg5;
- (void)_persistDownloadedFileWrapper:(id)arg1 originalContentsURL:(id)arg2;
- (void)URLSession:(id)arg1 downloadTask:(id)arg2 didFinishDownloadingToURL:(id)arg3;
- (void)_downloadRemoteAttachment;
- (BOOL)_isExpired;
@property(readonly, nonatomic) BOOL isDirectory;
@property(readonly, nonatomic) BOOL canResultsBeCached;
@property(readonly, nonatomic) BOOL dataIsLocallyAvailable;
- (unsigned long long)approximateSizeForAccessLevel:(long long)arg1;
/* FIXME: CDUnknownBlockType -> id */
- (void)fileWrapperForAccessLevel:(long long)arg1 completionBlock:(id)arg2;
/* FIXME: CDUnknownBlockType -> id */
- (void)dataForAccessLevel:(long long)arg1 completionBlock:(id)arg2;
@property(readonly, copy) NSString *debugDescription;
- (id)_remoteDownloadQueue;
- (void)dealloc;
- (id)init;
- (id)initWithAttachment:(id)arg1 attachmentsDirectory:(id)arg2;
- (id)initWithRemoteURL:(id)arg1;

// Remaining properties
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end
