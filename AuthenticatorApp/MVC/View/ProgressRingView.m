//
//  ProgressRingView.m
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import "ProgressRingView.h"

@implementation ProgressRingView

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    CGRect drawRect = CGRectInset(rect, 1, 1);
    
    UIBezierPath *backgroundRingPath = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:rect.size.width/2];
    backgroundRingPath.lineWidth = 2;
    [[UIColorFromRGB(0xFFFFFF) colorWithAlphaComponent:0.5] setStroke];
    [backgroundRingPath stroke];
    
    UIBezierPath *ringPath = [[UIBezierPath alloc] init];
    ringPath.lineWidth = 2;
    [ringPath moveToPoint:CGPointMake(rect.size.width/2, 1)];
    
    CGPoint center = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGFloat angle = self.progress * M_PI * 2;
    [ringPath addArcWithCenter:center radius:(rect.size.width/2 - 1) startAngle:-M_PI_2 endAngle:(angle - M_PI_2) clockwise:YES];
    [[UIColorFromRGB(0x0FFFFF) colorWithAlphaComponent:1] setStroke];
    [ringPath stroke];
}

@end
