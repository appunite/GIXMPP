//
//  GIXMPPCredentials.h
//  Gistr-iOS
//
//  Created by Piotr Bernad on 07.03.2014.
//  Copyright (c) 2014 Injoit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIXMPPCredentials : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *JID;
@property (nonatomic, readonly) NSString *password;

+ (instancetype)credentialsWithJID:(NSString *)jid password:(NSString *)password;

@end
