//
//  Utils.m
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(NSString *) getTokenFilePath
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    if (documentPath)
    {
        NSString *filePath = [documentPath stringByAppendingPathComponent:@"tokens.plist"];
        
        return filePath;
    }
    
    return nil;
}

+(void)saveListToken:(NSArray *)listToken
{
    NSMutableDictionary *writableDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *writableList = [[NSMutableArray alloc] init];
    for (OTPToken *token in listToken) {
        [writableList addObject:token.toDictionary];
    }
    
    [writableDict setObject:writableList forKey:@"tokens"];
    
    NSString *filePath = [self getTokenFilePath];
    [writableDict writeToFile:filePath atomically:YES];
}

+(NSMutableArray<OTPToken *> *)getListToken
{
    NSString *filePath = [self getTokenFilePath];
    NSDictionary *tokenDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    NSMutableArray *listToken = [[NSMutableArray alloc] init];
    NSArray *tokens = [tokenDict objectForKey:@"tokens"];
    for (NSDictionary *item in tokens)
    {
        NSString *accountName = [item objectForKey:@"accountName"];
        NSString *secret = [item objectForKey:@"secret"];
        NSString *issuer = [item objectForKey:@"issuer"];
        
        OTPToken *token = [[OTPToken alloc] initWithAccountName:accountName secret:secret issuer:issuer];
        [listToken addObject:token];
    }
    
    return listToken;
}

+(void)generateHapticFeedbackWithType:(UINotificationFeedbackType)type
{
    UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
    [generator notificationOccurred:type];
}
@end
