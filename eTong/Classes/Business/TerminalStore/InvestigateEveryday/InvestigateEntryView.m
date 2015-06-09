//
//  InvestigateEntryView.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/23.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "InvestigateEntryView.h"
#import "ShareInstances.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "SVProgressHUD.h"
#import "Brand.h"
#import "Promotion.h"
#import "CustomPickerView.h"
#import "UzysAssetsPickerController.h"
#import "RootViewController.h"
#import "InvestigateEveryday.h"

@interface InvestigateEntryView()<CustomPickerViewDelegate, UzysAssetsPickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *selectedSurfaceImage;
@property (nonatomic, strong) UIImageView *surfaceImage1;
@property (nonatomic, strong) UIImageView *surfaceImage2;
@property (nonatomic, strong) UIImageView *surfaceImage3;
@property (nonatomic, strong) NSArray *surfaceImageViewArray;

@end

@implementation InvestigateEntryView{
    UILabel *brandLabel;
    UILabel *satisfactionLabel;
    UILabel *promotionLabel;

    Brand *selectedBrand;
    NSInteger selectedSatisfaction;
    Promotion *selectedPromotion;
    
    NSArray *brands;
    NSMutableArray *brandNames;
    NSArray *promotions;
    NSMutableArray *promotionNames;
    NSArray *satisfactionArray;
}

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.homeViewController = (RootViewController *)controller;
        [self initialize];
    }
    return self;
}

-(void)initialize{
    [self setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    UILabel *brandTitleLabel = [ShareInstances addSubTitleLabel:@"品牌" withFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, self.width - MARGIN_NARROW * 2, TEXTSIZE_SUBTITLE) withSuperView:self];
    UIView *brandView = [[UIView alloc] initWithFrame:CGRectMake(0, brandTitleLabel.bottom + MARGIN_NARROW, self.width, 44)];
    [brandView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:brandView];
    [ShareInstances addGoIndicateOnView:brandView];
    [ShareInstances addTopBottomBorderOnView:brandView];
    UITapGestureRecognizer *brandViewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(brandViewClick)];
    [brandView addGestureRecognizer:brandViewTapGR];
    brandLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(MARGIN_WIDE, (brandView.height - TEXTSIZE_BIG) / 2, brandView.width - MARGIN_WIDE * 2 - 44, TEXTSIZE_BIG) withSuperView:brandView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    
    UILabel *satisfactionTitleLabel = [ShareInstances addSubTitleLabel:@"满意度" withFrame:CGRectMake(MARGIN_NARROW, brandView.bottom + MARGIN_NARROW, self.width - MARGIN_NARROW * 2, TEXTSIZE_SUBTITLE) withSuperView:self];
    UIView *satisfactionView = [[UIView alloc] initWithFrame:CGRectMake(0, satisfactionTitleLabel.bottom + MARGIN_NARROW, self.width, 44)];
    [satisfactionView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:satisfactionView];
    [ShareInstances addGoIndicateOnView:satisfactionView];
    [ShareInstances addTopBottomBorderOnView:satisfactionView];
    satisfactionLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(MARGIN_WIDE, (satisfactionView.height - TEXTSIZE_BIG) / 2, satisfactionView.width - MARGIN_WIDE * 2 - 44, TEXTSIZE_BIG) withSuperView:satisfactionView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    UITapGestureRecognizer *satisfactionViewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(satisfactionViewClick)];
    [satisfactionView addGestureRecognizer:satisfactionViewTapGR];
    
    UILabel *promotionTitleLabel = [ShareInstances addSubTitleLabel:@"今日促销" withFrame:CGRectMake(MARGIN_NARROW, satisfactionView.bottom + MARGIN_NARROW, self.width - MARGIN_NARROW * 2, TEXTSIZE_SUBTITLE) withSuperView:self];
    UIView *promotionView = [[UIView alloc] initWithFrame:CGRectMake(0, promotionTitleLabel.bottom + MARGIN_NARROW, self.width, 44)];
    [promotionView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:promotionView];
    [ShareInstances addGoIndicateOnView:promotionView];
    [ShareInstances addTopBottomBorderOnView:promotionView];
    UITapGestureRecognizer *promotionTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promotionViewClick)];
    [promotionView addGestureRecognizer:promotionTapGR];
    promotionLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(MARGIN_WIDE, (promotionView.height - TEXTSIZE_BIG) / 2, promotionView.width - MARGIN_WIDE * 2 - 44, TEXTSIZE_BIG) withSuperView:promotionView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentLeft withTextSize:TEXTSIZE_BIG];
    
    UILabel *surfaceImageTitleLabel = [ShareInstances addSubTitleLabel:@"陈列面照片（1-3张）" withFrame:CGRectMake(MARGIN_NARROW, promotionView.bottom + MARGIN_NARROW, self.width - MARGIN_NARROW * 2, TEXTSIZE_SUBTITLE) withSuperView:self];
    UIView *surfaceImageView = [[UIView alloc] initWithFrame:CGRectMake(0, surfaceImageTitleLabel.bottom + MARGIN_NARROW, self.width, 100)];
    [surfaceImageView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:surfaceImageView];
    [ShareInstances addGoIndicateOnView:surfaceImageView];
    [ShareInstances addTopBottomBorderOnView:surfaceImageView];
    
    _surfaceImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, 90, 90)];
    _surfaceImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(_surfaceImage1.right + MARGIN_NARROW, MARGIN_NARROW, 90, 90)];
    _surfaceImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(_surfaceImage2.right + MARGIN_NARROW, MARGIN_NARROW, 90, 90)];
    [_surfaceImage1 setImage:[UIImage imageNamed:@"selectImage.png"]];
    [_surfaceImage2 setImage:[UIImage imageNamed:@"selectImage.png"]];
    [_surfaceImage3 setImage:[UIImage imageNamed:@"selectImage.png"]];
    [surfaceImageView addSubview:_surfaceImage1];
    [surfaceImageView addSubview:_surfaceImage2];
    [surfaceImageView addSubview:_surfaceImage3];
    _surfaceImageViewArray = [NSArray arrayWithObjects:_surfaceImage1, _surfaceImage2, _surfaceImage3, nil];
    UITapGestureRecognizer *surfaceImageViewTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(surfaceImageViewClick)];
    [surfaceImageView addGestureRecognizer:surfaceImageViewTapGR];
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height - 44, self.width, 44)];
    [submitButton setBackgroundColor:[UIColor orangeColor]];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(SubmitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:submitButton];
    
    [self loadData];
}

-(void)loadData{
    satisfactionArray = [NSArray arrayWithObjects:@"10",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2",@"1", nil];
    [satisfactionLabel setText:@"请选择"];
    
    _selectedSurfaceImage = [[NSMutableArray alloc] initWithCapacity:3];
    selectedSatisfaction = 0;
    
    AVQuery *queryBrand = [[[ShareInstances getCurrentTerminalStore] relationforKey:@"brand"] query];
    [queryBrand findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            brands = objects;
            brandNames = [[NSMutableArray alloc] init];
            for (Brand *brand in objects) {
                [brandNames addObject:brand.brandName];
            }
            [brandLabel setText:[NSString stringWithFormat:@"品牌：%@", [brandNames objectAtIndex:0]]];
            selectedBrand = [brands objectAtIndex:0];
        } else{
            [SVProgressHUD showErrorWithStatus:@"本店品牌列表获取失败，请稍候重试" duration:2];
        }
    }];
    
    AVQuery *queryPromotion = [Promotion query];
    [queryPromotion orderByAscending:@"order"];
    [queryPromotion findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            promotions = objects;
            promotionNames = [[NSMutableArray alloc] init];
            [promotionNames addObject:@"无"];
            for (Promotion *promotion in objects) {
                [promotionNames addObject:promotion.promotionName];
            }
            [promotionLabel setText:@"请选择"];
        } else{
            [SVProgressHUD showErrorWithStatus:@"促销方式列表获取失败，请稍候重试" duration:2];
        }
    }];
}

-(void)brandViewClick{
    CustomPickerView *customPickerView = [[CustomPickerView alloc] initWithFrame:self.frame withOptionArray:brandNames withDefaultIndex:0];
    customPickerView.delegate = self;
    customPickerView.tag = 1;
    [self addSubview:customPickerView];
}

-(void)satisfactionViewClick{
    CustomPickerView *customPickerView = [[CustomPickerView alloc] initWithFrame:self.frame withOptionArray:satisfactionArray withDefaultIndex:0];
    customPickerView.delegate = self;
    customPickerView.tag = 2;
    [self addSubview:customPickerView];
}

-(void)promotionViewClick{
    CustomPickerView *customPickerView = [[CustomPickerView alloc] initWithFrame:self.frame withOptionArray:promotionNames withDefaultIndex:0];
    customPickerView.delegate = self;
    customPickerView.tag = 3;
    [self addSubview:customPickerView];
}

-(void)surfaceImageViewClick{
    [SVProgressHUD showWithStatus:@"请稍候"];
    UzysAssetsPickerController *uzysAssetsPcikerVC = [[UzysAssetsPickerController alloc] init];
    uzysAssetsPcikerVC.delegate = self;
    uzysAssetsPcikerVC.maximumNumberOfSelectionPhoto = 3;
    uzysAssetsPcikerVC.maximumNumberOfSelectionVideo = 0;
    [self.homeViewController presentViewController:uzysAssetsPcikerVC animated:YES completion:^{
        [SVProgressHUD dismiss];
    }];
}

- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    //__weak typeof(self) weakSelf = self;
    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *representation = obj;
        
        UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                           scale:representation.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        _selectedSurfaceImage[idx] = img;
        UIImageView *imageView = [_surfaceImageViewArray objectAtIndex:idx];
        [imageView setImage:img];
        //*stop = YES;
    }];
}

-(void)selectedIndexChanged:(NSInteger)index withTag:(NSInteger)tag{
    if (tag == 1) {
        selectedBrand = [brands objectAtIndex:index];
        [brandLabel setText:[NSString stringWithFormat:@"品牌：%@", selectedBrand.brandName]];
    } else if(tag == 2){
        selectedSatisfaction = [[satisfactionArray objectAtIndex:index] integerValue];
        [satisfactionLabel setText:[NSString stringWithFormat:@"满意度：%ld", selectedSatisfaction]];
    } else{
        if (index > 0)
            selectedPromotion = [promotions objectAtIndex:index - 1];
        else
            selectedPromotion = nil;
        [promotionLabel setText:[NSString stringWithFormat:@"今日促销：%@", [promotionNames objectAtIndex:index]]];
    }
}

-(void)SubmitButtonClick{
    NSString *errorString = @"";
    if (selectedBrand == nil) {
        errorString = @"请选择品牌";
    } else if (selectedSatisfaction == 0){
        errorString = @"请选择满意度";
    }
    if ([errorString isEqualToString:@""]) {
        InvestigateEveryday *ied = [InvestigateEveryday object];
        ied.brand = selectedBrand;
        ied.store = [ShareInstances getCurrentTerminalStore];
        ied.date = [NSDate date];
        ied.satisfaction = [NSNumber numberWithInteger:selectedSatisfaction];
        ied.promotion = selectedPromotion;
        [SVProgressHUD showWithStatus:@"正在提交"];
        [ied saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(!error){
                [SVProgressHUD showWithStatus:@"正在上传陈列面"];
                UIImage *image = [_selectedSurfaceImage objectAtIndex:0];
                if (image != nil) {
                    NSData *imageData = UIImagePNGRepresentation(image);
                    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
                    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            //[_selectedSurfaceImage replaceObjectAtIndex:0 withObject:nil];
                            [_surfaceImage1 setImage:[UIImage imageNamed:@"selectImage.png"]];
                            ied.displaySurfaceImage1 = imageFile;
                            [ied saveInBackground];
                        }
                    }];
                }
                
                image = [_selectedSurfaceImage objectAtIndex:1];
                if (image != nil) {
                    NSData *imageData = UIImagePNGRepresentation(image);
                    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
                    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            //[_selectedSurfaceImage replaceObjectAtIndex:1 withObject:nil];
                            [_surfaceImage2 setImage:[UIImage imageNamed:@"selectImage.png"]];
                            ied.displaySurfaceImage2 = imageFile;
                            [ied saveInBackground];
                        }
                    }];
                }
                
                image = [_selectedSurfaceImage objectAtIndex:2];
                if (image != nil) {
                    NSData *imageData = UIImagePNGRepresentation(image);
                    AVFile *imageFile = [AVFile fileWithName:@"image.png" data:imageData];
                    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            //[_selectedSurfaceImage replaceObjectAtIndex:2 withObject:nil];
                            [_surfaceImage3 setImage:[UIImage imageNamed:@"selectImage.png"]];
                            ied.displaySurfaceImage3 = imageFile;
                            [ied saveInBackground];
                        }
                    }];
                }
                
                [SVProgressHUD dismiss];
            } else{
                [SVProgressHUD showErrorWithStatus:@"网络故障，提交失败" duration:2];
            }
        }];
    } else{
        [SVProgressHUD showErrorWithStatus:errorString duration:2];
    }
}

@end
