//
//  CakeModel.m
//  Cake List
//
//  Created by Ali Safakli on 7.04.2018.
//  Copyright © 2018 Stewart Hart. All rights reserved.
//

#import "CakeModel.h"

@implementation CakeModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
    }
    return self;
}

- (void)setDictionary:(NSDictionary *)dictionary{
    self.desc = dictionary[@"desc"];
    self.title = dictionary[@"title"];
    self.image = dictionary[@"image"];
}

@end
