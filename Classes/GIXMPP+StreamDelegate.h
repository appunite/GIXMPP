//
//  GIXMPP+StreamDelegate.h
//  Gistr-iOS
//
//  Created by Piotr Bernad on 08.03.2014.
//  Copyright (c) 2014 Injoit. All rights reserved.
//

#import "GIXMPP.h"

@interface GIXMPP (StreamDelegate)

- (void)gixmppDidReceiveMessage:(NSDictionary *)message;
- (void)gixmppDidReceivePresence:(NSDictionary *)presence;

@end
