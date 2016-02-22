//
//  DetailViewController.m
//  everything-about-objc
//
//  Created by Bin Yu on 20/02/16.
//  Copyright © 2016 Bin Yu. All rights reserved.
//

#import "DetailViewController.h"
#import "BaseExperiment.h"
#import "CaseTableViewCell.h"
#import "ExperimentModel.h"
#import <objc/objc-runtime.h>

NSString * const CaseTableViewCellId = @"CaseTableViewCellId";
NSString * const CaseTableViewCellNibName = @"CaseTableViewCell";

@interface DetailViewController ()

@property(nonatomic, strong) NSArray *caseSelectors;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCaseSelectors];
}

- (void)loadCaseSelectors {
    BaseExperiment *baseExp = [self.expModel experimentInstance];
    self.caseSelectors = baseExp.caseSelectors;
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

- (NSString *)removeSuffix:(NSString *)suffix fromString:(NSString *)orig {
    return [orig stringByReplacingOccurrencesOfString:suffix withString:@""];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.caseSelectors count];
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
    SEL caseSelector;
    [self.caseSelectors[indexPath.row] getValue:&caseSelector];
    if (caseSelector) {
        cell.textLabel.text =
            [self removeSuffix:ExperimentCaseMethodSuffix
                    fromString: NSStringFromSelector(caseSelector)];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


@end
