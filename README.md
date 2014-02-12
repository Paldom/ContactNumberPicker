ContactNumberPicker
===================

PhoneGap plugin for native contact picker on Android and iOS. The picker shows only name and phone numbers.
Ideas from https://github.com/hazemhagrass/ContactPicker.git

Usage:

    // Show Contact Picker
    var successCallback = function(result){
        setTimeout(function(){alert(result.name + " " + result.phoneNumber);},0);
    };
    var failedCallback = function(result){
        setTimeout(function(){alert(result);},0);
    }
    window.plugins.contactNumberPicker.pick(successCallback,failedCallback);

