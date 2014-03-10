//
//  XMPPMessage+DictionaryRepresentation.m
//  GIXMPP
//
//  Created by Piotr Bernad on 08.03.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "XMPPMessage+DictionaryRepresentation.h"
#import "NSMutableDictionary+SafeValue.h"

@implementation XMPPMessage (DictionaryRepresentation)

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValueSafely:@([self isChatMessage]) forKey:@"isChatMessage"];
    [dictionary setValueSafely:@([self isErrorMessage]) forKey:@"isErrorMessage"];
    [dictionary setValueSafely:[self body] forKey:@"body"];
    [dictionary setValueSafely:[self fromStr] forKey:@"from"];
    [dictionary setValueSafely:[self toStr] forKey:@"to"];
    [dictionary setValueSafely:[self subject] forKey:@"subject"];
    [dictionary setValueSafely:[self thread] forKey:@"thread"];
    
    return dictionary;
}

@end
