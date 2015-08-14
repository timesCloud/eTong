//
//  TerminalStoreRegisterViewController.m
//  eTong
//
//  Created by TsaoLipeng on 15/6/9.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "TerminalStoreRegisterViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "UIView+XD.h"
#import "CustomTextInputViewController.h"
#import "TerminalStore.h"
#import "Brand.h"
#import "SKU.h"
#import "MarketingChannel.h"
#import "CustomPickerView.h"
#import "UzysAssetsPickerController.h"
#import "MultipleChoiceViewController.h"
#import "SVProgressHUD.h"
#import "UzysAssetsPickerController.h"
#import "SKU.h"
#import "ImageText.h"

@interface TerminalStoreRegisterViewController()<NormalNavigationDelegate, CustomTextInputViewDelegate,CustomPickerViewDelegate, UzysAssetsPickerControllerDelegate, MultipleChoiceViewDelegate, UzysAssetsPickerControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@property (nonatomic, strong) UIImageView *surfaceImage1;
@property (nonatomic, strong) UIImageView *surfaceImage2;
@property (nonatomic, strong) UIImageView *surfaceImage3;
@property (nonatomic, strong) NSArray *surfaceImageViewArray;
@property (nonatomic, strong) NSMutableArray *selectedSurfaceImage;

@end

@implementation TerminalStoreRegisterViewController{
    TerminalStore *curTerminalStore;
    NSInteger showMode;//0为初始登陆录入模式，1为普通新建模式，2为普通修改模式
    
    UILabel *shopKeeperLabel;
    UILabel *brandLabel;
    UILabel *storeNameLabel;
    UILabel *addressLabel;
    UILabel *locationLabel;
    UILabel *telNoLabel;
    UILabel *channelLabel;
    UILabel *shopFrontPhotoLabel;
    UILabel *businessLicenseNoLabel;
    UILabel *registionCodeLabel;
    
    NSArray *brands, *marketingChannels;
    NSMutableArray *brandNames, *marketingChannelNames, *selectedBrands;
    BOOL surface1Updating, surface2Updating, surface3Updating;
}

-(instancetype)initWithTerminalStore:(TerminalStore *)terminalStore withMode:(NSInteger)mode{
    self = [super init];
    curTerminalStore = terminalStore;
    if (curTerminalStore == nil) {
        curTerminalStore = [TerminalStore object];
    }
    curTerminalStore.shopKeeper = [AVUser currentUser];
    showMode = mode;
    return self;
}

-(void)loadData{
    AVQuery *queryBrand = [Brand query];
    [queryBrand orderByAscending:@"order"];
    [queryBrand findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            brands = objects;
//            brandNames = [[NSMutableArray alloc] init];
//            for (Brand *brand in objects) {
//                [brandNames addObject:brand.brandName];
//            }
//            [brandLabel setText:@"请选择"];
            AVRelation *relation = [curTerminalStore relationforKey:@"brand"];
            for (Brand *brand in objects) {
                [relation addObject:brand];
            }
        } else{
            [brandLabel setText:@"品牌列表获取失败，请稍后重试"];
        }
    }];
    
    AVQuery *queryMarketingChannel = [MarketingChannel query];
    [queryMarketingChannel orderByAscending:@"order"];
    [queryMarketingChannel findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            marketingChannels = objects;
            marketingChannelNames = [[NSMutableArray alloc] init];
            for (MarketingChannel *channel in objects) {
                [marketingChannelNames addObject:channel.channelName];
            }
            [channelLabel setText:@"请选择"];
        } else{
            [channelLabel setText:@"渠道类型列表获取失败，请稍候重试"];
        }
    }];
    
    AVQuery *querySKU = [SKU query];
    [querySKU findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            AVRelation *relation = [curTerminalStore relationforKey:@"sku"];
            for (SKU *sku in objects) {
                [relation addObject:sku];
            }
        }
    }];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"关联终端店"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, size.width, size.height - self.navigationBar.bottom - 44 + 20)];
    [self.view addSubview:scrollView];
    
    UIView *shopKeeperView = [ShareInstances addNormalItemViewOnView:scrollView withY:0 withTitle:@"管理人" canTouchUpInside:NO sender:nil action:nil];
    shopKeeperLabel = [ShareInstances addModifiableLabelOnView:shopKeeperView withDefaultText:[[AVUser currentUser] objectForKey:@"nickname"]];
    
    UIView *storeNameView = [ShareInstances addNormalItemViewOnView:scrollView withY:shopKeeperView.bottom+MARGIN_NARROW withTitle:@"店名" canTouchUpInside:YES sender:self action:@selector(onStoreNameViewTouchUpInside)];
    storeNameLabel = [ShareInstances addModifiableLabelOnView:storeNameView withDefaultText:curTerminalStore.storeName];
    
    UIView *addressView = [ShareInstances addNormalItemViewOnView:scrollView withY:storeNameView.bottom+MARGIN_NARROW withTitle:@"地址" canTouchUpInside:YES sender:self action:@selector(onAddressViewTouchUpInside)];
    addressLabel = [ShareInstances addModifiableLabelOnView:addressView withDefaultText:curTerminalStore.address];
    
    if (showMode < 2) {//新注册的终端店，location使用当前位置
        curTerminalStore.location = [ShareInstances getLastGeoPoint];
    }
    
    UIView *telNoView = [ShareInstances addNormalItemViewOnView:scrollView withY:addressView.bottom+MARGIN_NARROW withTitle:@"电话号码" canTouchUpInside:YES sender:self action:@selector(onTelNoViewTouchUpInside)];
    telNoLabel = [ShareInstances addModifiableLabelOnView:telNoView withDefaultText:curTerminalStore.telNo];
    
    UIView *channelView = [ShareInstances addNormalItemViewOnView:scrollView withY:telNoView.bottom+MARGIN_NARROW withTitle:@"渠道类型" canTouchUpInside:YES sender:self action:@selector(onChannelViewClick)];
    channelLabel = [ShareInstances addModifiableLabelOnView:channelView withDefaultText:curTerminalStore.channel.channelName];
    
    UIView *shopFrontPhotoView = [ShareInstances addItemViewOnView:scrollView withY:channelView.bottom+MARGIN_NARROW withHeight:100 withTitle:@"门脸照片（1-3张）" canTouchUpInside:YES sender:self action:@selector(onShopFrontViewClick)];
    _surfaceImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, 90, 90)];
    _surfaceImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(_surfaceImage1.right + MARGIN_NARROW, MARGIN_NARROW, 90, 90)];
    _surfaceImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(_surfaceImage2.right + MARGIN_NARROW, MARGIN_NARROW, 90, 90)];
    [_surfaceImage1 setImage:[UIImage imageNamed:@"selectImage.png"]];
    [_surfaceImage2 setImage:[UIImage imageNamed:@"selectImage.png"]];
    [_surfaceImage3 setImage:[UIImage imageNamed:@"selectImage.png"]];
    [shopFrontPhotoView addSubview:_surfaceImage1];
    [shopFrontPhotoView addSubview:_surfaceImage2];
    [shopFrontPhotoView addSubview:_surfaceImage3];
    surface1Updating = NO;
    surface2Updating = NO;
    surface3Updating = NO;
    _surfaceImageViewArray = [NSArray arrayWithObjects:_surfaceImage1, _surfaceImage2, _surfaceImage3, nil];
    [self loadShopFrontPhoto];
    
    UIView *businessLicenseView = [ShareInstances addNormalItemViewOnView:scrollView withY:shopFrontPhotoView.bottom+MARGIN_NARROW withTitle:@"营业执照号" canTouchUpInside:YES sender:self action:@selector(onBusinessLicenseViewTouchUpInside)];
    businessLicenseNoLabel = [ShareInstances addModifiableLabelOnView:businessLicenseView withDefaultText:curTerminalStore.businessLicenseNo];
    
    scrollView.contentSize = CGSizeMake(scrollView.width, businessLicenseView.bottom + MARGIN_WIDE);
    
    if (showMode != 2) {//不是修改模式时，因为邀请码不允许修改
        UIView *RegistionCodeView = [ShareInstances addNormalItemViewOnView:scrollView withY:businessLicenseView.bottom+MARGIN_NARROW withTitle:@"业务员代码" canTouchUpInside:YES sender:self action:@selector(onRegistionCodeViewTouchUpInside)];
        registionCodeLabel = [ShareInstances addModifiableLabelOnView:RegistionCodeView withDefaultText:@""];
        scrollView.contentSize = CGSizeMake(scrollView.width, RegistionCodeView.bottom + MARGIN_WIDE);
    }

    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height - 44, self.view.width, 44)];
    [submitButton setBackgroundColor:[UIColor orangeColor]];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    [self loadData];
}

-(void)loadShopFrontPhoto{
    AVRelation *relation = [curTerminalStore relationforKey:@"imageText"];
    AVQuery *query = [relation query];
    [query addDescendingOrder:@"createAt"];
    [query addAscendingOrder:@"order"];
    query.limit = 3;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (int i = 0; i < objects.count; i++) {
                ImageText *imageText = [objects objectAtIndex:i];
                [imageText.image getThumbnail:YES width:180 height:180 withBlock:^(UIImage *image, NSError *error) {
                    if (!error) {
                        UIImageView *imageView = [_surfaceImageViewArray objectAtIndex:i];
                        [imageView setImage:image];
                    }
                }];
            }
        }
    }];
}

-(void)querySelectedBrands{
    AVRelation *relation = [curTerminalStore relationforKey:@"brand"];
    AVQuery *query = [relation query];
    [query orderByAscending:@"order"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            selectedBrands = [[NSMutableArray alloc] initWithArray:objects];
        }
    }];
}

-(void)showBrandWithArray:(NSArray *)selected{
    if (selected == nil) {
        [self querySelectedBrands];
    }else{
        selectedBrands = [[NSMutableArray alloc] initWithArray:selected];
    }
    
    if (selectedBrands != nil) {
        if (selectedBrands.count == 0) {
            [brandLabel setText:@"请选择"];
        }else{
            NSMutableString *tempString = [[NSMutableString alloc] init];
            for (Brand *brand in selectedBrands) {
                [tempString appendFormat:@"%@  ", brand.brandName];
            }
            [brandLabel setText:tempString];
        }
    }
}

-(void)onBrandViewClick{
    if (selectedBrands == nil) {
        [self querySelectedBrands];
    }
    MultipleChoiceViewController *mcVC = [[MultipleChoiceViewController alloc] initWithItemNames:brandNames withObjects:brands withSelectedObjects:selectedBrands];
    mcVC.delegate = self;
    [self.navigationController pushViewController:mcVC animated:YES];
}

-(void)onStoreNameViewTouchUpInside{
    CustomTextInputViewController *ctiVC = [[CustomTextInputViewController alloc] initWithTitle:@"终端店名" withRow:1 withOriginText:curTerminalStore.storeName];
    ctiVC.delegate = self;
    [self.navigationController pushViewController:ctiVC animated:YES];
}

-(void)onAddressViewTouchUpInside{
    NSString *address = [ShareInstances getLastAddress];
    if (![address isEqual: @""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否自动填写" message:[NSString stringWithFormat:@"您最新的GPS位置为“%@”，是否使用该地址？使用则同时会更新您的店铺GPS信息。", address] delegate:self cancelButtonTitle:@"手动填写" otherButtonTitles:@"自动填充", nil];
        [alertView show];
    }
}

-(void)onTelNoViewTouchUpInside{
    CustomTextInputViewController *ctiVC = [[CustomTextInputViewController alloc] initWithTitle:@"电话号码" withRow:3 withOriginText:curTerminalStore.telNo];
    ctiVC.delegate = self;
    [self.navigationController pushViewController:ctiVC animated:YES];
}

-(void)onBusinessLicenseViewTouchUpInside{
    CustomTextInputViewController *ctiVC = [[CustomTextInputViewController alloc] initWithTitle:@"营业执照" withRow:4 withOriginText:curTerminalStore.businessLicenseNo];
    ctiVC.delegate = self;
    [self.navigationController pushViewController:ctiVC animated:YES];
}

-(void)onRegistionCodeViewTouchUpInside{
    CustomTextInputViewController *ctiVC = [[CustomTextInputViewController alloc] initWithTitle:@"业务员代码" withRow:5 withOriginText:nil];
    ctiVC.delegate = self;
    [self.navigationController pushViewController:ctiVC animated:YES];
}


-(void)onChannelViewClick{
    CustomPickerView *customPickerView = [[CustomPickerView alloc] initWithFrame:self.view.frame withOptionArray:marketingChannelNames withDefaultIndex:0];
    customPickerView.delegate = self;
    customPickerView.tag = 1;
    [self.view addSubview:customPickerView];
}

-(void)onShopFrontViewClick{
    [SVProgressHUD showWithStatus:@"请稍候"];
    UzysAssetsPickerController *uzysAssetsPcikerVC = [[UzysAssetsPickerController alloc] init];
    uzysAssetsPcikerVC.delegate = self;
    uzysAssetsPcikerVC.maximumNumberOfSelectionPhoto = 3;
    uzysAssetsPcikerVC.maximumNumberOfSelectionVideo = 0;
    [self presentViewController:uzysAssetsPcikerVC animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

-(void)submitButtonClick{
    if ([storeNameLabel.text isEqualToString: @""] || [addressLabel.text isEqualToString:@""] || [telNoLabel.text isEqualToString:@""] || curTerminalStore.channel == nil || [businessLicenseNoLabel.text isEqualToString:@""] || [registionCodeLabel.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请将所有信息填写完整" duration:2];
    }else if(surface1Updating || surface2Updating || surface3Updating){
        [SVProgressHUD showErrorWithStatus:@"图片正在上传，请稍候" duration:2];
    }else{
        [SVProgressHUD showWithStatus:@"正在保存"];
        [curTerminalStore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [SVProgressHUD dismissWithSuccess:@"保存成功" afterDelay:2];
                [ShareInstances setCurrentTerminalStore:curTerminalStore];
                [self.navigationController popViewControllerAnimated:NO];
                if (showMode == 0){
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_COMENTITYLOADED object:self];
                }
            }
        }];
        
        [[AVUser currentUser] setObject:curTerminalStore.storeName forKey:@"nickname"];
        [[AVUser currentUser] saveInBackground];
    }
}

#pragma marks UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        CustomTextInputViewController *ctiVC = [[CustomTextInputViewController alloc] initWithTitle:@"终端店地址" withRow:2 withOriginText:curTerminalStore.address];
        ctiVC.delegate = self;
        [self.navigationController pushViewController:ctiVC animated:YES];
    }else{
        curTerminalStore.address = [ShareInstances getLastAddress];
        addressLabel.text = curTerminalStore.address;
        curTerminalStore.location = [ShareInstances getLastGeoPoint];
    }
}

#pragma marks UzysAssetsPickerControllerDelegate
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    //__weak typeof(self) weakSelf = self;
    
    AVRelation *relation = [curTerminalStore relationforKey:@"imageText"];
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *representation = obj;
        
        UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                           scale:representation.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        _selectedSurfaceImage[idx] = img;
        UIImageView *imageView = [_surfaceImageViewArray objectAtIndex:idx];
        [imageView setImage:img];
        NSData *imageData = UIImagePNGRepresentation(img);
        AVFile *imageFile = [AVFile fileWithName:@"shopFront.png" data:imageData];
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"正在保存第%ld张照片", idx+1]];
        if ([imageFile save]) {
            if (idx == 0) {
                curTerminalStore.shopFrontPhoto = imageFile;
            }
            ImageText *imageText = [ImageText object];
            imageText.image = imageFile;
            imageText.order = [NSNumber numberWithInteger:idx];
            if ([imageText save]) {
                [relation addObject:imageText];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"网络故障，第%ld张照片保存失败", idx+1] duration:2];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"网络故障，第%ld张照片保存失败", idx+1] duration:2];
        }
        //*stop = YES;
    }];
}

#pragma marks NormalNavigationBarDelegate
-(void)doReturn{
    if (showMode != 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma marks CustomPickerViewDelegat
-(void)selectedIndexChanged:(NSInteger)index withTag:(NSInteger)tag{
    if (tag == 1) {
        curTerminalStore.channel = [marketingChannels objectAtIndex:index];
        [channelLabel setText:[NSString stringWithFormat:@"品牌：%@", curTerminalStore.channel.channelName]];
    }
}
#pragma marks
- (void)textChanged:(NSString *)text OnRow:(NSInteger)row{
    switch (row) {
        case 1:
            curTerminalStore.storeName = text;
            storeNameLabel.text = text;
            break;
        case 2:
            curTerminalStore.address = text;
            addressLabel.text = text;
            break;
        case 3:
            curTerminalStore.telNo = text;
            telNoLabel.text = text;
            break;
        case 4:
            curTerminalStore.businessLicenseNo = text;
            businessLicenseNoLabel.text = text;
            break;
        case 5:
            //curTerminalStore.businessLicenseNo = text;
            registionCodeLabel.text = text;
            break;
        default:
            break;
    }
}
#pragma marks MultipleChoiceViewDelegate
-(void)multipleSelectedChanged:(NSArray *)selected{
    for (Brand *brand in selectedBrands) {
        if (![selected containsObject:brand]) {
            [selectedBrands removeObject:brand];
        }
    }
    for (Brand *brand in selected) {
        [selectedBrands addObject:brand];
    }
    
    AVRelation *relation = [curTerminalStore relationforKey:@"brand"];
    for (Brand *brand in selectedBrands) {
        [relation addObject:brand];
    }
//    
//    AVQuery *query = [SKU query];
//    [query whereKey:@"brand" containsAllObjectsInArray:selectedBrands];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            AVRelation *relation = [curTerminalStore relationforKey:@"sku"];
//            for (SKU *sku in objects) {
//                [relation addObject:sku];
//            }
//        }
//    }];
}

@end
