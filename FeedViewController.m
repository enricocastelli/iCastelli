//
//  FeedViewController.m
//  iCastelli
//
//  Created by Eyolph on 19/11/15.
//  Copyright © 2015 Eyolph. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedCell.h"
#import "UserViewController.h"
#import "DetailViewController.h"
#import "CreateNewViewController.h"
#import "MapViewController.h"
#import "SearchViewController.h"
#import "SettingsViewController.h"

@interface FeedViewController () <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) PFGeoPoint *point;
@property (strong, nonatomic) PFQuery *userQuery;
@property (strong, nonatomic) PFQuery *commentQuery;
@property (weak, nonatomic) UIView *header;



@end

@implementation FeedViewController

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        [self awakeFromNib];
        UIImage *im =[UIImage imageNamed:@"table"];
        UIImageView *v = [[UIImageView alloc]initWithImage:im];
        v.alpha = 0.25;
        self.tableView.backgroundView = v;
       
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.header = [[[NSBundle mainBundle] loadNibNamed:@"HeaderFeedView" owner:self options:nil]firstObject];
    self.header.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    [self.view addSubview:self.header];
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setAllowsMultipleSelection:NO];
    self.navigationController.toolbar.tintColor = [UIColor whiteColor];

    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            self.point = geoPoint;
        }
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    

    [self.tableView registerNib:[UINib nibWithNibName:@"FeedCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomFeedCell" bundle:nil] forCellReuseIdentifier:@"myCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellReuseIdentifier:@"imageCell"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 11);

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIImage *userB = [UIImage imageNamed:@"star"];
    UIBarButtonItem *user = [[UIBarButtonItem alloc] initWithImage:userB style:UIBarButtonItemStylePlain target:self action:@selector(user)];
    UIImage *newB = [UIImage imageNamed:@"new"];

    UIBarButtonItem *new = [[UIBarButtonItem alloc] initWithImage:newB style:UIBarButtonItemStylePlain target:self action:@selector(new)];
    
    UIImage *mapB = [UIImage imageNamed:@"world"];

    UIBarButtonItem *map = [[UIBarButtonItem alloc] initWithImage:mapB style:UIBarButtonItemStylePlain target:self action:@selector(map)];
    
    UIImage *searchB = [UIImage imageNamed:@"search"];

    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithImage:searchB style:UIBarButtonItemStylePlain target:self action:@selector(search)];
    UIImage *peopleB = [UIImage imageNamed:@"user"];

    UIBarButtonItem *people = [[UIBarButtonItem alloc] initWithImage:peopleB style:UIBarButtonItemStylePlain target:self action:@selector(people)];
  
    self.toolbarItems = @[user, space, people, space, new, space, map, space, search];
    
     
}

- (void)viewWillAppear:(BOOL)animated
{

    [self loadObjects];
    [self.tableView reloadData];
    
    if ([self.created  isEqual: @"YES"]) {
        [self.tableView setContentOffset:CGPointZero animated:YES];
        self.created = @"NO";
    } else {
        self.created =@"op";
    }


    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = NO;

    

    self.tableView.separatorColor = [UIColor clearColor];
    
 
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView * _Nonnull)tableView
{
    return 1;
}

- (NSString * _Nullable)tableView:(UITableView * _Nonnull)tableView
          titleForHeaderInSection:(NSInteger)section
{
    return @" ";
}

- (CGFloat)tableView:(UITableView * _Nonnull)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 120;
}




-(void)user
{
    UserViewController *h = [[UserViewController alloc]init];
    h.user = [PFUser currentUser];
    
    h.view.alpha = 0;
    
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.navigationController pushViewController:h animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                         h.view.alpha = 1.0;
                         self.navigationController.navigationBar.alpha = 1.0;
                     }];

    
}

-(void)new
{
    CreateNewViewController *c = [[CreateNewViewController alloc]init];
    c.view.alpha = 0;
    
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.navigationController pushViewController:c animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                         c.view.alpha = 1.0;
                         self.navigationController.navigationBar.alpha = 1.0;
                         
                     }];
}

-(void)people
{
    SettingsViewController *c = [[SettingsViewController alloc]init];
    c.view.alpha = 0;
    
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.navigationController pushViewController:c animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                         c.view.alpha = 1.0;
                         self.navigationController.navigationBar.alpha = 1.0;
                         
                     }];
}

-(void)map
{
    MapViewController *m = [[MapViewController alloc] init];
    m.castelli = nil;
    m.view.alpha = 0;
    
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.navigationController pushViewController:m animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                         m.view.alpha = 1.0;
                         self.navigationController.navigationBar.alpha = 1.0;
                     }];
}

- (void)search {
    SearchViewController *s = [[SearchViewController alloc] init];
    s.view.alpha = 0;
    
    self.navigationController.navigationBar.alpha = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.navigationController pushViewController:s animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
                         s.view.alpha = 1.0;
                         self.navigationController.navigationBar.alpha = 1.0;
                     }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
    
    if (self.point) {
    
    PFUser *user = [PFUser currentUser];
    
    user[@"annotation"] = self.point;
        
        NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
    
        user[@"annotationDate"] = now;
    [user saveInBackground];
    }
    [self.tableView setUserInteractionEnabled:YES];

}


- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"Feeds"];
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    [self.tableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];

    PFObject*ob = self.objects[indexPath.row];

    
    if ([[PFUser currentUser].username isEqualToString: ob[@"user"]]) {
        
        FeedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
        
        [self cell:cell index:indexPath];
        
        cell.userLabel.text = @"me";
        cell.userLabel.textColor = [UIColor colorWithRed:0.8 green:0.1 blue:0.3 alpha:1];
        
        cell.endColor.backgroundColor = [UIColor lightGrayColor];
        
        [self.tableView setRowHeight:200];
        if (ob[@"image"] == nil) {
            cell.image.hidden = YES;

        } else {
            cell.image.hidden = NO;
            
            cell.image.file = ob[@"image"];
            [cell.image loadInBackground];
            cell.image.layer.cornerRadius = 10;
            cell.image.clipsToBounds = YES;
            cell.image.transform = CGAffineTransformMakeRotation(0);

  
            if (ob[@"video"]) {
                cell.miniPlay.hidden = NO;
                cell.image.transform = CGAffineTransformMakeRotation(M_PI/2);

                
            }

        }

        
        return cell;

        
    } else if (ob[@"image"]) {
        
        FeedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];

        [self cell:cell index:indexPath];
        
        cell.image.hidden = NO;
        cell.playOverlay.hidden = YES;

        
        cell.image.file = ob[@"image"];
        [cell.image loadInBackground];
        cell.image.layer.cornerRadius = 10;
        cell.image.clipsToBounds = YES;
        
        [self.tableView setRowHeight:407];
        cell.image.transform = CGAffineTransformMakeRotation(0);


        if (ob[@"video"]) {
            cell.playOverlay.hidden = NO;
            cell.image.transform = CGAffineTransformMakeRotation(M_PI/2);
            [self.tableView setRowHeight:407];


        }
        
        return cell;
    
    } else {
        
        
    FeedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

        [self cell:cell index:indexPath];
        
        [self.tableView setRowHeight:200];

    
    return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setUserInteractionEnabled:NO];
    
    FeedCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.act.hidden = NO;
    [cell.act startAnimating];
    
  
    PFObject *selected = self.objects[indexPath.row];
    DetailViewController*dtl = [[DetailViewController alloc]init];
    dtl.object = selected;
 
    self.commentQuery = [PFQuery queryWithClassName:@"Comments"];

    [self.commentQuery whereKey:@"feedID" equalTo:selected.objectId];
    [self.commentQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        dtl.count = [[NSNumber alloc]initWithInt:number];
        dtl.query = self.commentQuery;
          self.userQuery = [PFUser query];
        [self.userQuery whereKey:@"username" equalTo:selected[@"user"]];
        [self.userQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            dtl.user = object;
            [self.navigationController pushViewController:dtl animated:YES];
        }];

    }];

}

- (UITableViewCell*)cell:(FeedCell *)cell index:(NSIndexPath *)indexPath
{
    PFObject*ob = self.objects[indexPath.row];

    cell.miniPlay.hidden = YES;
    cell.backgroundColor = [UIColor clearColor];
    cell.userLabel.text = ob[@"user"];
    cell.act.hidden = YES;
    
    cell.endColor.backgroundColor = [UIColor colorWithRed:1 green:0.43137 blue:0.29019 alpha:1];

    
    cell.dateLabel.text = [self returningTheDate:ob[@"created"]];
    
    cell.image.hidden = YES;
    
    self.userQuery = [PFUser query];
    
    [self.userQuery whereKey:@"username" equalTo:ob[@"user"]];
    
    self.commentQuery = [PFQuery queryWithClassName:@"Comments"];
    
    [self.commentQuery whereKey:@"feedID" equalTo:ob.objectId];
    [self.commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSInteger numb = objects.count;
        cell.commentLabel.text = [NSString stringWithFormat:@"%i commenti", numb];
    }];
    
    [self.userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        
        for (PFObject *obu in objects)
        {
            if (obu[@"image"]) {
                cell.iconView.hidden = NO;
                cell.iconView.file = obu[@"image"];
                [cell.iconView loadInBackground];
            } else {
                cell.iconView.hidden = YES;
            }
            
        }
        
        
    }];
    
    
    cell.messageLabel.text = ob[@"text"];
    
    return cell;
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





@end
