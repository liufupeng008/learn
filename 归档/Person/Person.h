//
//  Person.h
//  learn
//
//  Created by 刘阜澎 on 2018/4/26.
//  Copyright © 2018年 LiuFuPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property(nonatomic,copy) NSString * name;

@property(nonatomic,copy) NSString * nick;

@property(nonatomic,strong)NSNumber * age;

- (NSDictionary *)modelToDict;

@end
