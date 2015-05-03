//
//  UICustomSettingViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "CustomSettingViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "SettingTableViewCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SexSelectionViewController.h"
#import "ImgShowViewController.h"
#import "VPImageCropperViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SVProgressHUD.h"
#import "CustomDatePickerView.h"
#import "CustomTextInputViewController.h"
#import "IndustrySettingViewController.h"
#import "FavoriteSportSettingViewController.h"
#import "ShareInstances.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface CustomSettingViewController()<NormalNavigationDelegate, UITableViewDataSource, UITableViewDelegate, SexSelectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate, UIActionSheetDelegate, CustomDatePickerViewDelegate, CustomTextInputViewDelegate, IndustrySettingViewDelegate, FavoriteSportSettingViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation CustomSettingViewController{
    NSArray *sexArray;
    
    NSMutableString *favoriteSportDescription;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = NORMAL_BACKGROUND_COLOR;
    
    if (_settingMode != 999) {
        _navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"修改资料"];
    }else {
        _navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"完善个人资料"];
    }
    
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom, self.view.width, self.view.height - _navigationBar.bottom)];
    [_tableView setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark NormalNavigationDelegate
- (void)doReturn {
    if ([_delegate respondsToSelector:@selector(userSettingChanged)]) {
        [_delegate userSettingChanged];
    }
    if (_settingMode == 999) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark UITableViewDelegate and UiTableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 54;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"CustomSettingTableViewCell";
    SettingTableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[SettingTableViewCell alloc] init];
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [vCell.textLabel setTextColor:NORMAL_TEXT_COLOR];
        vCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    AVUser *curUser = [AVUser currentUser];
    switch (indexPath.row) {
        case 0:{
            [vCell setKey:@"头像" withImage:nil];
            AVFile *headPortrait = [curUser objectForKey:@"headPortrait"];
            [headPortrait getThumbnail:YES width:120 height:120 withBlock:^(UIImage *image, NSError *error) {
                if (!error){
                    [vCell setKey:@"头像" withImage:image];
                }
            }];
            break;
        }
        case 1:
            [vCell setKey:@"昵称" withValue:[curUser objectForKey:@"nickname"]];
            break;
        case 2:{
            NSNumber *sexNum = [curUser objectForKey:@"sex"];
            NSString *sexString = [sexNum integerValue] == 1 ? @"男" : @"女";
            [vCell setKey:@"性别" withValue:sexString];
            break;
        }
        case 3:{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            [vCell setKey:@"生日" withValue:[dateFormatter stringFromDate:[curUser objectForKey:@"birthday"]]];
            break;
        }
        case 4:
            [vCell setKey:@"签名" withValue:[curUser objectForKey:@"signature"]];
            break;
        case 5:{
            AVObject *industry = [curUser objectForKey:@"industry"];
            [vCell setKey:@"行业" withValue:[industry objectForKey:@"categoryName"]];
            break;
        }
        case 6:
            if (favoriteSportDescription != nil) {
                [vCell setKey:@"钟爱运动" withValue:favoriteSportDescription];
            } else {
                favoriteSportDescription = [[NSMutableString alloc] init];
                AVRelation *relation = [[AVUser currentUser] relationforKey:@"favoriteSport"];
                AVQuery *query = [relation query];
                [query orderByAscending:@"order"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (AVObject *sport in objects) {
                            [favoriteSportDescription appendFormat:@"%@  ", [sport objectForKey:@"categoryName"]];
                        }
                    } else {
                        [favoriteSportDescription appendString:@"网络不给力，没获取到哦..."];
                    }
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
            
            break;
        default:
            break;
    }
    return vCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self editPortrait];
            break;
        case 1:{
            NSString *nickname = [[AVUser currentUser] objectForKey:@"nickname"];
            CustomTextInputViewController *customTextInputVC = [[CustomTextInputViewController alloc] initWithTitle:@"修改昵称" withRow:1 withOriginText:nickname withEditKey:@"nickname"];
            customTextInputVC.delegate = self;
            [self.navigationController pushViewController:customTextInputVC animated:YES];
            break;
        }
        case 2:{
            SexSelectionViewController *sexSelectionVC = [[SexSelectionViewController alloc] init];
            NSNumber *sex = [[AVUser currentUser] objectForKey:@"sex"];
            [sexSelectionVC setInitSex:[sex integerValue]];
            sexSelectionVC.delegate = self;
            [self.navigationController pushViewController:sexSelectionVC animated:YES];
            break;
        }
        case 3:{
            CustomDatePickerView *customDatePickerView = [[CustomDatePickerView alloc] initWithFrame:self.view.frame withDefaultDate:[[AVUser currentUser] objectForKey:@"birthday"]];
            customDatePickerView.delegate = self;
            [self.view addSubview:customDatePickerView];
            break;
        }
        case 4:{
            NSString *signature = [[AVUser currentUser] objectForKey:@"signature"];
            CustomTextInputViewController *signatureTextInputVC = [[CustomTextInputViewController alloc] initWithTitle:@"修改签名" withRow:4 withOriginText:signature withEditKey:@"signature"];
            signatureTextInputVC.delegate = self;
            [self.navigationController pushViewController:signatureTextInputVC animated:YES];
            break;
        }
        case 5:{
            IndustrySettingViewController *industrySettingVC = [[IndustrySettingViewController alloc] init];
            industrySettingVC.delegate = self;
            [self.navigationController pushViewController:industrySettingVC animated:YES];
            break;
        }
        case 6:{
            FavoriteSportSettingViewController *favoriteSportSettingVC = [[FavoriteSportSettingViewController alloc] init];
            favoriteSportSettingVC.delegate = self;
            [self.navigationController pushViewController:favoriteSportSettingVC animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)sexChanged{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)dateChanged{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)textChangedOnRow:(NSInteger)row{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)industryChanged{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)favoriteSportChanged{
    favoriteSportDescription = nil;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 头像编辑代码开始
- (void)editPortrait {
    AVUser *curUser = [AVUser currentUser];
    if (curUser != nil) {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", @"查看大图", nil];
        [choiceSheet showInView:self.view];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        [self showCamera];
    } else if (buttonIndex == 1) {
        // 从相册中选取
        [self showImagePicker];
    } else if (buttonIndex == 2) {
        [self showCurUserFullHeadPortrait];
    }
}

#pragma ShowUserCellDelegate
- (void)showImagePicker {
    if ([self isPhotoLibraryAvailable]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}

- (void)showCamera {
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Picker View Controller is presented");
                         }];
    }
}

- (void)showCurUserFullHeadPortrait {
    AVUser *curUser = [AVUser currentUser];
    AVFile *imageFile = [curUser objectForKey:@"headPortrait"];
    NSMutableArray *images = [NSMutableArray arrayWithObject:imageFile];
    ImgShowViewController *imageShowVC = [[ImgShowViewController alloc] initWithSourceData:images withIndex:0];
    [self.navigationController pushViewController:imageShowVC animated:YES];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [self setPortaintImage: editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)setPortaintImage: (UIImage *)image {
    NSData *imageData = UIImagePNGRepresentation(image);
    AVFile *imageFile = [AVFile fileWithName:@"headPortrait.png" data:imageData];
    [SVProgressHUD showSuccessWithStatus:@"正在更新头像"];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            AVUser *curUser = [AVUser currentUser];
            [curUser setObject:imageFile forKey:@"headPortrait"];
            [curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    [SVProgressHUD dismiss];
                } else {
                    [ShareInstances NormalNetworkErrorHUD];
                }
            }];
        } else {
            [ShareInstances NormalNetworkErrorHUD];
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        //裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}


#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}
#pragma mark 头像编辑代码结束

@end
