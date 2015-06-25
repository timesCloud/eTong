//
//  PackingStockTableViewCell.m
//  eTong
//
//  Created by TsaoLipeng on 15/5/21.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "PackingStockTableViewCell.h"
#import "PackingSpecification.h"
#import "Defines.h"
#import "ShareInstances.h"
#import "UIView+XD.h"

#define kNUMBERS @"0123456789\n"

@interface PackingStockTableViewCell()<UITextFieldDelegate>

@end

@implementation PackingStockTableViewCell{
    PackingSpecification *ps;
    UIImageView *packingImageView;
    UILabel *packingNameLabel;
    UITextField *stockTextField;
    UITextField *purchaseTextField;
    UILabel *unitLabel1, *unitLabel2;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier entryMode:(NSInteger)mode{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGSize size = [[UIScreen mainScreen] applicationFrame].size;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 90)];
    [ShareInstances addBottomBorderOnView:bgView];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:bgView];
    
    packingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_NARROW, MARGIN_NARROW, 70, 70)];
    [packingImageView setContentMode:UIViewContentModeCenter];
    [bgView addSubview:packingImageView];
    
    packingNameLabel = [ShareInstances addLabel:@"" withFrame:CGRectMake(MARGIN_NARROW, packingImageView.bottom, 70, TEXTSIZE_CONTENT) withSuperView:bgView withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentCenter withTextSize:TEXTSIZE_CONTENT];
    
    NSString *stockLabelString = mode == 1 ? @"库存" : @"进货前库存";
    UILabel *stockLabel = [ShareInstances addLabel:stockLabelString withFrame:CGRectMake(self.width - MARGIN_NARROW * 2 - TEXTSIZE_CONTENT - 80, MARGIN_WIDE, 80, TEXTSIZE_SUBTITLE) withSuperView:self withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentCenter withTextSize:TEXTSIZE_SUBTITLE];
    stockTextField = [[UITextField alloc] initWithFrame:CGRectMake(stockLabel.x, stockLabel.bottom + MARGIN_NARROW, stockLabel.width, 32)];
    [stockTextField setBorderStyle:UITextBorderStyleRoundedRect];
    stockTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    stockTextField.returnKeyType = UIReturnKeyDone;
    stockTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    stockTextField.delegate = self;
    stockTextField.tag = 1;
    [self addSubview:stockTextField];
    unitLabel1 = [ShareInstances addLabel:@"" withFrame:CGRectMake(stockTextField.right + MARGIN_NARROW, stockTextField.y + (stockTextField.height - TEXTSIZE_CONTENT) / 2, TEXTSIZE_CONTENT, TEXTSIZE_CONTENT) withSuperView:self withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentCenter withTextSize:TEXTSIZE_CONTENT];
    
    if (mode == 2) {
        UILabel *purchaseLabel = [ShareInstances addLabel:@"进货" withFrame:CGRectMake(stockTextField.x - MARGIN_NARROW * 2 - 20 - TEXTSIZE_CONTENT - 80, MARGIN_WIDE, 80, TEXTSIZE_SUBTITLE) withSuperView:self withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentCenter withTextSize:TEXTSIZE_SUBTITLE];
        purchaseTextField = [[UITextField alloc] initWithFrame:CGRectMake(purchaseLabel.x, purchaseLabel.bottom + MARGIN_NARROW, purchaseLabel.width, 32)];
        [purchaseTextField setBorderStyle:UITextBorderStyleRoundedRect];
        purchaseTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        purchaseTextField.returnKeyType = UIReturnKeyDone;
        purchaseTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        purchaseTextField.delegate = self;
        purchaseTextField.tag = 2;
        [self addSubview:purchaseTextField];
        unitLabel2 = [ShareInstances addLabel:@"" withFrame:CGRectMake(purchaseTextField.right + MARGIN_NARROW, purchaseTextField.y + (purchaseTextField.height - TEXTSIZE_CONTENT) / 2, TEXTSIZE_CONTENT, TEXTSIZE_CONTENT) withSuperView:self withTextColor:NORMAL_TEXT_COLOR withAlignment:NSTextAlignmentCenter withTextSize:TEXTSIZE_CONTENT];
    }
    
    return self;
}

-(void)setPackingSpecification:(PackingSpecification *)packingSpecification{
    ps = packingSpecification;
    
    [packingNameLabel setText:ps.packingName];
    [unitLabel1 setText:ps.unit];
    [unitLabel2 setText:ps.unit];
    [ps.image getThumbnail:YES width:140 height:140 withBlock:^(UIImage *image, NSError *error) {
        if (!error) {
            [packingImageView setImage:image];
        }
    }];
}

#pragma marks UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:kNUMBERS]invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    
    BOOL canChange = [string isEqualToString:filtered];
    
    return canChange;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger curValue = 0;

    if ([textField.text  isEqual: @""]) {
        curValue = 0;
    } else{
        curValue = [textField.text intValue];
    }
    
    if (textField.tag == 1) {
        if ([_delegate respondsToSelector:@selector(packing:StockEntried:)]) {
            [_delegate packing:ps StockEntried:curValue];
        }
    } else{
        if ([_delegate respondsToSelector:@selector(packing:PurchaseEntried:)]) {
            [_delegate packing:ps PurchaseEntried:curValue];
        }
    }
}

@end
