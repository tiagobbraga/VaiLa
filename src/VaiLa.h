//
//  VaiLa.h
// 
//
//  Created by Tiago Braga on 4/13/13.
//  Copyright (c) 2013 Tiago Braga. All rights reserved.
//

typedef void (^SuccessBlock)(NSString *urlToShort, NSString *shortenURL);
typedef void (^FailBlock)(NSString *urlToShort, NSError *error);

#import <Foundation/Foundation.h>

@interface VaiLa : NSObject <NSURLConnectionDelegate>

-(void)shortUrl:(NSString *)urlToShort successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock;

@end