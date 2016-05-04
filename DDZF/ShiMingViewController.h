//
//  ShiMingViewController.h
//  DDZF
//
//  Created by 王健超 on 15/12/2.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeIconDelegate.h"
#import "MBProgressHUD.h"
@interface ShiMingViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate>
{
    //输入框
    
    UITextView *_textEditor;
    
    
    //下拉菜单
    
    UIActionSheet *myActionSheet;
    
    
    //图片2进制路径
    
    NSString* filePath;
    
}

@property (nonatomic,assign)id<ChangeIconDelegate>delegate;

@end
