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

- (void)getMoviesForQuery:(NSString *)query
                     page:(NSInteger)page
                  success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure
{
    //escapes special characters
    NSString* escapedQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *pageString = [NSString stringWithFormat: @"%ld", (long)page];
    
    NSString* path = [NSString stringWithFormat:@"search?query=%@&type=movie",escapedQuery];
    
    [self GET:path parameters:@{@"extended" : @"full,images", @"page" : pageString, @"limit" : @"10"} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}


- (void)getPopularMoviesByPage:(NSInteger)page
                       success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;
{
    
    NSString *pageString = [NSString stringWithFormat: @"%ld", (long)page];
    NSString* path = [NSString stringWithFormat:@"movies/popular"];
    
    [self GET:path parameters:@{@"extended" : @"full,images", @"page" : pageString, @"limit" : @"10"} success:^(NSURLSessionDataTask *task, id responseObject) {
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
