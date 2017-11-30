//
//  User.h
//  zhike
//
//  Created by 周博 on 2017/11/28.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKRequest.h"

typedef enum {
    SexMale,
    SexFemale
} Sex;

@interface Stories : NSArray
@property (strong, nonatomic) NSNumber *ga_prefix;
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *type;
@end

@interface User : YTKRequest
@property (copy, nonatomic) NSString *date;
@property (copy, nonatomic) Stories *stories;
@end
