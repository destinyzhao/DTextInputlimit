//
//  ViewController.m
//  DTextInputlimit
//
//  Created by Destiny on 2019/1/21.
//  Copyright © 2019 Destiny. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+Limit.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.textField1.textFieldType = DTextFieldStringTypeNumber;
    self.textField1.maxLength = 11;
    
    self.textField1.lengthBlock = ^(NSInteger length) {
        NSLog(@"长度--%zd",length);
    };
    self.textField1.isTextFieldTypeBlock = ^(BOOL filedType) {
        if (!filedType) {
            NSLog(@"请输入正确的类型");
        }
    };

}


@end
