//
//  ViewController.m
//  KeyboardAnimation
//
//  Created by sunyazhou on 2018/9/18.
//  Copyright © 2018年 Kwai, Inc. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView      *backView;
@property (weak, nonatomic) IBOutlet UITextField *inputView;
@property (weak, nonatomic) IBOutlet UIButton    *doneButton;
@property (nonatomic, strong) MASConstraint *bottomConstrains;
@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveKeyboardShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveKeyboardHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@60);
        self.bottomConstrains = make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.backView);
        make.width.equalTo(@80);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backView).offset(10);
        make.right.equalTo(self.doneButton.mas_left).offset(-10);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-10);
    }];
}


- (void)didReceiveKeyboardShowNotification:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    
    self.bottomConstrains.offset = -CGRectGetHeight(keyboardFrame);
    [UIView animateWithDuration:animationDuration delay:0. options:animationOptions animations:^{
        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)didReceiveKeyboardHideNotification:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    UIViewAnimationOptions animationOptions = animationCurve << 16;
    self.bottomConstrains.offset = 0;
    [UIView animateWithDuration:animationDuration delay:0. options:animationOptions animations:^{
        [self.view setNeedsUpdateConstraints];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)onDoneButtonClick:(UIButton *)sender {
    [self.inputView resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
