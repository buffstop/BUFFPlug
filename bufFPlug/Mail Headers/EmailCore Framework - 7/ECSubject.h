//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

//#import "NSObject.h"

//#import "EFPubliclyDescribable.h"
//#import "NSCopying.h"
//#import "NSSecureCoding.h"

@class NSString;
@protocol EFPubliclyDescribable;

@interface ECSubject : NSObject <NSCopying, NSSecureCoding, EFPubliclyDescribable>
{
    long long _hasReplyPrefixState;
    BOOL _hasPrefix;
    unsigned long long _length;
    NSString *_prefix;
    unsigned long long _prefixLength;
    NSString *_subjectWithoutPrefix;
}

+ (BOOL)supportsSecureCoding;
+ (id)_uniqueString:(id)arg1 type:(long long)arg2;
+ (id)_prefixTruncatedToMaximumAllowableSize:(id)arg1;
+ (id)_subjectTruncatedToMaximumAllowableSize:(id)arg1;
+ (id)subjectWithString:(id)arg1;
@property(readonly, nonatomic) BOOL hasPrefix; // @synthesize hasPrefix=_hasPrefix;
@property(copy, nonatomic) NSString *subjectWithoutPrefix; // @synthesize subjectWithoutPrefix=_subjectWithoutPrefix;
@property(readonly, nonatomic) unsigned long long prefixLength; // @synthesize prefixLength=_prefixLength;
@property(copy, nonatomic) NSString *prefix; // @synthesize prefix=_prefix;
@property(readonly, nonatomic) unsigned long long length; // @synthesize length=_length;
//- (void).cxx_destruct;
- (BOOL)isEqualToSubjectIgnoringPrefix:(id)arg1;
- (BOOL)isEqualToString:(id)arg1;
- (BOOL)isEqualToSubject:(id)arg1;
@property(readonly, nonatomic) BOOL hasReplyPrefix;
@property(readonly, copy, nonatomic) NSString *subjectString;
- (id)copyWithZone:(struct _NSZone *)arg1;
@property(readonly, copy, nonatomic) NSString *ef_publicDescription;
@property(readonly, copy) NSString *description;
@property(readonly, copy) NSString *debugDescription;
- (BOOL)isEqual:(id)arg1;
@property(readonly) unsigned long long hash;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)init;
- (id)initWithPrefix:(id)arg1 subjectWithoutPrefix:(id)arg2;
- (id)initWithString:(id)arg1;

// Remaining properties
@property(readonly) Class superclass;

@end

