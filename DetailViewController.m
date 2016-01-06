//
//  DetailViewController.m
//  iCastelli
//
//  Created by Eyolph on 23/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "DetailViewController.h"
#import "ReadViewController.h"
#import "UserViewController.h"
#import "FullImageViewController.h"
#import "VideoViewController.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *userLabel;
@property (weak, nonatomic) IBOutlet UITextView *textLabel;

@property (weak, nonatomic) IBOutlet PFImageView *image;
@property (weak, nonatomic) IBOutlet PFImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *showComments;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    [self.userLabel setTitle:self.object[@"user"] forState:UIControlStateNormal];
    self.textLabel.text = self.object[@"text"];
    
    self.dateLabel.text = [self returningTheDate:self.object[@"created"]];
    
    if (self.object[@"image"] == nil) {
        self.image.frame = CGRectMake(0, 0, 1, 1);
        
    } else {
    self.image.file = self.object[@"image"];
    [self.image loadInBackground];
        self.image.layer.cornerRadius = 15;
        self.image.clipsToBounds = YES;


    }
        self.iconView.file = self.user[@"image"];
        [self.iconView loadInBackground];
    
    [self setRightButton];
    if (self.object[@"video"]) {
        self.playButton.hidden = NO;
        self.image.transform = CGAffineTransformMakeRotation(M_PI/2);

    } else {
        self.playButton.hidden = YES;
    }
}

- (IBAction)showComments:(id)sender
{
    
    if (self.tableView.hidden == NO) {
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.tableView.center = CGPointMake(self.tableView.center.x, self.tableView.center.y - 500);
        } completion:^(BOOL finished) {
            [self.showComments setTitle:@"Mostra i commenti" forState:UIControlStateNormal];
            self.tableView.hidden = YES;
    
            [self setRightButton];
        }];
        
    } else {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.tableView.alpha = 1;
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, 500, self.tableView.frame.size.width, self.tableView.frame.size.height);
        } completion:nil];
        self.tableView.hidden = NO;
        [self.showComments setTitle:@"Nascondi i commenti" forState:UIControlStateNormal];
        UIBarButtonItem *comment = [[UIBarButtonItem alloc] initWithTitle:@"Commenta" style:UIBarButtonItemStylePlain target:self action:@selector(comment)];
        self.navigationItem.rightBarButtonItem = comment;
    }
}

- (IBAction)userButton:(id)sender {
    PFUser *user = [PFUser currentUser];
    
    if ([user.username isEqualToString: self.object[@"user"]]) {
        UserViewController *u = [[UserViewController alloc] init];
        u.user = user;
        [self.navigationController pushViewController:u animated:YES];
    } else {
        
        ReadViewController *r = [[ReadViewController alloc] init];
        r.user = self.user;
        [self.navigationController pushViewController:r animated:YES];
    }
    
}

- (void)setRightButton
{
    PFUser *user = [PFUser currentUser];
    if ([user.username isEqualToString: self.object[@"user"]]) {
        
        UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"Elimina" style:UIBarButtonItemStylePlain target:self action:@selector(deletePost)];
        self.navigationItem.rightBarButtonItem = delete;
        
    } else {
        UIBarButtonItem *comment = [[UIBarButtonItem alloc] initWithTitle:@"Commenta" style:UIBarButtonItemStylePlain target:self action:@selector(comment)];
        self.navigationItem.rightBarButtonItem = comment;
        
    }
}


#pragma mark - table view


- (NSString *)tableView:(UITableView *)tableView
          titleForHeaderInSection:(NSInteger)section
{
    if (self.count.intValue == 0) {
        return @"Nessun commento";
    } else {
        return @"Commenti";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.count.intValue;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];

    self.query = [PFQuery queryWithClassName:@"Comments"];
    [self.query whereKey:@"feedID" equalTo:self.object.objectId];
    [self.query orderByDescending:@"createdAt"];
    [self.query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        cell.textLabel.text = objects[indexPath.row][@"user"];
        cell.detailTextLabel.text = objects[indexPath.row][@"text"];
    }];
    return cell;
}

- (void)deletePost
{
    UIAlertController *sure = [UIAlertController alertControllerWithTitle:@"Vuoi eliminare questo post?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *Ok = [UIAlertAction actionWithTitle:@"Si" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [sure addAction:no];
    [sure addAction:Ok];
    [self presentViewController:sure animated:YES completion:nil];

    
}

- (void)comment
{
    UIAlertController *comment = [UIAlertController alertControllerWithTitle:@"Aggiungi un Commento" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [comment addTextFieldWithConfigurationHandler:nil];
    [comment.textFields[0] becomeFirstResponder];
    UIAlertAction *send = [UIAlertAction actionWithTitle:@"Commenta" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PFObject *newComment = [PFObject objectWithClassName:@"Comments"];
        newComment[@"user"] = [PFUser currentUser].username;
        newComment[@"text"] = comment.textFields[0].text;
        newComment[@"feedID"] = self.object.objectId;
        [newComment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            UIAlertController *done = [UIAlertController alertControllerWithTitle:@"Commento Aggiunto!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:done animated:YES completion:^{
                [UIView animateWithDuration:1.0 animations:^{
                    self.view.alpha = 1;
                    self.iconView.alpha = 0.8;
                } completion:^(BOOL finished) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    self.count = [[NSNumber alloc] initWithInt:(self.count.intValue +1)];
                    [self.tableView reloadData];
                    self.iconView.alpha = 1;
                    [self.showComments sendActionsForControlEvents:UIControlEventTouchUpInside];
                }];
                
            }];
            

        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Annulla" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [comment addAction:cancel];
    [comment addAction:send];
    [self presentViewController:comment animated:YES completion:nil];
}
- (NSString*)returningTheDate:(NSDate*)date

{
    NSTimeInterval timeSinceDate = [[NSDate date] timeIntervalSinceDate:date];
    
    float hoursSinceDate = (float)(timeSinceDate / (60.0 * 60.0));
    NSInteger hourse = (NSInteger)hoursSinceDate;
    
    int minute = (int)(hoursSinceDate *60);
    
    if(hoursSinceDate < 0.1){
        
        NSString *formattedDateString = [NSString stringWithFormat:@"adesso"];
        
        return formattedDateString;
    }
    if(hoursSinceDate < 1){
        
        NSString *formattedDateString = [NSString stringWithFormat:@"%i minuti fa", minute];
        
        return formattedDateString;
    }
    if(hoursSinceDate < 2)
    {
        NSString *formattedDateString = [NSString stringWithFormat:@"%i ora fa" , hourse];
        
        return formattedDateString;    }
    
    if(hoursSinceDate < 8)
    {
        NSString *formattedDateString = [NSString stringWithFormat:@"%i ore fa" , hourse];
        
        return formattedDateString;    }
    
    
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM 'alle' HH"];
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        
        return formattedDateString;
    }
}

- (IBAction)openImage:(id)sender {
    if (self.object[@"image"] == nil) {
        nil;
    } else {
    FullImageViewController *full = [[FullImageViewController alloc]init];
    full.photo = self.object[@"image"];
    [self.navigationController pushViewController:full animated:YES];
    }
}

- (IBAction)playVideo:(id)sender {
    VideoViewController *v = [[VideoViewController alloc] init];
    v.videoFile = self.object[@"video"];
    
    [self.navigationController pushViewController:v animated:YES];
    
    
}




@end
