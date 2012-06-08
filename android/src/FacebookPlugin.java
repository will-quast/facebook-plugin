package com.williamquast.plugin;

import org.apache.cordova.api.Plugin;
import org.apache.cordova.api.PluginResult;
import org.apache.cordova.api.PluginResult.Status;
import org.json.JSONArray;
import org.json.JSONException;

import android.util.Log;

public class FacebookPlugin extends Plugin {
	
	private static final String TAG = "FacebookPlugin";
	
	private static final String ACTION_LOGIN = "login";
	private static final String ACTION_LOGOUT = "login";
	private static final String ACTION_IS_SESSION_VALID = "isSessionValid";
	private static final String ACTION_GRAPH_REQUEST = "graphRequest";
	private static final String ACTION_DIALOG = "dialog";
	
	
	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {
		PluginResult result = null;
		
		try{
			if(ACTION_LOGIN.equals(action)){
				result = login(data);
			}else if(ACTION_LOGOUT.equals(action)){
				result = logout(data);
			}else if(ACTION_IS_SESSION_VALID.equals(action)){
				result = isSessionValid(data);
			}else if(ACTION_GRAPH_REQUEST.equals(action)){
				result = graphRequest(data);
			}else if(ACTION_DIALOG.equals(action)){
				result = dialog(data);
			}else {
				throw new RuntimeException("Unknown action");
			}
		}catch(JSONException e){
			Log.e(TAG, "Error parsing JSON.", e);
			return new PluginResult(Status.ERROR, e.getLocalizedMessage());
		}

		return result;
	}
	
	private PluginResult login(JSONArray data) throws JSONException {
		
		return new PluginResult(Status.OK);
	}
	
	private PluginResult logout(JSONArray data) throws JSONException {
		
		return new PluginResult(Status.OK);
	}

	private PluginResult isSessionValid(JSONArray data) throws JSONException {
	
		return new PluginResult(Status.OK);
	}
	
	private PluginResult graphRequest(JSONArray data) throws JSONException {
		
		return new PluginResult(Status.OK);
	}
	
	private PluginResult dialog(JSONArray data) throws JSONException {
		
		return new PluginResult(Status.OK);
	}
}
