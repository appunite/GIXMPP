//
//  NSDictionary+SafeValue.h
//  GIXMPP
//
//  Created by Piotr Bernad on 08.03.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SafeValue)

- (void)setValueSafely:(id)value forKey:(NSString *)key;

@end
