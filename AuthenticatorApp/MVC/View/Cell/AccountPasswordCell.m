//
//  AccountPasswordCell.m
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import "AccountPasswordCell.h"

@implementation AccountPasswordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)bindingToken:(OTPToken *)token
{
    self.passwordLabel.text = [self formatPassword:[token currentPassword]];
    
    NSMutableAttributedString *accountNameAtt = [[NSMutableAttributedString alloc] init];
    [accountNameAtt appendAttributedString:[[NSAttributedString alloc] initWithString:[token.issuer stringByAppendingString:@" "] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    [accountNameAtt appendAttributedString:[[NSAttributedString alloc] initWithString:token.accountName attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15 weight:UIFontWeightLight],NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    self.accountNameLabel.attributedText = accountNameAtt;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.passwordLabel.alpha = editing ? 0.2 : 1;
    }];
}

-(NSString *) formatPassword:(NSString *)origin
{
    if (origin.length < 6) {
        return origin;
    }
    
    return [NSString stringWithFormat:@"%@ %@", [origin substringToIndex:3], [origin substringFromIndex:3]];
}

@end
