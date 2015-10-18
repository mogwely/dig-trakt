//
//  SearchResultCell.h
//  DigTrakt
//
//  Created by Mohamed Gwely on 18/10/15.
//  Copyright (c) 2015 Mohamed Gwely. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;


@end
