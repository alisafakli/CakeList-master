//
//  APIManager.m
//  Cake List
//
//  Created by Ali Safakli on 6.04.2018.
//  Copyright © 2018 Stewart Hart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "APIManager.h"
#import "CakeModel.h"


@implementation APIManager

@synthesize apiURL;

#pragma mark API methods

+ (id)sharedInstance
{
    static APIManager *shared = nil;
    static dispatch_once_t oToken;
    dispatch_once(&oToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id) init {
    if(self = [super init]) {
        apiURL = [NSURL URLWithString:@"https://gist.githubusercontent.com/hart88/198f29ec5114a3ec3460/raw/8dd19a88f9b8d24c23d9960f3300d0c917a4f07c/cake.json"];
        //setenv("CFNETWORK_DIAGNOSTICS", "3", 1);
    }
    return self;
}

- (void)getCakesDataWithCompletion:(void(^)(NSArray *dict, NSError *error))completion

{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:apiURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode == 200)
            {
                NSError *jsonError;
                id responseData = [NSJSONSerialization
                                   JSONObjectWithData:data
                                   options:kNilOptions
                                   error:&jsonError];
                NSLog(@"%@",responseData);
                NSMutableArray *cakeModelArray = [[NSMutableArray alloc] init];
                for (int i = 0; i < [responseData count]; i++)
                {
                    [cakeModelArray addObject:[[CakeModel alloc] initWithDictionary:responseData[i]]];
                }

                completion(cakeModelArray, jsonError);

            }
            else
            {
                NSLog(@"Error");
            }
        }];
    [dataTask resume];

}

- (void)downloadImage:(NSString*)urlString withCompletion:(void(^)(UIImage* img))completion;
{
    UIImage *tmpImg = [self getImage:[urlString lastPathComponent]];
    if (tmpImg) {
        completion(tmpImg);
        return;
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [self saveImage:image filename:[urlString lastPathComponent]];
                completion(image);
            }
        }
    }];
    [task resume];
}

- (void)saveImage:(UIImage*)image filename:(NSString*)filename
{
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filename atomically:YES];
}

- (UIImage*)getImage:(NSString*)filename
{
    filename = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", filename];
    NSData *data = [NSData dataWithContentsOfFile:filename];
    return [UIImage imageWithData:data];
}
@end
