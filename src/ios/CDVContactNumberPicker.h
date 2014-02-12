//
//  CDVContactNumberPicker.h
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Cordova/CDVPlugin.h>

@interface CDVContactNumberPicker : CDVPlugin <ABPeoplePickerNavigationControllerDelegate>

@property(strong) NSString* callbackID;
- (void) pick:(CDVInvokedUrlCommand*)command;

@end