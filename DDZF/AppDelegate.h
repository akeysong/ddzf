//
//  AppDelegate.h
//  DDZF
//
//  Created by 王健超 on 15/11/30.
//  Copyright (c) 2015年 wjc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic)BOOL isLaunchedByNotification;
@property(retain,nonatomic)NSArray *vcArr;

@end

