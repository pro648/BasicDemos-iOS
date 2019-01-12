//  ContentsViewController.m
//  WebKit
//
//  Created by pro648 on 2018/12/24
//  Copyright © 2018 pro648. All rights reserved.
//

#import "ContentsViewController.h"

@interface ContentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *entries;
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ContentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entries = [self makeEntriesWithMessageBody:self.messageBody];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(ContentsViewController.class)];
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.tableView];
    
    self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    UILayoutGuide *layoutGuide = self.view.safeAreaLayoutGuide;
    
    [self.navigationBar.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor].active = YES;
    [self.navigationBar.leadingAnchor constraintEqualToAnchor:layoutGuide.leadingAnchor].active = YES;
    [self.navigationBar.trailingAnchor constraintEqualToAnchor:layoutGuide.trailingAnchor].active = YES;
    
    [self.tableView.topAnchor constraintEqualToAnchor:self.navigationBar.bottomAnchor].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:layoutGuide.leadingAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:layoutGuide.bottomAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:layoutGuide.trailingAnchor].active = YES;
}

- (NSArray *)makeEntriesWithMessageBody:(NSArray *)messageBody {
    NSMutableArray *entries = [NSMutableArray arrayWithCapacity:messageBody.count];
    
    for (id element in messageBody) {
        if (![element isKindOfClass:NSDictionary.class]) {
            continue;
        }
        
        id title = element[@"title"];
        if (![title isKindOfClass:NSString.class]) {
            continue;
        }
        
        id urlString = element[@"urlString"];
        if (![urlString isKindOfClass:NSString.class] || !urlString) {
            continue;
        }
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        Entry *entry = [[Entry alloc] initWithTitle:title url:url];
        [entries addObject:entry];
    }
    return entries;
}

- (void)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ContentsViewController.class) forIndexPath:indexPath];
    
    Entry *entry = self.entries[indexPath.row];
    cell.textLabel.text = entry.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Entry *entry = self.entries[indexPath.row];
    if (self.didSelectEntry) {
        self.didSelectEntry(entry);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getters & Setters

- (UINavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UINavigationBar alloc] init];
        UINavigationItem *navItem = [[UINavigationItem alloc] init];
        navItem.title = @"Contents";
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(doneButtonTapped:)];
        navItem.leftBarButtonItem = doneButton;
        _navigationBar.items = @[navItem];
    }
    return _navigationBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
