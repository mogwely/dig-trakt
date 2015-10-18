//
//  TraktAPIClient.m
//  DigTrakt
//
//  Created by Mohamed Gwely on 18/10/15.
//  Copyright (c) 2015 Mohamed Gwely. All rights reserved.
//

#import "TraktAPIClient.h"
#import "Constants.h"

@implementation TraktAPIClient

+ (TraktAPIClient *)sharedClient {
    static TraktAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:TRAKT_BASE_URL_STRING]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:TRAKT_API_KEY forHTTPHeaderField:@"trakt-api-key"];
    [requestSerializer setValue:@"2" forHTTPHeaderField:@"trakt-api-version"];
    
    self.requestSerializer = requestSerializer;
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    return self;
}

/*- (void)getShowsForDate:(NSDate *)date
               username:(NSString *)username
          numbersOfDays:(int)numberOfDays
                success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString* dateString = [formatter stringFromDate:date];
    
    NSString* path = [NSString stringWithFormat:@"%@calendars/all/shows/%@/%d",
                      TRAKT_BASE_URL_STRING, dateString, numberOfDays];
    
    [self GET:path parameters:@{@"extended" : @"images"} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
    
}*/


- (void)getMoviesForQuery:(NSString *)query
                  success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    NSString* path = [NSString stringWithFormat:@"search?query=%@&type=movie",query];
                    //[NSString stringWithFormat:@"search?query=batman&type=movie"];
                    //[NSString stringWithFormat:@"movies/tron-legacy-2010"];
                      //,TRAKT_API_KEY, username, dateString, numberOfDays];
    
    [self GET:path parameters:@{@"extended" : @"min", @"page" : @"1", @"limit" : @"10"} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

@end
