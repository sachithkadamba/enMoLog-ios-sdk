//
//  RLUIViewController.m
//  Test1
//
//  Created by Sachith on 5/21/18.
//  Copyright © 2017 EnWidth. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
//#import <RLLogger/RLLogger-Swift.h>
#import <RLLoggerSDKFramework/RLLoggerSDKFramework-Swift.h>


@implementation UIViewController (EventAutomator)

+ (void)load {
    Class class = [self class];
    
    SEL originalSelectorForViewAppear = @selector(viewWillAppear:);
    SEL swizzledSelectorForViewAppear = @selector(heap_viewWillAppear:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelectorForViewAppear);
    Method replacedMethod = class_getInstanceMethod(class, swizzledSelectorForViewAppear);
    method_exchangeImplementations(originalMethod, replacedMethod);
    
    SEL originalSelectorForViewDidLoad = @selector(viewDidLoad);
    SEL swizzledSelectorForViewDidLoad = @selector(heap_viewDidLoad);
    
    Method originalMethodForViewLoad = class_getInstanceMethod(class, originalSelectorForViewDidLoad);
    Method replacedMethodForViewLoad = class_getInstanceMethod(class, swizzledSelectorForViewDidLoad);
    method_exchangeImplementations(originalMethodForViewLoad, replacedMethodForViewLoad);
    
    SEL originalSelectorForDisappear = @selector(viewWillDisappear:);
    SEL swizzledSelectorForDisappear = @selector(heap_viewWillDisappear:);
    
    Method originalMethodForDisappear = class_getInstanceMethod(class, originalSelectorForDisappear);
    Method replacedMethodForDisappear = class_getInstanceMethod(class, swizzledSelectorForDisappear);
    method_exchangeImplementations(originalMethodForDisappear, replacedMethodForDisappear);
    
}

-(void)heap_viewDidLoad {
    [self heap_viewDidLoad];
    NSString *message = [NSString stringWithFormat:@"ViewDidLoad: %@", [self title]];
    [RLog debug:message keywords:@"ViewControllerLoading"];
}


- (void)heap_viewWillAppear:(BOOL)animated {
    [self heap_viewWillAppear:animated];
    NSString *message = [NSString stringWithFormat:@"ViewWillAppear: %@",[self title]];
    [RLog debug:message keywords:@"ViewController Appear"];

}

-(void)heap_viewWillDisappear:(BOOL)animated {
    [self heap_viewWillDisappear:animated];
    NSString *message = [NSString stringWithFormat:@"ViewWillDisappear: %@",[self title]];
    [RLog debug:message keywords:@"View Controller disappear"];
}
@end
