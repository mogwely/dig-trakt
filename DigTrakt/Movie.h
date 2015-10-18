//
//  Movie.h
//  DigTrakt
//
//  Created by Mohamed Gwely on 18/10/15.
//  Copyright (c) 2015 Mohamed Gwely. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (copy,nonatomic) NSString* title;
@property (copy,nonatomic) NSString* year;
@property (copy,nonatomic) NSString* overview;

@end
