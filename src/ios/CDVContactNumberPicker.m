//
//  CDVContactNumberPicker.m
//

#import "CDVContactNumberPicker.h"

@implementation CDVContactNumberPicker
@synthesize callbackID;

- (void) pick:(CDVInvokedUrlCommand*)command{
    self.callbackID = command.callbackId;
    
    // get contacts with phone number only
    
//    ABAddressBookRef addressBook = ABAddressBookCreate();
//    
//    NSArray *contacts = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
//    for (id currentPerson in contacts) {
//        ABRecordRef person = CFBridgingRetain(currentPerson);
//        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
//        if (ABMultiValueGetCount(phones) == 0) {
//            CFErrorRef error = nil;
//            ABAddressBookRemoveRecord(addressBook, person, &error);
//        }
//        CFRelease(phones);
//        CFRelease(person);
//    }
    
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    [picker setPeoplePickerDelegate:self];
    
//  [picker setAddressBook:addressBook];
//  CFRelease(addressBook);
    
    // display phone only
    
    NSArray *phoneProp = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    picker.displayedProperties = phoneProp;
    
    [self.viewController presentModalViewController:picker animated:YES];
    
    
}

- (NSMutableDictionary *)convertToDictionary:(ABRecordRef)person withPropertyID:(ABPropertyID)property withIdentifier:(ABMultiValueIdentifier)identifier {
    
    NSString *name, *phone;
    name = (__bridge NSString*)ABRecordCopyCompositeName(person);
    if (!name) {
        name = @"";
    }
    
    ABMultiValueRef mv = ABRecordCopyValue(person, property);
    if(ABMultiValueGetCount(mv) > 0){
        phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(mv, identifier);
    }
    else{
        phone = @"";
    }
    
    NSMutableDictionary* contact = [NSMutableDictionary dictionaryWithCapacity:2];
    [contact setObject:phone forKey: @"phoneNumber"];
    [contact setObject:name forKey: @"name"];
    
    ABRecordID recordID = ABRecordGetRecordID(person);
    [contact setObject:@(recordID) forKey:@"id"];
    
    return contact;
}

- (void)sendResult:(NSMutableDictionary *)contact {
    
    [super writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:contact] toSuccessCallbackString:self.callbackID]];
    [self.viewController dismissModalViewControllerAnimated:YES];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:contact];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackID];
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    
    NSMutableDictionary *contact;
    contact = [self convertToDictionary:person withPropertyID:property withIdentifier:identifier];
    [self sendResult:contact];
    
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [self.viewController dismissModalViewControllerAnimated:YES];
    [super writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT]
                            toErrorCallbackString:self.callbackID]];
}

@end


