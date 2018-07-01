//
//  ScanQRCodeViewController.h
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTPToken.h"
@protocol ScanQRCodeViewControllerDelegate;

@interface ScanQRCodeViewController : UIViewController
@property (nonatomic, weak) id<ScanQRCodeViewControllerDelegate> delegate;
@end


@protocol ScanQRCodeViewControllerDelegate <NSObject>

-(void) scanQRCodeController:(ScanQRCodeViewController *)controller didAddToken:(OTPToken *)token;

@end
