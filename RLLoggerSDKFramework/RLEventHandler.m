//
//  RLEventHandler.m
//  ELogger
//
//  Created by sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
//#import <RLLogger/RLLogger-Swift.h>
#import <RLLoggerSDKFramework/RLLoggerSDKFramework-Swift.h>


@implementation UIApplication (EventAutomator)

NSString *buttonTitle;
UIImage * buttonImage;
NSString *buttonAction;


+ (void)load {
    Class class = [self class];
    SEL originalSelector = @selector(sendAction:to:from:forEvent:);
    SEL replacementSelector = @selector(heap_sendAction:to:from:forEvent:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method replacementMethod = class_getInstanceMethod(class, replacementSelector);
    method_exchangeImplementations(originalMethod, replacementMethod);
}

- (BOOL)heap_sendAction:(SEL)action to:(id)target from:(id)sender forEvent:(UIEvent *)event {
    
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton*)sender;
        buttonTitle = button.currentTitle;
        buttonImage = [button currentImage];
        buttonAction = NSStringFromSelector(action);
        
        if (buttonImage != nil) {
            NSLog(@"%@",buttonImage.images.firstObject);
        }
        NSString *message = [NSString stringWithFormat:@"you clicked on button with title '%@'.",buttonTitle];
        [RLog debug:message keywords:@"UIButton Click Event"];

        NSLog(@"button '%@' action called method %@ in Controller %@",buttonTitle,buttonAction,[[button allTargets] allObjects].firstObject);
    
        NSString *messageForButton = [NSString stringWithFormat:@"Button '%@' Action method '%@' in controller '%@'.",buttonTitle,buttonAction,[[button allTargets] allObjects].firstObject];
        [RLog debug:messageForButton keywords:@"UIButton Click Event"];

    } else if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        UIBarButtonItem *button = (UIBarButtonItem *)sender;
        buttonTitle = button.title;
        buttonImage = [button image];
        buttonAction = NSStringFromSelector(action);
        if (buttonImage != nil) {
            NSLog(@"%@",buttonImage.images.firstObject);
        }
        NSString *message = [NSString stringWithFormat:@"You clciked on uiBarButton with title'%@'.",buttonTitle];
        [RLog debug:message keywords:@"UIBarButton Click Event"];
        NSString *messageForButtonAction = [NSString stringWithFormat:@"UIbarButton '%@' Action method '%@' in controller '%@'.",buttonTitle,buttonAction,[button target]];
        [RLog debug:messageForButtonAction keywords:@"UIBarButton Action"];
    } else if ([sender isKindOfClass:[UIBarItem class]]) {
        UIBarItem *button = (UIBarItem *)sender;
        buttonTitle = button.title;
        buttonImage = [button image];
        buttonAction = NSStringFromSelector(action);
        
        if (buttonImage != nil) {
            NSLog(@"%@",buttonImage.images.firstObject);
        }
        NSString *message = [NSString stringWithFormat:@"You clciked on uibaritem with title'%@'.",buttonTitle];
        [RLog debug:message keywords:@"UIBarItem Click Event"];

        NSString *messageForButtonAction = [NSString stringWithFormat:@"UIbaritem '%@' Action method '%@' in controller '%@'.",buttonTitle,buttonAction,target];
        [RLog debug:messageForButtonAction keywords:@"UIBarItem Click Event"];

        
    } else if ([sender isKindOfClass:[UITabBarItem class]]) {
        UITabBarItem *button = (UITabBarItem *)sender;
        buttonTitle = button.title;
        buttonImage = [button image];
        buttonAction = NSStringFromSelector(action);
        
        if (buttonImage != nil) {
            NSLog(@"%@",buttonImage.images.firstObject);
        }
        NSString *message = [NSString stringWithFormat:@"You clciked on UITabBar with title'%@'.",buttonTitle];
        [RLog debug:message keywords:@"UITabBarButton Click Event"];

        NSString *messageForButtonAction = [NSString stringWithFormat:@"UITabBar '%@' Action method '%@' in controller '%@'.",buttonTitle,buttonAction,target];
        [RLog debug:messageForButtonAction keywords:@"UITabBarButton Click Event"];

    }

    return [self heap_sendAction:action to:target from:sender forEvent:event];
}

@end
