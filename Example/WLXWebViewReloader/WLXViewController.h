//
//  WLXViewController.h
//  WLXWebViewReloader
//
//  Created by Guido Marucci Blas on 08/26/2014.
//  Copyright (c) 2014 Guido Marucci Blas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLXViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (weak, nonatomic) IBOutlet UITextField *serverAddressTextField;
@property (weak, nonatomic) IBOutlet UISwitch *useReloaderSwitch;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
- (IBAction)connectButtonPressed:(id)sender;

@end
