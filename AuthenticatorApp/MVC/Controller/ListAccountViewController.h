//
//  ListAccountViewController.h
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressRingView.h"
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ListAccountViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *listAccountTableView;
@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITextField *searchInputTextField;
@property (weak, nonatomic) IBOutlet ProgressRingView *progressRingView;

// IBACTION
-(IBAction) addAccountButtonDidTap:(UIButton *)sender;
-(IBAction) editButtonDidTap:(id)sender;
@end

NS_ASSUME_NONNULL_END
