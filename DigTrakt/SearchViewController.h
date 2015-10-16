//
//  ViewController.h
//  DigTrakt
//
//  Created by Mohamed Gwely on 16/10/15.
//  Copyright (c) 2015 Mohamed Gwely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;



@end

