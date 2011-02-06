//
//  PVDemoViewController.m
//  SSCatalog
//
//  Created by Sam Soffes on 9/8/10.
//  Copyright 2010 Sam Soffes. All rights reserved.
//

#import "PVDemoViewController.h"
#import "SSPersonViewController.h"

@implementation PVDemoViewController

#pragma mark UIViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Person";
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = CGRectMake(20.0, 20.0, 280.0, 37.0);
	[button setTitle:@"Pick Person" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(pickPerson:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	}
	return YES;
}


#pragma mark Actions

- (void)pickPerson:(id)sender {
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController  alloc] init];
	picker.peoplePickerDelegate = self;
	[self.navigationController presentModalViewController:picker animated:YES];
	[picker release];
}


#pragma mark ABPeoplePickerNavigationControllerDelegate

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	[self.navigationController dismissModalViewControllerAnimated:YES];
	
	SSPersonViewController *personViewController = [[SSPersonViewController alloc] initWithPerson:person addressBook:peoplePicker.addressBook];
	[self.navigationController pushViewController:personViewController animated:YES];
	[personViewController release];
	
	return NO;
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	return NO;
}


- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

@end
