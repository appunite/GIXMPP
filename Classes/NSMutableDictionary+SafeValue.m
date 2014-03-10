//
//  NSDictionary+SafeValue.m
//  GIXMPP
//
//  Created by Piotr Bernad on 08.03.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "NSMutableDictionary+SafeValue.h"

@implementation NSMutableDictionary (SafeValue)

- (void)setValueSafely:(id)value forKey:(NSString *)key {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return;
    }
    if (!key || ![key isKindOfClass:[NSString class]] || [key isEqualToString:@""]) {
        return;
    }
    [self setValue:value forKeyPath:key];
}

@end
