---
title: iOS 系统权限封装
date: 2019.02.23
categories: 
- iOS
tags:
- iOS
- Objective-C
- 系统权限
---

iOS系统权限简单封装

### 前提条件

苹果审核要求使用隐私权限必须在plist文件中详细的描述使用用途，以下文为例，可以直接复制到plist文件中。

> 	<key>NSCameraUsageDescription</key>
> 	<string>开启访问相机权限可以拍摄您喜欢的照片设置为菜品样照</string>
> 	<key>NSPhotoLibraryAddUsageDescription</key>
> 	<string>开启添加照片权限可以将您喜欢的图片保存在本地相册</string>
> 	<key>NSPhotoLibraryUsageDescription</key>
> 	<string>开启访问相册权限可以选择您喜欢的照片设置为菜品样照</string>
> 	<key>NSLocationUsageDescription</key>
> 	<string>开启定位权限可以选择您的店铺位置</string>
> 	<key>NSLocationWhenInUseUsageDescription</key>
> 	<string>开启定位权限可以选择您的店铺位置</string>

![image-20190223165039223](https://github.com/dusmit/Privacy/blob/master/image-20190223165039223.png)

### 使用方法

*使用iOS 类别特性，添加NSObject类别 `NSObject+Privacy` ，使用简单方便。*

1. 引入头文件 `#import "NSObject+Privacy.h"`

2. 添加代码

   ```objective-c
           [self checkPrivacyEnable:PhotoLibraryPrivacy withResult:^(BOOL result) {
               if (result) {
   
               }
           }];
   ```

### 项目地址

[点击查看](https://github.com/dusmit/Privacy)















