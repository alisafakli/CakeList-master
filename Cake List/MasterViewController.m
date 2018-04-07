//
//  MasterViewController.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "MasterViewController.h"
#import "CakeCell.h"
#import "APIManager.h"
#import "CakeModel.h"

@interface MasterViewController ()

@property (weak, nonatomic) IBOutlet UIRefreshControl *refreshControl;

@property (strong, nonatomic) NSArray *objects;
@end

@implementation MasterViewController
@synthesize refreshControl = _refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    [_refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[APIManager sharedInstance] getCakesDataWithCompletion:^(NSArray *dict, NSError *error) {
        if (error == nil) {
            self.objects = dict;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}
     
 -(void) refreshTableView {
     [self.tableView reloadData];
     [_refreshControl endRefreshing];
 }

#pragma mark - Table View
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 70;
    return 200;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CakeCell *cell = (CakeCell*)[tableView dequeueReusableCellWithIdentifier:@"CakeCell2"];
    //CakeCell *cell = (CakeCell*)[tableView dequeueReusableCellWithIdentifier:@"CakeCell"];

    
    CakeModel *object = self.objects[indexPath.row];
    cell.titleLabel.text = [object.title capitalizedString];
    cell.descriptionLabel.text = [object.desc capitalizedString];
    cell.cakeImageView.image = nil;
    
    object.image = [object.image stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    
    [[APIManager sharedInstance] downloadImage:object.image withCompletion:^(UIImage *img) {
        if (img) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.cakeImageView.image = img;
                [cell setNeedsLayout];
            });
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
