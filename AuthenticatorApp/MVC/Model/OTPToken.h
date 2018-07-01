//
//  OTPToken.h
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTPToken : NSObject
@property (nonatomic, strong) NSString *issuer;
@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *accountName;

-(instancetype) initWithAccountName:(NSString *)accountName secret:(NSString *)secret issuer:(NSString *)issuer;
-(NSDictionary *) toDictionary;
-(NSString *) currentPassword;
@end
