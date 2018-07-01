//
//  OTPToken.m
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import "OTPToken.h"
#import <Base32/MF_Base32Additions.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation OTPToken
-(instancetype)initWithAccountName:(NSString *)accountName secret:(NSString *)secret issuer:(NSString *)issuer
{
    self = [super init];
    
    self.accountName = accountName;
    self.secret = secret;
    self.issuer = issuer;
    
    return self;
}

-(NSDictionary *)toDictionary
{
    return @{@"accountName":self.accountName,@"secret":self.secret, @"issuer":self.issuer};
}

-(NSString *)currentPassword
{
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    u_int64_t timeInput = currentTime/30;
    timeInput = NSSwapHostLongLongToBig(timeInput);
    
    NSData *secretData = [NSData dataWithBase32String:[self.secret uppercaseString]];
    NSData *counterData = [NSData dataWithBytes:&timeInput length:sizeof(NSInteger)];
    
    unsigned char ptr[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, secretData.bytes, secretData.length, counterData.bytes, counterData.length, ptr);
    unsigned int offset = ptr[CC_SHA1_DIGEST_LENGTH-1] & 0x0f;
    unsigned int truncatedHash = NSSwapBigIntToHost(*((unsigned int *)&ptr[offset])) & 0x7fffffff;
    unsigned int pinValue = truncatedHash % 1000000;
    
    return [NSString stringWithFormat:@"%06d",pinValue];
}

-(BOOL)isEqual:(OTPToken *)object
{
    return [object.secret isEqualToString:self.secret];
}
@end
