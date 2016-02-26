//
//  DetailViewController.m
//  everything-about-objc
//
//  Created by Bin Yu on 20/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DetailViewController.h"
#import "BaseExperiment.h"
#import "CaseModel.h"
#import "CaseResultViewController.h"
#import "CaseTableViewCell.h"
#import "ExperimentModel.h"
#import <objc/objc-runtime.h>

NSString * const CaseTableViewCellId = @"CaseTableViewCellId";
NSString * const CaseTableViewCellNibName = @"CaseTableViewCell";

@interface DetailViewController ()<ExperimentDelegate>

@property(nonatomic, strong) NSArray *caseModels;
@property(nonatomic, strong) BaseExperiment *experiment;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupExperiment];
    [self loadCaseSelectors];
}

- (void)setupNavigationBar {
    self.navigationItem.title = self.expModel.displayName;
}

- (void)setupExperiment {
    self.experiment = [self.expModel experimentInstance];
    self.experiment.delegate = self;
}

- (void)loadCaseSelectors {
    self.caseModels = self.expModel.caseModels;
    [self.tableView reloadData];
}

- (void)setupTableViewCell {
    /**NOTICE:
     - remember to setup 'reuse identifier' in nib file
     - pin subviews's vertical constrains to 'ContentView' WITHOUT margins.
     - set title label's 'compression resistance' to high priority
     */
    UINib *caseTableViewCellNib = [UINib nibWithNibName:CaseTableViewCellNibName bundle:nil];
    [self.tableView registerNib:caseTableViewCellNib forCellReuseIdentifier:CaseTableViewCellId];
}

#pragma mark - Private

- (void)showResultObject:(id)resultObject {
    CaseResultViewController *viewController = [CaseResultViewController new];
    viewController.resultObject = resultObject;
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.caseModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CaseTableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:CaseTableViewCellId
                                        forIndexPath:indexPath];
    if (!cell) {
        cell =
            [[CaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CaseTableViewCellId];
    }
    CaseModel *caseModel = self.caseModels[indexPath.row];
    cell.textLabel.text = caseModel.displayName;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL caseSelector = [self.caseModels[indexPath.row] caseSelector];
    [self.experiment runExperimentCase:caseSelector];
}

#pragma mark - ExperimentDelegate

- (void)caseFinishedWithResultView:(UIView *)resultView {
    [self showResultObject:resultView];
}

- (void)caseFinishedWithResultViewController:(UIViewController *)resultViewController {
    [self showResultObject:resultViewController];
}


@end
