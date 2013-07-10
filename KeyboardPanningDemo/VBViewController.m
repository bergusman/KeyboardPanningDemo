//
//  VBViewController.m
//  KeyboardPanningDemo
//
//  Created by Vitaly Berg on 10.07.13.
//  Copyright (c) 2013 Vitaly Berg. All rights reserved.
//

#import "VBViewController.h"

@interface VBViewController ()

@property (strong, nonatomic) UIView *keyboardView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation VBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor blueColor];
    v.frame = CGRectMake(0, 0, 320, 0);
    
    self.textField.inputAccessoryView = v;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [pan locationInView:self.view];
        
        CGRect frame = self.view.frame;
        
        if (location.y > frame.size.height - 216) {
            
            frame = self.keyboardView.frame;
            frame.origin.y = location.y + 20;
            self.keyboardView.frame = frame;
        }
    }
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        CGPoint location = [pan locationInView:self.view];
        CGRect frame = self.view.frame;
        if (location.y > frame.size.height - 80) {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = self.keyboardView.frame;
                frame.origin.y = self.view.window.bounds.size.height;
                self.keyboardView.frame = frame;
            } completion:^(BOOL finished) {
                self.keyboardView.hidden = YES;
                [self.view endEditing:YES];
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = self.keyboardView.frame;
                frame.origin.y = self.view.window.bounds.size.height - 216;
                self.keyboardView.frame = frame;
            }];
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)notificaiton {
    NSLog(@"--------------------------");
    NSLog(@"keyboardWillShow");
    NSLog(@"windows: %@", [UIApplication sharedApplication].windows);
    NSLog(@"inputView: %@", self.textField.inputView);
    NSLog(@"inputAccessoryView: %@", self.textField.inputAccessoryView);
    [self showSubviews:[UIApplication sharedApplication].windows[1] withSpacing:@"  "];
    self.keyboardView.hidden = NO;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSLog(@"--------------------------");
    NSLog(@"keyboardDidShow");
    NSLog(@"windows: %@", [UIApplication sharedApplication].windows);
    NSLog(@"inputView: %@", self.textField.inputView);
    NSLog(@"inputAccessoryView: %@", self.textField.inputAccessoryView);
    [self showSubviews:[UIApplication sharedApplication].windows[1] withSpacing:@"  "];
    
    self.keyboardView = self.textField.inputAccessoryView.superview;
}

- (void)showSubviews:(UIView *)view withSpacing:(NSString *)spacing {
    NSLog(@"%@%@", spacing, view);
    spacing = [NSString stringWithFormat:@"%@  ", spacing];
    for (UIView *subview in view.subviews) {
        [self showSubviews:subview withSpacing:spacing];
        
        if ([subview isKindOfClass:NSClassFromString(@"UIKBKeyView")]) {
            subview.backgroundColor = [UIColor redColor];
            //subview.hidden = YES;
        }
        if ([subview isKindOfClass:NSClassFromString(@"UIImageView")]) {
            subview.backgroundColor = [UIColor greenColor];
        }
    }
}

@end
