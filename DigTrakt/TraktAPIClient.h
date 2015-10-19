//
//  TraktAPIClient.h
//  DigTrakt
//
//  Created by Mohamed Gwely on 18/10/15.
//  Copyright (c) 2015 Mohamed Gwely. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface TraktAPIClient : AFHTTPSessionManager


+ (TraktAPIClient *)sharedClient;

- (void)getMoviesForQuery:(NSString *)query
                     page:(NSInteger)page
                success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)getPopularMoviesByPage:(NSInteger)page
                  success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
