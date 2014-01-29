/**
 * Copyright (c) 2000-2014 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

#import "ContactsTableViewController.h"
#import "GetContactsCallback.h"

/**
 * @author Bruno Farache
 */
@implementation ContactsTableViewController

- (id)init {
	self = [super initWithStyle:UITableViewStylePlain];

	if (self) {
		self.title = @"Contacts";
		self.tabBarItem.image = [UIImage imageNamed:@"first"];
	}

	return self;
}

- (void)viewDidLoad {
	[self.navigationController.view showLoadingHUD];

	GetContactsCallback *callback = [[GetContactsCallback alloc] init:self];
	LRSession *session = [PrefsUtil getSession:callback];

	LREntryService_v62 *service =
		(LREntryService_v62 *)
			[LRServiceFactory getService:[LREntryService_v62 class]
				session:session];

	NSError *error;
	[service searchUsersAndContactsWithCompanyId:10157 keywords:@""
		start:-1 end:-1 error:&error];
}

- (void)setEntries:(NSMutableArray *)entries {
	[self.navigationController.view hideLoadingHUD];
	_entries = entries;
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
		numberOfRowsInSection:(NSInteger)section {

	return [self.entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell =
		[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

	if (cell == nil) {
		cell =
			[[UITableViewCell alloc]
				initWithStyle:UITableViewCellStyleDefault
				reuseIdentifier:CellIdentifier];
	}

	User *user = [self.entries objectAtIndex:indexPath.row];

	[cell.textLabel setText:user.fullName];

	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
		didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	User *user = [self.entries objectAtIndex:indexPath.row];

//	NSArray *phones = [PhoneService getPhones:user.contactId];
//
//	if ([phones count]) {
//		[user setPhone:phones[0]];
//	}
//
//	ContactDetailsTableViewController *details =
//		[[ContactDetailsTableViewController alloc] init:user];
//
//	[self.navigationController pushViewController:details animated:YES];
}

@end