//
//  ViewController.m
//  Privacy
//
//  Created by 洪强 on 2019/2/23.
//  Copyright © 2019 洪强. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Privacy.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *selectImageButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.selectImageButton];
}

- (UIButton *)selectImageButton {
    
    if (!_selectImageButton) {
        
        _selectImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectImageButton setFrame:CGRectMake(0, 0, 200, 40)];
        [_selectImageButton setCenter:self.view.center];
        [_selectImageButton setTitle:@"点我选择照片" forState:UIControlStateNormal];
        [_selectImageButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_selectImageButton setBackgroundColor:[UIColor greenColor]];
        [_selectImageButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectImageButton;
}

- (UIImageView *)imageView {
    
    if(!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        [_imageView setCenter:self.view.center];
    }
    return _imageView;
}

- (void)selectImage {
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"从相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self checkPrivacyEnableWithAlert:CameraPrivacy withResult:^(BOOL result) {
            
            if (result) {
                
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:self.imagePicker animated:YES completion:nil];
                }
            }
        } withCancel:^{
            NSLog(@"系统权限没被允许呢...");
        }];
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)  {
        [self checkPrivacyEnable:PhotoLibraryPrivacy withResult:^(BOOL result) {
            if (result) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

//获取选择的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
}

//从相机或者相册界面弹出
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
