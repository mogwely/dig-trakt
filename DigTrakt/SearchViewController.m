//
//  ViewController.m
//  DigTrakt
//
//  Created by Mohamed Gwely on 16/10/15.
//  Copyright (c) 2015 Mohamed Gwely. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // 64 point margin (20 status bar + 44 UISearchBar).
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableView data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}
    


@end
