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
#import "Movie.h"
#import "SearchResultCell.h"

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
    
    self.tableView.rowHeight = 80;
    
    UINib* cellNib = [UINib nibWithNibName:SEARCH_RESULT_CELL_NIB bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SEARCH_RESULT_CELL_IDENTIFIER];
    
    cellNib = [UINib nibWithNibName:NOTHING_FOUND_CELL_NIB bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NOTHING_FOUND_CELL_IDENTIFIER];
    
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
    
    //User didnt search yet.
    if(_searchResults == nil){
        
        return 0;
        
    //User searched but no results match the query
    }else if([_searchResults count] == 0){
        
        return 1;
        
    //Searched with results
    }else{
        return [_searchResults count];
        
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //No results match the query
    if ([_searchResults count] == 0) {
        
        return [tableView dequeueReusableCellWithIdentifier: NOTHING_FOUND_CELL_IDENTIFIER];
        
    }else {
        
        SearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_RESULT_CELL_IDENTIFIER];
        
        Movie* movie = _searchResults[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ produced in %@", movie.title, movie.year];
        cell.overviewLabel.text = movie.overview;
        
        return cell;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_searchResults count] == 0){
        return  nil;
        
    }else{
        return indexPath;
    }
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    
    for(int i=0; i<3; i++){
        Movie* movie = [[Movie alloc] init];
        movie.title = [NSString stringWithFormat:@"%@",searchBar.text];
        movie.year = @"1999";
        movie.overview = [NSString stringWithFormat:@"fake overview for %d", i];
        [_searchResults addObject:movie];
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
