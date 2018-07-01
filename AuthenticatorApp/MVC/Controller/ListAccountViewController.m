//
//  ListAccountViewController.m
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import "ListAccountViewController.h"
#import "ScanQRCodeViewController.h"
#import "AccountPasswordCell.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface ListAccountViewController ()<ScanQRCodeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *listToken;
@property (nonatomic,strong) NSMutableArray *listTokenFiltered;
@end

@implementation ListAccountViewController
{
    NSTimer *timerRefreshProgress;
    UIVisualEffectView *blurEffectView;
    
    BOOL isFiltering;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self config];
}

-(void)viewWillFirstAppear
{
    [self showAuthenticate];
}

#pragma mark - Config
-(void) config
{
    self.listToken = [Utils getListToken];
    
    [self.listAccountTableView registerNib:[UINib nibWithNibName:@"AccountPasswordCell" bundle:nil] forCellReuseIdentifier:@"AccountPasswordCell"];
    
    self.listAccountTableView.dataSource = self;
    self.listAccountTableView.delegate = self;
    [self.listAccountTableView reloadData];
    
    self.searchContainerView.layer.cornerRadius = 8;
    self.searchContainerView.layer.masksToBounds = YES;
    self.searchInputTextField.delegate = self;
    [self.searchInputTextField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self refreshProgressRingViewProgress];
    [self startTimer];
    [self registerNotifications];
}

-(void) refreshProgressRingViewProgress
{
    NSDate *currentDate = [NSDate date];
    NSInteger currentTimeStamp = currentDate.timeIntervalSince1970;
    NSInteger remainder = currentTimeStamp % 30;
    
    CGFloat currentProgress = (CGFloat)remainder/30;
    self.progressRingView.progress = currentProgress;
    
    if (remainder == 0)
    {
        [self.listAccountTableView reloadData];
    }
}

-(void) startTimer
{
    timerRefreshProgress = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self refreshProgressRingViewProgress];
    }];
}

-(void) stopTimer
{
    [timerRefreshProgress invalidate];
}

#pragma mark - Action
-(IBAction) addAccountButtonDidTap:(UIButton *)sender
{
    ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction) editButtonDidTap:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self.listAccountTableView setEditing:sender.selected animated:NO];
}

#pragma mark - UITableView dataSource and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFiltering) {
        return self.listTokenFiltered.count;
    }
    
    return self.listToken.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountPasswordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountPasswordCell"];
    
    OTPToken *token = [self tokenAtIndexPath:indexPath];
    [cell bindingToken:token];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.listToken removeObjectAtIndex:indexPath.row];
    [Utils saveListToken:self.listToken];
    [self.listAccountTableView reloadData];
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    OTPToken *sourceToken = [self.listToken objectAtIndex:sourceIndexPath.row];
    NSMutableArray *listToken = self.listToken;
    [listToken removeObject:sourceToken];
    [listToken insertObject:sourceToken atIndex:destinationIndexPath.row];
    self.listToken = listToken;
    [self.listAccountTableView reloadData];
    [Utils saveListToken:self.listToken];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    AccountPasswordCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *password = [cell.passwordLabel text];
    password = [password stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[UIPasteboard generalPasteboard] setString:password];
    [Utils generateHapticFeedbackWithType:UINotificationFeedbackTypeSuccess];
    
    [SVProgressHUD showSuccessWithStatus:@"Copied"];
}

-(OTPToken *) tokenAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *target = self.listToken;
    
    if (isFiltering) {
        target = self.listTokenFiltered;
    }
    
    return [target objectAtIndex:indexPath.row];
}

#pragma mark - ScanQRCodeViewController Delegate
-(void)scanQRCodeController:(ScanQRCodeViewController *)controller didAddToken:(OTPToken *)token
{
    if (![self.listToken containsObject:token])
    {
        [self.listToken addObject:token];
        [self.listAccountTableView reloadData];
        
        [Utils saveListToken:self.listToken];
    }
}

#pragma mark - UITextField delegate
-(void)textFieldTextDidChange:(UITextField *)textField
{
    NSString *text = textField.text.lowercaseString;
    
    isFiltering = text.length ? YES : NO;
    if (isFiltering)
    {
        NSMutableArray *listTokenFiltered = [[NSMutableArray alloc] init];
        for (OTPToken *token in self.listToken)
        {
            if ([token.accountName.lowercaseString containsString:text] || [token.issuer.lowercaseString containsString:text])
            {
                [listTokenFiltered addObject:token];
            }
            
            self.listTokenFiltered = listTokenFiltered;
        }
        
        self.listAccountTableView.editing = NO;
    }
    
    self.editButton.enabled = !isFiltering;
    
    [self.listAccountTableView reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - NOtification
-(void) registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void) keyboardDidShowNotification:(NSNotification *)notification
{
    CGSize keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.listAccountTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
}

-(void) keyboardDidHideNotification:(NSNotification *)notification
{
    self.listAccountTableView.contentInset = UIEdgeInsetsZero;
}

-(void) applicationWillEnterForegroundNotification:(NSNotification *)notification
{
    [self showAuthenticate];
}

-(void) showAuthenticate
{
    LAContext *authContext = [[LAContext alloc] init];
    if ([authContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil])
    {
        if (blurEffectView)
        {
            [blurEffectView removeFromSuperview];
        }
        
        UIBlurEffect *blueEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blueEffect];
        blurEffectView.alpha = 0.98;
        [self.view addSubview:blurEffectView];
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = NO;
        [blurEffectView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
        [blurEffectView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
        [blurEffectView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
        [blurEffectView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:@"Auth to access" forState:UIControlStateNormal];
        button.translatesAutoresizingMaskIntoConstraints = NO;
        [blurEffectView.contentView addSubview:button];
        
        [button.centerXAnchor constraintEqualToAnchor:blurEffectView.contentView.centerXAnchor].active = YES;
        [button.centerYAnchor constraintEqualToAnchor:blurEffectView.contentView.centerYAnchor].active = YES;
        
        [button addTarget:self action:@selector(showAuthenticate) forControlEvents:UIControlEventTouchUpInside];
        
        [self authenticateWithContext:authContext policy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics];
    }
}

-(void) authenticateWithContext:(LAContext *)context policy:(LAPolicy)policy
{
    __weak ListAccountViewController *weakSelf = self;
    [context evaluatePolicy:policy localizedReason:@"Protect password" reply:^(BOOL success, NSError * _Nullable error) {
        if (success)
        {
            NSLog(@"User is authenticated successfully");
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf removeBlurEffect];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] performSelector:@selector(suspend)];
            });
        }
    }];
}

#pragma mark - Util
-(void) removeBlurEffect
{
    [blurEffectView removeFromSuperview];
    blurEffectView = nil;
}
@end
