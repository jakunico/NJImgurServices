//
//  ViewController.h
//  SampleApp
//
//  Created by Nicolas Jakubowski on 8/15/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)actionLogin:(id)sender;
- (IBAction)actionLogout:(id)sender;
- (IBAction)actionUploadImage:(id)sender;

@end
