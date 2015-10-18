//
//  ViewController.m
//  DigTrakt
//
//  Created by Mohamed Gwely on 16/10/15.
//  Copyright (c) 2015 Mohamed Gwely. All rights reserved.
//

#import "SearchViewController.h"
#import "Constants.h"
#import "TraktAPIClient.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
{
    NSMutableArray *_searchResults;
    NSString* _searchQuery;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 64 point margin (20 status bar + 44 UISearchBar).
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    TraktAPIClient* client = [TraktAPIClient sharedClient];
    
   /* [client getMoviesForQuery:_searchQuery
                      success:^(NSURLSessionDataTask* task, id responseObject) {
                        NSLog(@"Success -- %@", responseObject);
                    }
                      failure:^(NSURLSessionDataTask* task, NSError* error) {
                        NSLog(@"Failure -- %@", error);
                    }];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(_searchResults == nil){
        
        return 0;
        
    }else{
        return [_searchResults count];
        
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_RESULT_CELL_IDENTIFIER];
    cell.textLabel.text = _searchResults[indexPath.row];
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    
    for(int i=0; i<3; i++){
        [_searchResults addObject:[NSString stringWithFormat:@"fake text %d for '%@'", i, searchBar.text]];
    }
    
    [self.tableView reloadData];
    
}

/**
 *  attaches the UISearchBar to the Status bar
 *
 *  @param bar the UISearchBar
 *
 *  @return The position of the UISearchBar
 */
- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    
    return UIBarPositionTopAttached;
}


@end
