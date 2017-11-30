//
//  RegisterModel.h
//  zhike
//
//  Created by 周博 on 2017/11/30.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKRequest.h"

@interface RegisterModel : YTKRequest

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;

- (id)initWithUsername:(NSString *)username password:(NSString *)password;

@end
