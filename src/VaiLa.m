//
//  VaiLa.m
// 
//
//  Created by Tiago Braga on 4/13/13.
//  Copyright (c) 2013 Tiago Braga. All rights reserved.
//

#define kVaiLaAPIURL             @"http://www.vai.la/link/api/?url=%@"

#import "VaiLa.h"

@interface VaiLa ()

@property (nonatomic, strong) NSString *urlToShort;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) SuccessBlock successBock;
@property (nonatomic, strong) FailBlock failBlock;

-(void)startRequest;

@end

@implementation VaiLa

-(void)shortUrl:(NSString *)urlToShort successBlock:(SuccessBlock)successBlock failBlock:(FailBlock)failBlock
{
    self.urlToShort = urlToShort;
    self.successBock = successBlock;
    self.failBlock = failBlock;
    
    [self startRequest];
}

-(void)startRequest
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kVaiLaAPIURL, self.urlToShort]]];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (urlConnection)
        self.receiveData = [NSMutableData data];
}

#pragma mark - NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receiveData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.failBlock)
        self.failBlock(self.urlToShort, error);
    
    self.failBlock = nil;
    self.successBock = nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *shortenURL = [[[NSString alloc] initWithData:self.receiveData encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([shortenURL isEqualToString:@"0"])
    {
        if (self.failBlock)
            self.failBlock(self.urlToShort, nil);
    }
    else
    {
        if (self.successBock)
            self.successBock(self.urlToShort, shortenURL);
    }
    
    self.failBlock = nil;
    self.successBock = nil;
}

@end