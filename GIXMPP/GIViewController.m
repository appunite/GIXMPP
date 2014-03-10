//
//  GIViewController.m
//  GIXMPP
//
//  Created by Piotr Bernad on 08.03.2014.
//  Copyright (c) 2014 Appunite. All rights reserved.
//

#import "GIViewController.h"

@interface GIViewController ()

@end

@implementation GIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _messages = [[NSMutableArray alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messages.count;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

@end
