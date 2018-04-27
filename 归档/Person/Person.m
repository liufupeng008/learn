//
//  Person.m
//  learn
//
//  Created by 刘阜澎 on 2018/4/26.
//  Copyright © 2018年 LiuFuPeng. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation Person
/// 归档，编码
- (void)encodeWithCoder:(NSCoder *)aCoder {
    /// 所有的成员变量
    /// copy create
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList([self class], &count);
    ///遍历
    for (int i=0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString* key = [NSString stringWithUTF8String:name];
        ///kvc
        id value = [self valueForKey:key];
        /// 编码
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar * ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            Ivar ivar = ivars[i];
            const char * name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            // 解码
            id value = [aDecoder decodeObjectForKey:key];
            
            /// kvc
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self==[super init]) {
        for (NSString * key in dict.allKeys) {
            id value = [dict objectForKey:key];
            SEL setter = [self setterMethod:key];
            if (setter) {
                ((void (*) (id,SEL,id))objc_msgSend)(self,setter,value);
            }
        }
    }
    return self;
}
- (NSDictionary *)modelToDict{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    if (count>0) {
        NSMutableDictionary * dict = [@{} mutableCopy];
        for (int i=0; i<count; i++) {
            const void * properyName = property_getName(propertyList[i]);
            NSString * name = [NSString stringWithUTF8String:properyName];
            SEL sel = NSSelectorFromString(name);
            if (sel) {
                id value = ((id (*) (id,SEL))objc_msgSend)(self,sel);
                [dict setObject:value ? :@"" forKey:name];
            }
        }
        return dict;
    }
    free(propertyList);
    return nil;
}
- (SEL)setterMethod:(NSString *)key {
    NSString * methodName = [NSString stringWithFormat:@"set%@",key.capitalizedString];
    SEL setter = NSSelectorFromString(methodName);
    if ([self respondsToSelector:setter]) {
        return setter;
    }
    return nil;
}
@end
