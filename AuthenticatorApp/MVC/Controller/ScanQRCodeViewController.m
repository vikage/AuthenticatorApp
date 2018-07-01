//
//  ScanQRCodeViewController.m
//  AuthenticatorApp
//
//  Created by fuxsociety on 7/1/18.
//  Copyright © 2018 fuxsociety. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
//#import "OTPToken.h"
@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic,strong) AVCaptureSession *captureSession;
@end

@implementation ScanQRCodeViewController
{
    AVCaptureVideoPreviewLayer *previewLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCaptureSession];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    previewLayer.frame = self.view.bounds;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.captureSession stopRunning];
}

#pragma mark - Config
-(void) config
{
    
}

-(void) initCaptureSession
{
    self.captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    [self.captureSession addInput:captureInput];
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    previewLayer.frame = self.view.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];
    
    AVCaptureMetadataOutput *qrCodeScanOutput = [[AVCaptureMetadataOutput alloc] init];
    
    [self.captureSession addOutput:qrCodeScanOutput];
    
    qrCodeScanOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    [qrCodeScanOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.captureSession startRunning];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    AVMetadataMachineReadableCodeObject *metadata = [metadataObjects firstObject];
    NSString * type = metadata.type;
    
    if (type == AVMetadataObjectTypeQRCode)
    {
        NSString *value = metadata.stringValue;
        if (value!=nil)
        {
            [self processQRCodeValue:value];
        }
        
        NSLog(@"QRCODe %@",value);
    }
}

-(void) processQRCodeValue:(NSString *)value
{
    NSString *decodedURL = [value stringByRemovingPercentEncoding];
    NSURL *url = [NSURL URLWithString:decodedURL];
    
    if (url)
    {
        NSString *accountName = [url path];
        NSString *query = [url query];
        
        if ([accountName containsString:@":"])
        {
            NSRange range = [accountName rangeOfString:@":"];
            accountName = [accountName substringFromIndex:range.location + range.length];
        }
        accountName = [accountName stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        NSDictionary *urlParams = [self processURLQuery:query];
        
        NSString *issuer = [urlParams objectForKey:@"issuer"];
        NSString *secret = [urlParams objectForKey:@"secret"];
        
        OTPToken *token = [[OTPToken alloc] initWithAccountName:accountName secret:secret issuer:issuer];
        
        if ([self.delegate respondsToSelector:@selector(scanQRCodeController:didAddToken:)])
        {
            [self.delegate scanQRCodeController:self didAddToken:token];
            [self.captureSession stopRunning];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

-(NSDictionary *) processURLQuery:(NSString *)query
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    NSArray *queryComponents = [query componentsSeparatedByString:@"&"];
    for (NSString *component in queryComponents)
    {
        NSArray *keyValComponent = [component componentsSeparatedByString:@"="];
        
        if (keyValComponent.count == 2) {
            NSString *key = [keyValComponent firstObject];
            NSString *value = [keyValComponent lastObject];
            
            [result setObject:value forKey:key];
        }
    }
    
    return result;
}
@end
