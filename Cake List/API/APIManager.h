//
//  APIManager.h
//  Cake List
//
//  Created by Ali Safakli on 6.04.2018.
//  Copyright © 2018 Stewart Hart. All rights reserved.
//

@interface APIManager : NSObject {
    NSURL *apiURL;
}

@property (nonatomic, retain) NSURL *apiURL;

+ (id)sharedInstance;
- (void)getCakesDataWithCompletion:(void(^)(NSArray *dict, NSError *error))completion;
- (void)downloadImage:(NSString*)urlString withCompletion:(void(^)(UIImage* img))completion;
@end
