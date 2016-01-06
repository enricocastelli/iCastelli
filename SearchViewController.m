//
//  SearchViewController.m
//  iCastelli
//
//  Created by Eyolph on 06/12/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "SearchViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "DetailViewController.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *objects;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchButton.layer.cornerRadius = self.searchButton.frame.size.width/10;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.hidden = YES;
    self.act.hidden =YES;


}

- (IBAction)search:(id)sender
{
    [self.searchField resignFirstResponder];
    PFQuery*que = [PFQuery queryWithClassName:@"Feeds"];
    [que whereKey:@"text" containsString:self.searchField.text];
    [que findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.objects = objects;
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.objects.count == 0) {
        return 1;
    } else {
        
    return self.objects.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (self.objects.count == 0) {
        
        cell.textLabel.text = @"Nessun Risultato!";
        
        self.tableView.allowsSelection = NO;
        
        return cell;

        
    } else {
        PFObject *ob = self.objects[indexPath.row];

        self.tableView.allowsSelection = YES;

        cell.textLabel.text = ob[@"text"];
        
        cell.detailTextLabel.text = ob[@"user"];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.act.hidden = NO;
    [self.act startAnimating];
    DetailViewController *d = [[DetailViewController alloc]init];
    PFObject*selected = self.objects[indexPath.row];

    d.object = selected;
    PFQuery* commentQuery = [PFQuery queryWithClassName:@"Comments"];
    
    [commentQuery whereKey:@"feedID" equalTo:selected.objectId];
    [commentQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        d.count = [[NSNumber alloc]initWithInt:number];
        d.query = commentQuery;
        PFQuery *userQuery = [PFUser query];
        [userQuery whereKey:@"username" equalTo:self.objects[indexPath.row][@"user"]];
        [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            d.user = object;
            self.act.hidden =YES;
            [self.act stopAnimating];
            [self.navigationController pushViewController:d animated:YES];
    }];
    

    
    
    }];
}



@end
