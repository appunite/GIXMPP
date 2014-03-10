//
//  GIXMPP.h
//  Gistr-iOS
//
//  Created by Piotr Bernad on 07.03.2014.
//  Copyright (c) 2014 Injoit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework.h>
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "GIXMPPConstants.h"
#import "GIXMPPCredentials.h"
#import <CFNetwork/CFNetwork.h>

@interface GIXMPP : NSObject <XMPPStreamDelegate> {
    BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
    
    BOOL isXmppConnected;
}

+ (GIXMPP *)sharedInstance;

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) GIXMPPCredentials *credentials;

- (BOOL)connectWithCredentials:(GIXMPPCredentials *)credentials;
- (BOOL)registerWithCredentials:(GIXMPPCredentials *)credentials;
- (void)disconnect;
- (BOOL)isConnected;

@end
