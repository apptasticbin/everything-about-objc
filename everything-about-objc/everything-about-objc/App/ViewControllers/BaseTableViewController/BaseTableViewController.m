//
//  BaseTableViewController.m
//  everything-about-objc
//
//  Created by Bin Yu on 22/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
}

- (void)setupTableViewCell {
    // must override this method
    @throw NSGenericException;
}

@end
