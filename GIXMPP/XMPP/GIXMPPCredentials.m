//
//  GIXMPPCredentials.m
//  Gistr-iOS
//
//  Created by Piotr Bernad on 07.03.2014.
//  Copyright (c) 2014 Injoit. All rights reserved.
//

#import "GIXMPPCredentials.h"

@implementation GIXMPPCredentials

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (instancetype)credentialsWithJID:(NSString *)jid password:(NSString *)password {
    GIXMPPCredentials *credentials = [[GIXMPPCredentials alloc] initWithJID:jid password:password];
    return credentials;
}

- (id)initWithJID:(NSString *)jid password:(NSString *)password {
    self = [super init];
    if (self) {
        _password = password;
        _JID = jid;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSString *pass = [aDecoder decodeObjectForKey:@"password"];
    NSString *jid = [aDecoder decodeObjectForKey:@"JID"];
    return [self initWithJID:jid password:pass];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_password forKey:@"password"];
    [aCoder encodeObject:_JID forKey:@"JID"];
}

@end
