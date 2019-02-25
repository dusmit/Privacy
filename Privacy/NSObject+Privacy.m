//
//  NSObject+Privacy.m
//  Privacy
//
//  Created by 洪强 on 2019/2/23.
//  Copyright © 2019 洪强. All rights reserved.
//

#import "NSObject+Privacy.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>

typedef void (^ PrivacyCancelBlock)(void);

@implementation NSObject (Privacy)

- (void)checkPrivacyEnable:(SystemPrivacy)type withResult:(void (^)(BOOL result))result {
    
    [self checkPrivacyEnableWithAlert:NO WithType:type withResult:result withCancel:nil];
}

- (void)checkPrivacyEnableWithAlert:(SystemPrivacy)type withResult:(void (^)(BOOL result))result {
    
    [self checkPrivacyEnableWithAlert:YES WithType:type withResult:result withCancel:nil];
}

- (void)checkPrivacyEnableWithAlert:(SystemPrivacy)type withResult:(void (^)(BOOL result))result withCancel:(void (^)(void))cancel {
    
    [self checkPrivacyEnableWithAlert:YES WithType:type withResult:result withCancel:cancel];
}

- (void)checkPrivacyEnableWithAlert:(BOOL)isAlert WithType:(SystemPrivacy)type withResult:(void (^)(BOOL result))result withCancel:(void (^)(void))cancel {
    
    if (type == CameraPrivacy) {    // 相机权限
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied ) {
            
            if (isAlert) {
                
                [self showAlertViewWithTitle:@"开启相机权限" WithMessage:[NSString stringWithFormat:@"相机权限未开启，请进入系统【设置】>【隐私】>【相机】中打开开关，并允许%@使用相机",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]] WithAlertTitle:@"立即开启" WithCancelTitle:@"取消" WithCancelBlock:^{
                    if (cancel) {
                        cancel();
                    }
                }];
            }
            result(NO);
        }else {
            result(YES);
        }
        
    }else if (type == PhotoLibraryPrivacy) {    // 相册权限
        
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
            //无权限
            if (isAlert) {
                
                [self showAlertViewWithTitle:@"开启照片权限" WithMessage:[NSString stringWithFormat:@"照片权限未开启，请进入系统【设置】>【隐私】>【照片】中打开开关，并允许%@使用照片",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]] WithAlertTitle:@"立即开启" WithCancelTitle:@"取消" WithCancelBlock:^{
                    if (cancel) {
                        cancel();
                    }
                }];
            }
            result(NO);
        }else {
            result(YES);
        }
        
    }else if (type == MicrophonePrivacy) {  // 麦克风权限
        
        AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
        
        switch (permissionStatus) {
            case AVAudioSessionRecordPermissionUndetermined: {
                
                NSLog(@"第一次调用，是否允许麦克风弹框");
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                        result(NO);
                    }else {
                        result(NO);
                    }
                }];
                break;
            }
            case AVAudioSessionRecordPermissionDenied: {
                
                NSLog(@"已经拒绝麦克风弹框");
                if (isAlert) {
                    
                    [self showAlertViewWithTitle:@"开启麦克风权限" WithMessage:[NSString stringWithFormat:@"麦克风权限未开启，请进入系统【设置】>【隐私】>【麦克风】中打开开关，并允许%@使用麦克风",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]] WithAlertTitle:@"立即开启" WithCancelTitle:@"取消" WithCancelBlock:^{
                        if (cancel) {
                            cancel();
                        }
                    }];
                }
                result(NO);
                break;
            }
            case AVAudioSessionRecordPermissionGranted: {
                
                NSLog(@"已经允许麦克风弹框");
                result(YES);
                break;
            }
            default:
                
                result(YES);
                break;
        }
    }else if (type == LocationPrivacy) {    // 位置权限
        
        BOOL enable = [CLLocationManager locationServicesEnabled];
        int status = [CLLocationManager authorizationStatus];
        
        if (!enable || status == 1 || status == 2) {
            
            if (isAlert) {
                
                [self showAlertViewWithTitle:@"开启定位权限" WithMessage:[NSString stringWithFormat:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许%@使用定位服务",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]] WithAlertTitle:@"立即开启" WithCancelTitle:@"取消" WithCancelBlock:^{
                    if (cancel) {
                        cancel();
                    }
                }];
            }
            result(NO);
        }else {
            result(YES);
        }
    }else if (type == UserNotificationPrivacy) {    // 通知权限
        
        if (@available(iOS 10.0, *)) {
            
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                if (granted) {
                    
                    //获取用户是否同意开启通知
                    NSLog(@"已经允许通知");
                    result(YES);
                    
                }else {
                    if (isAlert) {
                        
                        [self showAlertViewWithTitle:@"开启通知权限" WithMessage:[NSString stringWithFormat:@"通知权限未开启，请进入系统【设置】>【通知】>【%@】中打开开关，允许通知",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]] WithAlertTitle:@"立即开启" WithCancelTitle:@"取消" WithCancelBlock:^{
                            if (cancel) {
                                cancel();
                            }
                        }];
                    }
                    result(NO);
                }
            }];
        }else {
            
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types <= UIUserNotificationTypeNone) {
                
                if (isAlert) {
                    
                    [self showAlertViewWithTitle:@"开启通知权限" WithMessage:[NSString stringWithFormat:@"通知权限未开启，请进入系统【设置】>【通知】>【%@】中打开开关，允许通知",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]] WithAlertTitle:@"立即开启" WithCancelTitle:@"取消" WithCancelBlock:^{
                        if (cancel) {
                            cancel();
                        }
                    }];
                }
                result(NO);
                
            }else {
                result(YES);
            }
        }
    }
}

- (void)showAlertViewWithTitle:(NSString *)title WithMessage:(NSString *)msg WithAlertTitle:(NSString *)alertTitle WithCancelTitle:(NSString *)cancelTitle WithCancelBlock:(PrivacyCancelBlock)cancelBlock {
    
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:title  message:msg preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:alertTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        [alert addAction:alertAction];
        [alert addAction:cancelAction];
    
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
