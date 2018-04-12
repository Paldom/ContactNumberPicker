Contact Number Picker
=====================

Cordova plugin to pick a single number of a Contact instead of full contact details. Ideal to fill a mobile or phone number field.

You can tap on a specific number among multiple numbers and get that particular number in return. For, iOS the tap doesn't place a Call.

Supported Platforms: iOS & Android. (You're welcome to contribute more platforms)

N.B: Forked from the https://github.com/Paldom/ContactNumberPicker since this was no longer in maintain.

Usage:

    // Show Contact Picker
    var successCallback = function(result){
        setTimeout(function(){alert(result.name + " " + result.phoneNumber);},0);
    };
    var failedCallback = function(result){
        setTimeout(function(){alert(result);},0);
    }
    window.plugins.contactNumberPicker.pick(successCallback,failedCallback);
