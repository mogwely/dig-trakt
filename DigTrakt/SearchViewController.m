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
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
{
    TraktAPIClient* _client;
    bool _popularMoviesSwitch;
    NSMutableArray *_searchResults;
    NSString* _searchQuery;
    NSInteger _currentPage;
    NSInteger _totalPages;
    NSInteger _totalItems;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 64 point margin (20 status bar + 44 UISearchBar).
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 190.0;
    
    //Start paging
    _currentPage = 1;
    
    UINib* cellNib = [UINib nibWithNibName:SEARCH_RESULT_CELL_NIB bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SEARCH_RESULT_CELL_IDENTIFIER];
    
    cellNib = [UINib nibWithNibName:NOTHING_FOUND_CELL_NIB bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NOTHING_FOUND_CELL_IDENTIFIER];
    
    cellNib = [UINib nibWithNibName:LOADING_CELL_NIB bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:LOADING_CELL_IDENTIFIER];
    
    _client = [TraktAPIClient sharedClient];
    
    //Show popular movies on launch
    _popularMoviesSwitch = true;
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    [self loadPopularMovies:_currentPage];

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
        
    //End of results
    }else if(_currentPage == _totalPages) {
        return [_searchResults count];
    
    //Searched with results
    }else{
        return [_searchResults count] +1;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //No results match the query
    if ([_searchResults count] == 0) {
        
        return [tableView dequeueReusableCellWithIdentifier: NOTHING_FOUND_CELL_IDENTIFIER];
     
    //Fetching results
    }else if(indexPath.row<[_searchResults count]) {
        
        SearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_RESULT_CELL_IDENTIFIER forIndexPath:indexPath];
        
        Movie* movie = _searchResults[indexPath.row];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", movie.title, movie.year];
        cell.overviewLabel.text = movie.overview;
        
        if(movie.posterUrl){
            dispatch_async(kBgQueue, ^{
                NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",movie.posterUrl]]];
                if (imgData) {
                    UIImage *image = [UIImage imageWithData:imgData];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            SearchResultCell* updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                            if (updateCell)
                                updateCell.posterImageView.image = image;
                        });
                    }
                }
            });

        }
        
        [cell layoutIfNeeded];
        return cell;
        
     //End of resultset..fetching new resultset..
    }else if (indexPath.row == [_searchResults count]) {
        
        [tableView dequeueReusableCellWithIdentifier:LOADING_CELL_IDENTIFIER forIndexPath:indexPath];
        
    }
    return [tableView dequeueReusableCellWithIdentifier: LOADING_CELL_IDENTIFIER];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([_searchResults count] == 0){
        return  nil;
        
    }else{
        return indexPath;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [_searchResults count] - 1 ) {
        if(_popularMoviesSwitch){
            [self loadPopularMovies:++_currentPage];
        }else{
            [self loadResultSet: ++_currentPage];
        }
    }
}

#pragma mark - UISearchBarDelegate

/**
 *  Searches on clicking search
 *
 *  @param searchBar UISearchBar
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    //Scroll back to top
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];

    _currentPage = 1;
    _totalPages = 0;
    _totalItems = 0;
    _searchQuery = searchBar.text;
    
    [self loadResultSet:_currentPage];
    
}

/**
 *  searches instantly on text change
 *
 *  @param searchBar UISearchBar
 *  @param searchText NSSTring
 */
-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    //Scroll back to top
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    _currentPage = 1;
    _totalPages = 0;
    _totalItems = 0;
    _searchQuery = searchText;
    
    if([searchText length]>0){
        [self loadResultSet:_currentPage];
    }else{
        [self loadPopularMovies:_currentPage];
    }
}


#pragma mark -

/**
 *
 *  Loads the most popular movies
 *
 * @param page NSInteger current page number
 */
-(void) loadPopularMovies:(NSInteger)page{
    
    [_client getPopularMoviesByPage:page
                            success:^(NSURLSessionDataTask* task, id responseObject)
                           {
                                if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                                    NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
                                    NSDictionary* headers = [r allHeaderFields];
                                    [self updatePaginationValues:headers];
                                }

                               for(NSDictionary* dict in responseObject){
                                   Movie* movie = [self mapMovieDictionaryToObject:dict];
                                   [_searchResults addObject:movie];
                               }
         
                               [self.tableView reloadData];
                           }
     
                            failure:^(NSURLSessionDataTask* task, NSError* error) {
                                NSLog(@"Failure -- %@", error);
                            }];
    
}



/**
 *
 *  Loads the next/inital set of results for a serach query
 *
 * @param page NSInteger current page number
 */
-(void) loadResultSet:(NSInteger)page{
    
    [_client getMoviesForQuery:_searchQuery
                          page:page
                       success:^(NSURLSessionDataTask* task, id responseObject)
                      {
                          if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                              NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
                              NSDictionary* headers = [r allHeaderFields];
                              [self updatePaginationValues:headers];
                          }
                          
                            for(NSDictionary* dict in responseObject){
                                NSDictionary* movieDict = dict[@"movie"];
                                Movie* movie = [self mapMovieDictionaryToObject:movieDict];
                                [_searchResults addObject:movie];
                            }
                          
                            [self.tableView reloadData];
                       }
     
                       failure:^(NSURLSessionDataTask* task, NSError* error) {
                           NSLog(@"Failure -- %@", error);
                       }];
    
}

/**
 *  extracts the pagination values from the http headers of the response
 *
 *  @param headers NSDictionary the dictionary containing http headers
 */
-(void) updatePaginationValues:(NSDictionary*) headers{
    
    _totalItems = [headers[@"x-pagination-item-count"] integerValue];
    _currentPage = [headers[@"x-pagination-page"] integerValue];
    _totalPages = [headers[@"x-pagination-page-count"] integerValue];
}

/**
 *  extracts the relevant values from json result and assign them to a new Movie object
 *
 *  @param dict NSDictionary from the json response
 *
 *  @return movie Movie object
 */
- (Movie*) mapMovieDictionaryToObject:(NSDictionary*)dict{
    
    Movie* movie = [[Movie alloc] init];
    
    movie.title = dict[@"title"];
    movie.year = dict[@"year"];

    if(movie.year ==  nil){
        movie.year = @"Unknown production year";
    }
    movie.overview = dict[@"overview"];
    if([movie.overview isEqualToString: @""] || [movie.overview isEqualToString:@" "] || movie.overview ==  nil){
        movie.overview = @"Overview is not available for this movie.";
    }
    if([dict valueForKeyPath:@"images.poster.thumb"]!= nil){
        movie.posterUrl = [dict valueForKeyPath:@"images.poster.thumb"];
    }
    
    return movie;
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
