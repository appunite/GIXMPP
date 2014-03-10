//
//  GIXMPP+StreamDelegate.m
//  Gistr-iOS
//
//  Created by Piotr Bernad on 08.03.2014.
//  Copyright (c) 2014 Injoit. All rights reserved.
//

#import "GIXMPP+StreamDelegate.h"

@implementation GIXMPP (StreamDelegate)

- (void)gixmppDidReceiveMessage:(NSDictionary *)message {
    NSLog(@"message: %@", message);
}

- (void)gixmppDidReceivePresence:(NSDictionary *)presence {
	
}

@end
