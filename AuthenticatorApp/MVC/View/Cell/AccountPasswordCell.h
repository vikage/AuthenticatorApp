//
//  AccountPasswordCell.h
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTPToken.h"

@interface AccountPasswordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

-(void) bindingToken:(OTPToken *) token;
@end

