//
//  NSObject+Privacy.h
//  Privacy
//
//  Created by 洪强 on 2019/2/23.
//  Copyright © 2019 洪强. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    CameraPrivacy = 1,              //相机权限
    PhotoLibraryPrivacy = 2,        //相册权限
    MicrophonePrivacy,              //麦克风权限
    LocationPrivacy,                //定位权限
    UserNotificationPrivacy,        //通知权限
    
}SystemPrivacy;

@interface NSObject (Privacy)

/// 检查是否开启系统权限
- (void)checkPrivacyEnable:(SystemPrivacy)type withResult:(void (^)(BOOL result))result;
/// 检查是否开启权限，未开启权限弹出提醒窗
- (void)checkPrivacyEnableWithAlert:(SystemPrivacy)type withResult:(void (^)(BOOL result))result;
/// 检查是否开启权限，未开启权限弹出提醒窗，并捕获用户不允许操作
- (void)checkPrivacyEnableWithAlert:(SystemPrivacy)type withResult:(void (^)(BOOL result))result withCancel:(void (^)(void))cancel;

@end
