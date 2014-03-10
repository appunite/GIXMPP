//
//  GIXMPP.m
//  Gistr-iOS
//
//  Created by Piotr Bernad on 07.03.2014.
//  Copyright (c) 2014 Injoit. All rights reserved.
//

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "GIXMPP+StreamDelegate.h"
#import "XMPPMessage+DictionaryRepresentation.h"

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface GIXMPP()

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end


@implementation GIXMPP

+ (GIXMPP *)sharedInstance {
    static dispatch_once_t once;
    static GIXMPP *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[GIXMPP alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
        // Configure logging framework
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        // Setup the XMPP stream
        [self setupStream];
    }
    return self;
}

- (void)setupStream {
	NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");
	   
	_xmppStream = [[XMPPStream alloc] init];
	
	// Add ourself as a delegate to anything we may be interested in
	[_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppStream setHostName:kXMPPServerHostName];
    [_xmppStream setHostPort:kXMPPServerPort];
    
    // The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	_xmppReconnect = [[XMPPReconnect alloc] init];
	[_xmppReconnect activate:_xmppStream];
    
#if !TARGET_IPHONE_SIMULATOR
    xmppStream.enableBackgroundingOnSocket = YES;
#endif
}

- (void)teardownStream {
	[_xmppStream removeDelegate:self];
	[_xmppReconnect deactivate];
	[_xmppStream disconnect];
	
	_xmppStream = nil;
	_xmppReconnect = nil;
}

- (void)goOnline {
	XMPPPresence *presence = [XMPPPresence presence];
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline {
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[[self xmppStream] sendElement:presence];
}

#pragma mark Connect/disconnect

- (BOOL)connectWithCredentials:(GIXMPPCredentials *)credentials {
	if (![_xmppStream isDisconnected]) {
		return YES;
	}
    
    _credentials = credentials;
    
	NSString *myJID = _credentials.JID;
	NSString *myPassword = _credentials.password;
    
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	[_xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	
	NSError *error = nil;
	if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect {
    _credentials = nil;
	[self goOffline];
	[_xmppStream disconnect];
}


- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings {
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates) {
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch) {
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else {
		NSString *expectedCertName = [_xmppStream.myJID domain];
        
		if (expectedCertName) {
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender {
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:_credentials.password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [self gixmppDidReceiveMessage:[message dictionaryRepresentation]];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    [self gixmppDidReceivePresence:presence];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error {
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected) {
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error {
    
}



@end
