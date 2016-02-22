//
//  ViewController.m
//  everything-about-objc
//
//  Created by Bin Yu on 20/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "ExperimentModel.h"
#import "ExperimentDataSource.h"
#import "ExperimentTableViewCell.h"

NSString * const ExperimentTableViewCellId = @"ExperimentTableViewCellId";
NSString * const ExperimentTableViewCellNibName = @"ExperimentTableViewCell";

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate>

@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) NSArray *experiments;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchBar];
    [self loadExperiments];
}

- (void)setupSearchBar {
    if (self.navigationController) {
        self.navigationItem.titleView = self.searchBar;
    }
}

- (void)setupTableViewCell {
    /**NOTICE:
     - remember to setup 'reuse identifier' in nib file
     - pin subviews's vertical constrains to 'ContentView' WITHOUT margins.
     - set title label's 'compression resistance' to high priority
     */
    UINib *experimentTableViewCellNib = [UINib nibWithNibName:ExperimentTableViewCellNibName bundle:nil];
    [self.tableView registerNib:experimentTableViewCellNib forCellReuseIdentifier:ExperimentTableViewCellId];
}

- (void)loadExperiments {
    ExperimentDataSource *dataSource = [ExperimentDataSource sharedDataSource];
    __weak MainViewController *weakSelf = self;
    [dataSource loadExperimentsComplete:^(NSArray *experiments) {
        weakSelf.experiments = experiments;
        [weakSelf.tableView reloadData];
    }];
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
    }
    return _searchBar;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.experiments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExperimentTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:ExperimentTableViewCellId
                                        forIndexPath:indexPath];
    if (!cell) {
        cell =
            [[ExperimentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:ExperimentTableViewCellId];
    }
    ExperimentModel *expModel = self.experiments[indexPath.row];
    cell.titleLabel.text = expModel.displayName;
    cell.detailsLabel.text = expModel.displayDesc;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExperimentModel *expModel = [self.experiments objectAtIndex:indexPath.row];
    DetailViewController *vc = [[DetailViewController alloc] init];
    vc.expModel = expModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate

@end
