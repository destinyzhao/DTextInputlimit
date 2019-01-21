//
//  UITextField+Limit.h
//  DTextInputlimit
//
//  Created by Destiny on 2019/1/21.
//  Copyright © 2019 Destiny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextLengthBlock)(NSInteger length);
typedef void(^IsTextFieldTypeBlock)(BOOL filedType);

typedef NS_ENUM(NSInteger,DTextFieldType) {
    DTextFieldStringTypeNone = 0,            // 不限制
    DTextFieldStringTypeNumber = 1,         // 数字
    DTextFieldStringTypeLetter = 2         // 字母
};

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Limit)

/**允许输入最大字符长度*/
@property (assign, nonatomic) NSInteger maxLength;
/**输入类型*/
@property (assign, nonatomic) NSInteger textFieldType;
/**输入长度回调（返回输入的字符长度）*/
@property (nonatomic , copy) TextLengthBlock lengthBlock;
/**输入限制类型的回调（判断是否是想要的输入类型，外部提示用）*/
@property (nonatomic , copy) IsTextFieldTypeBlock isTextFieldTypeBlock;


@end

NS_ASSUME_NONNULL_END
