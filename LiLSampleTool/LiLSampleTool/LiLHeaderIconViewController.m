//
//  LiLHeaderIconViewController.m
//  LiLSampleTool
//
//  Created by lilei on 2018/5/17.
//  Copyright © 2018年 lilei. All rights reserved.
//

#import "LiLHeaderIconViewController.h"
#import "LiLShearImgViewController.h"
@interface LiLHeaderIconViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate ,LiLShearImageDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property(nonatomic,strong)UIImagePickerController *imagePickerVC;
@end

@implementation LiLHeaderIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)shearImgClick:(UIButton *)sender {
//    AliImageReshapeController *vc = [[AliImageReshapeController alloc]init];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    UIAlertAction *photoAlbumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoLibrary];
    }];
    [alertVC addAction:cameraAction];
    [alertVC addAction:photoAlbumAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}
-(UIImagePickerController *)imagePickerVC{
    if (!_imagePickerVC) {
        _imagePickerVC = [[UIImagePickerController alloc]init];
        _imagePickerVC.delegate = self;
    }
    return _imagePickerVC;
}
-(void)openCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerVC animated:YES completion:nil];
    }
    
}
-(void)openPhotoLibrary{
    self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    LiLShearImgViewController *vc = [[LiLShearImgViewController alloc]init];
    vc.delegate = self;
    vc.hideNav = YES;
    vc.sourceImg = image;
    [self.imagePickerVC pushViewController:vc animated:YES];
}
-(void)shearImageSuccess:(UIImage *)image{
    [self dismissimagePickerVC];
    self.imgView.image = image;
    self.sizeLabel.text = NSStringFromCGSize(image.size);
}
-(void)shearImageCancel{
    [self dismissimagePickerVC];
}
-(void)dismissimagePickerVC{
    [self.imagePickerVC dismissViewControllerAnimated:YES completion:nil];
}


@end
