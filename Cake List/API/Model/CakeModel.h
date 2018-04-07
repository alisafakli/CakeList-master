//
//  CakeModel.h
//  Cake List
//
//  Created by Ali Safakli on 7.04.2018.
//  Copyright © 2018 Stewart Hart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CakeModel : NSObject

@property (nonatomic, strong) NSString * desc;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * title;

- (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end
