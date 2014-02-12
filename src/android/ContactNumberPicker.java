package hu.dpal.phonegap.plugins;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.provider.ContactsContract;

public class ContactNumberPicker extends CordovaPlugin {

    private Context context;
    private CallbackContext callbackContext;
    private static final int CONTACT_PICKER_RESULT = 0;

    @Override
    public boolean execute(String action, JSONArray data, CallbackContext callbackContext) {
    	
        this.callbackContext = callbackContext;
        this.context = cordova.getActivity().getApplicationContext();
        
        if (action.equals("pick")) {
        	
            Intent contactsIntent = new Intent(Intent.ACTION_PICK, ContactsContract.Contacts.CONTENT_URI);
            contactsIntent.setType(ContactsContract.CommonDataKinds.Phone.CONTENT_TYPE);

            cordova.startActivityForResult(this, contactsIntent, CONTACT_PICKER_RESULT);

            PluginResult r = new PluginResult(PluginResult.Status.NO_RESULT);
            r.setKeepCallback(true);
            callbackContext.sendPluginResult(r);
            return true;
        }

        return false;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {

        
        if (resultCode == Activity.RESULT_OK){
        
	        Uri contactData = data.getData();
	        Cursor c =  context.getContentResolver().query(contactData, null, null, null, null);
	        c.moveToFirst();
	
	        try {
	            String id = c.getInt(c.getColumnIndexOrThrow(ContactsContract.CommonDataKinds.Phone.CONTACT_ID)) + "";
	            String name = c.getString(c.getColumnIndexOrThrow(ContactsContract.Contacts.DISPLAY_NAME));
	            String phone = c.getString(c.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER));
	          
	            JSONObject contact = new JSONObject();
	            contact.put("id", id);
	            contact.put("phoneNumber", phone);
	            contact.put("name", name);
	            
	            c.close();
	            
	            callbackContext.success(contact);
	
	        } catch (Exception e) {
	           callbackContext.error("Failed: " + e.getMessage());
	        }
        
	        
        } else if (resultCode == Activity.RESULT_CANCELED) {
        	callbackContext.error("No result");
        	return;
        } else {
        	callbackContext.error("Failed");
        	return;
        }
        
        
   }

}