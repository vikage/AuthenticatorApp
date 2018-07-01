//
//  BaseViewController.m
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
{
    BOOL isWillFirstAppeared;
    BOOL isDidFirstAppeared;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isWillFirstAppeared) {
        isWillFirstAppeared = YES;
        
        [self viewWillFirstAppear];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isDidFirstAppeared) {
        isDidFirstAppeared = YES;
        
        [self viewDidFirstAppear];
    }
}

-(void)viewWillFirstAppear
{
    
}

-(void)viewDidFirstAppear
{
    
}

@end
