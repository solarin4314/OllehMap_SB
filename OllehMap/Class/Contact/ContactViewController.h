//
//  ContactViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 1..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#import "OMNavigationController.h"
#import "OMMessageBox.h"
#import "OMCustomView.h"
#import "OMParentViewController.h"
#import "OmPeoplePickerNavigationControllerViewController.h"

@interface OMControlContact : UIControl
{
    NSString *_name;
    NSArray *_addresses;
    BOOL _isAddress;
    BOOL _isNewAddress;
}
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *addresses;
@property (nonatomic, assign) BOOL isAddress;
@property (nonatomic, assign) BOOL isNewAddress;
@end

@interface ContactViewController : OMParentViewController<ABPeoplePickerNavigationControllerDelegate, UIScrollViewDelegate>
{
    OmPeoplePickerNavigationControllerViewController *_peoplePicker;
    
    UIView *_vwMultiAddressSelector;

}
+ (BOOL) checkAddressBookAuth;
+ (BOOL) checkAddressBookAuthWithoutMessage;
@end
