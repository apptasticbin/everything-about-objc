//
//  ViewController.m
//  everything-about-objc
//
//  Created by Bin Yu on 20/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "MainViewController.h"
#import "ExperimentCaseModel.h"
#import "ExperimentDataSource.h"
#import "ExperimentTableViewCell.h"

static NSString * const ExperimentTableViewCellId = @"ExperimentTableViewCellId";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate>

@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *experiments;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchBar];
    [self setupTableView];
    [self loadExperiments];
}

- (void)setupSearchBar {
    if (self.navigationController) {
        self.navigationItem.titleView = self.searchBar;
    }
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    //NOTICE: remember to setup 'reuse identifier' in nib file
    UINib *experimentTableViewCellNib = [UINib nibWithNibName:@"ExperimentTableViewCell" bundle:nil];
    [self.tableView registerNib:experimentTableViewCellNib forCellReuseIdentifier:ExperimentTableViewCellId];
}

- (void)loadExperiments {
    ExperimentDataSource *dataSource = [ExperimentDataSource sharedDataSource];
    __weak MainViewController *weakSelf = self;
    [dataSource loadExperimentsComplete:^(NSArray *experiments) {
        weakSelf.experiments = experiments;
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    ExperimentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ExperimentTableViewCellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[ExperimentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ExperimentTableViewCellId];
        cell.detailsLabel.numberOfLines = 0;
    }
    ExperimentCaseModel *caseModel = self.experiments[indexPath.row];
    cell.titleLabel.text = caseModel.caseName;
    cell.detailsLabel.text = caseModel.caseDescription;
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - UISearchBarDelegate

@end
