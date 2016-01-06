//
//  CreateNewViewController.m
//  iCastelli
//
//  Created by Eyolph on 28/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//


#import "CreateNewViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "FeedViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "EasterEggViewController.h"


@interface CreateNewViewController () <UINavigationControllerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *takeButton;
@property (weak, nonatomic) IBOutlet UITextView *messageField;
@property (weak, nonatomic) IBOutlet UIButton *loadButton;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act;
@property (strong, nonatomic) PFFile *videoFile;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIImageView *playOverlay;
@property (weak, nonatomic) IBOutlet UIButton *loadVideo;


@end



@implementation CreateNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messageField.delegate = self;
    self.act.hidden = YES;
    self.postButton.layer.cornerRadius = self.postButton.frame.size.width/2;
    self.messageField.layer.cornerRadius = 13;

    
    self.playOverlay.hidden = YES;
    

    [self.messageField becomeFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.act.hidden = YES;
    self.takeButton.enabled = YES;
    self.loadButton.enabled = YES;
    self.videoButton.enabled = YES;


}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
        [textField becomeFirstResponder];
}



- (IBAction)takePic:(id)sender {
    self.act.hidden = NO;
    [self.act startAnimating];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;

    [self presentViewController:imagePicker animated:YES completion:NULL];

}

- (IBAction)loadPic:(id)sender {
    self.act.hidden = NO;
    [self.act startAnimating];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if ([picker.mediaTypes containsObject:@"public.movie"]) {
        self.playOverlay.hidden = NO;
        NSURL *url = info[UIImagePickerControllerMediaURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.videoFile = [PFFile fileWithName:@"video.mov" data:data];
        self.takeButton.enabled = NO;
        self.loadButton.enabled = NO;
        self.videoButton.enabled = NO;
        AVAsset *asset = [AVAsset assetWithURL:url];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime time = CMTimeMake(1, 1);
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        self.imageView.image = thumbnail;
//        self.imageView.transform = CGAffineTransformMakeRotation(90);
        
    } else {
    self.act.hidden = YES;
    self.playOverlay.hidden = YES;


    UIImage *pic = info[UIImagePickerControllerEditedImage];

    
    self.imageView.image = pic;
    
    self.imageView.layer.cornerRadius = 10;
    self.imageView.clipsToBounds = YES;


    }
    self.takeButton.enabled = NO;
    self.loadButton.enabled = NO;
    self.videoButton.enabled = NO;
    [self dismissViewControllerAnimated:YES completion:NULL];
        
}




- (IBAction)dismissKeyboardSwipe:(UISwipeGestureRecognizer *)sender {
        [self.messageField resignFirstResponder];
}

- (IBAction)post:(id)sender {
    if ([self.messageField.text.lowercaseString isEqualToString:@"enrico is amazing"]) {
        EasterEggViewController *egg= [[EasterEggViewController alloc] init];
        [self.navigationController pushViewController:egg animated:YES];
    } else {
    
    self.act.hidden = NO;
    [self.act startAnimating];
    PFObject *new = [PFObject objectWithClassName:@"Feeds"];
    new[@"text"] = self.messageField.text;
    if (self.imageView.image) {
    NSData *im = UIImageJPEGRepresentation(self.imageView.image, 0.5);
    PFFile *file = [PFFile fileWithData:im];
    new[@"image"] = file;
    }
    new[@"user"] = [PFUser currentUser].username;
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    new[@"created"] = now;
    if (self.videoFile) {
        new[@"video"] = self.videoFile;
    }
    [new saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self.act stopAnimating];
        self.act.hidden = YES;

        FeedViewController *f = [[FeedViewController alloc]init];
        f.created = @"YES";

        [self.navigationController pushViewController: f animated:YES];
    }];
    }
    
}

- (IBAction)videoVai:(id)sender {
    self.act.hidden = NO;
    [self.act startAnimating];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];

    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[@"public.movie"];
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    imagePicker.delegate = self;
    imagePicker.videoMaximumDuration = 60;
    [self presentViewController:imagePicker animated:YES completion:NULL];
}
- (IBAction)loadVideo:(id)sender {
    self.act.hidden = NO;
    [self.act startAnimating];
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie, nil];
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}


@end
