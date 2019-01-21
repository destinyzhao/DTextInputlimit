//
//  UITextField+Limit.m
//  DTextInputlimit
//
//  Created by Destiny on 2019/1/21.
//  Copyright © 2019 Destiny. All rights reserved.
//

#import "UITextField+Limit.h"
#import <objc/runtime.h>

#define kDNUMBERS     @"0123456789\n"
#define kDLETTER     @"abcdefghijklmnopqresuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

static NSString * const DMaxLengthKey = @"DMaxLengthKey";
static NSString * const DTextLengthBlockKey = @"DTextLengthKey";
static NSString * const DTextFieldTypeKey = @"DTextFieldTypeKey";
static NSString * const DIsTextFieldTypeKey = @"DIsTextFieldTypeKey";

@implementation UITextField (Limit)

- (void)setMaxLength:(NSInteger)maxLength{
    objc_setAssociatedObject(self, &DMaxLengthKey, @(maxLength), OBJC_ASSOCIATION_ASSIGN);
    
    [self addTarget:self
             action:@selector(textFieldTextChanged:)
   forControlEvents:UIControlEventEditingChanged];
}
- (NSInteger)maxLength{
    return   [objc_getAssociatedObject(self, &DMaxLengthKey) integerValue];
}

- (void)setLengthBlock:(TextLengthBlock)lengthBlock{
    objc_setAssociatedObject(self, &DTextLengthBlockKey, lengthBlock, OBJC_ASSOCIATION_COPY);
    
    [self addTarget:self
             action:@selector(textFieldTextChanged:)
   forControlEvents:UIControlEventEditingChanged];
}
- (TextLengthBlock)lengthBlock{
    return objc_getAssociatedObject(self, &DTextLengthBlockKey);
}

- (void)setTextFieldType:(NSInteger)textFieldType{
    objc_setAssociatedObject(self, &DTextFieldTypeKey,  @(textFieldType), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)textFieldType{
    return [objc_getAssociatedObject(self, &DTextFieldTypeKey) integerValue];
}

- (void)setIsTextFieldTypeBlock:(IsTextFieldTypeBlock)isTextFieldTypeBlock{
    objc_setAssociatedObject(self, &DIsTextFieldTypeKey, isTextFieldTypeBlock, OBJC_ASSOCIATION_COPY);
}
- (IsTextFieldTypeBlock)isTextFieldTypeBlock{
    return objc_getAssociatedObject(self, &DIsTextFieldTypeKey);
}

- (void)lengthLimitBlock:(UITextField *)textField
{
    if (self.lengthBlock) {
        self.lengthBlock(textField.text.length);
    }
}

- (void)textFieldTextChanged:(UITextField *)textField
{
   
    switch (self.textFieldType) {
        case DTextFieldStringTypeNone:
        {
            [self textFieldStringTypeNumber:textField];
        }
            break;
        case DTextFieldStringTypeNumber:
        {
            [self textFieldStringTypeNumber:textField];
        }
            break;
        case DTextFieldStringTypeLetter:
        {
            [self textFieldStringTypeLetter:textField];
        }
            break;
            
        default:
            break;
    }
    
   [self lengthLimitBlock:textField];
}


/**
 获取TextField输入范围
 @param textField textField
 @return 范围
 */
- (NSRange)getTextFieldRange:(UITextField *)textField
{
    NSInteger adaptedLength = textField.maxLength > 0? MIN(textField.text.length, textField.maxLength) : MIN(textField.text.length, MAXFLOAT);
    NSRange range = NSMakeRange(0, adaptedLength);
    
    return range;
}


/**
 输入类型验证

 @param aStr 输入字符串
 @param format 验证格式
 @return BOOL
 */
- (BOOL)inputTypeVerification:(NSString *)aStr format:(NSString *)format{
    NSCharacterSet* filterCS = [[NSCharacterSet characterSetWithCharactersInString:format] invertedSet];
    NSString *filterString = [[aStr componentsSeparatedByCharactersInSet:filterCS] componentsJoinedByString:@""];
    
    return [aStr isEqualToString:filterString];
}


/**
 无限制（可以输入任何类型）
 @param textField textField
 */
- (void)textFieldStringTypeNone:(UITextField *)textField
{
    textField.text = [textField.text substringWithRange:[self getTextFieldRange:textField]];
}

/**
 只能输入数字
 @param textField textField
 */
- (void)textFieldStringTypeNumber:(UITextField *)textField
{
    BOOL flag = [self inputTypeVerification:textField.text format:kDNUMBERS];
    if (flag){
        textField.text = [textField.text substringWithRange:[self getTextFieldRange:textField]];
        if (self.isTextFieldTypeBlock) {
            self.isTextFieldTypeBlock(YES);
        }
    }
    else{
        textField.text = @"";
        if (self.isTextFieldTypeBlock) {
            self.isTextFieldTypeBlock(NO);
        }
    }
}

/**
 只能输入字母
 @param textField textField
 */
- (void)textFieldStringTypeLetter:(UITextField *)textField
{
    BOOL flag = [self inputTypeVerification:textField.text format:kDLETTER];;
    if (flag){
        textField.text = [textField.text substringWithRange:[self getTextFieldRange:textField]];
        if (self.isTextFieldTypeBlock) {
            self.isTextFieldTypeBlock(YES);
        }
    }
    else{
        textField.text = @"";
        if (self.isTextFieldTypeBlock) {
            self.isTextFieldTypeBlock(NO);
        }
    }
}

@end
