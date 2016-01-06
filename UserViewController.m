//
//  UserViewController.m
//  iCastelli
//
//  Created by Eyolph on 20/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "UserViewController.h"
#import "HomeViewController.h"
#import "FeedViewController.h"
#import "AppDelegate.h"

@interface UserViewController () <UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *frame;
@property (weak, nonatomic) IBOutlet UISlider *colorSlider;
@property (weak, nonatomic) IBOutlet UIButton *colorHue;
@property (weak, nonatomic) IBOutlet UIButton *colorBase;

@end

@implementation UserViewController


- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    self.logoutButton.layer.cornerRadius = self.logoutButton.frame.size.width/2;
    self.frame.layer.cornerRadius = self.frame.frame.size.width/2;
    self.colorHue.layer.cornerRadius = self.colorHue.frame.size.width/2;
    self.colorBase.layer.cornerRadius = self.colorBase.frame.size.width/2;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameLabel.text = self.user.username;
    PFFile *file = self.user[@"image"];
    self.userImage.file = file;
    [self.userImage loadInBackground];
    self.statusLabel.text = self.user[@"status"];
    UIBarButtonItem *home = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(home)];
    self.navigationItem.rightBarButtonItem = home ;

}

- (IBAction)logout:(id)sender
{
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        HomeViewController *h = [[HomeViewController alloc] init];
        [self.navigationController pushViewController:h animated:YES];

    }];

}

- (IBAction)statusChange:(id)sender {
    self.statusLabel.hidden = YES;
    self.userTextField.hidden = NO;
    [self.userTextField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        
    if (textField == self.userTextField) {
        [textField resignFirstResponder];
        self.userTextField.hidden = YES;
        [self.user setObject:self.userTextField.text forKey:@"status"];
        [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            self.statusLabel.text = self.user[@"status"];
            self.statusLabel.hidden = NO;

        }];


            return NO;
    }
    return YES;
    
}


- (IBAction)changeColor:(id)sender
{
    self.colorSlider.minimumValue = 0;
    self.colorSlider.maximumValue = 1;
    
    self.colorHue.backgroundColor = [UIColor colorWithHue:self.colorSlider.value saturation:0.5 brightness:0.7 alpha:1];

}

- (IBAction)SaveColor:(id)sender

{
    NSNumber *numb = [[NSNumber alloc] initWithFloat:self.colorSlider.value];
    self.user[@"color"] =  numb;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [UIView animateWithDuration:0.8 animations:^{
            self.colorHue.bounds = CGRectMake(0,0, self.colorHue.bounds.size.width +20, self.colorHue.bounds.size.height + 20);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8 animations:^{
                self.colorHue.bounds = CGRectMake(0,0, self.colorHue.bounds.size.width - 20, self.colorHue.bounds.size.height - 20);
            } completion:nil];
            self.navigationController.toolbar.barTintColor = self.colorHue.backgroundColor;
            self.navigationController.navigationBar.barTintColor = self.colorHue.backgroundColor;
        }];
    }];
}

- (IBAction)basic:(id)sender {

    NSNumber *numb = [[NSNumber alloc] initWithFloat:0.494];
    self.user[@"color"] =  numb;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [UIView animateWithDuration:0.8 animations:^{
            self.colorBase.bounds = CGRectMake(0,0, self.colorBase.bounds.size.width +20, self.colorBase.bounds.size.height + 20);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8 animations:^{
                self.colorBase.bounds = CGRectMake(0,0, self.colorBase.bounds.size.width - 20, self.colorBase.bounds.size.height - 20);
            } completion:nil];
            self.navigationController.toolbar.barTintColor = self.colorBase.backgroundColor;
            self.navigationController.navigationBar.barTintColor = self.colorBase.backgroundColor;
        }];
    }];
}


- (IBAction)takePic:(id)sender
{
    UIAlertController *media = [UIAlertController alertControllerWithTitle:@"Cambia foto" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Scatta ora" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        
        imagePicker.allowsEditing = YES;

        [self presentViewController:imagePicker animated:YES completion:NULL];
    }];
 
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"Usa un'immagine" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];}];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Annulla" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];


        [media addAction:camera];
        [media addAction:library];
        [media addAction:cancel];

        [self presentViewController:media animated:YES completion:nil];


}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *pic = info[UIImagePickerControllerEditedImage];
    
    self.userImage.image = pic;
    PFUser *user = [PFUser currentUser];
    NSData *imageData = UIImageJPEGRepresentation(pic, 0.5f);
    PFFile *imageFile = [PFFile fileWithName:@"image" data:imageData];
    [user setObject:imageFile forKey:@"image"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        PFFile *file = user[@"image"];
        self.userImage.file = file;
    }];
    
    [self dismissViewControllerAnimated:YES completion:NULL];

    
}

- (void)home
{
    FeedViewController *f =[[FeedViewController alloc]init];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setViewControllers:@[f]];
}





@end
