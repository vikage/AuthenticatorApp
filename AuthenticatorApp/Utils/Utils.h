//
//  Utils.h
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface Utils : NSObject
+(void) saveListToken:(NSArray *)listToken;
+(NSMutableArray<OTPToken *> *) getListToken;
+(void) generateHapticFeedbackWithType:(UINotificationFeedbackType)type;
@end
