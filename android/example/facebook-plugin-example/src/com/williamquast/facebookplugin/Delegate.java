package com.williamquast.facebookplugin;

import org.apache.cordova.DroidGap;

import android.os.Bundle;

public class Delegate extends DroidGap {
	
	@Override
	public void onCreate(Bundle bundle) {
		super.onCreate(bundle);
		
		loadUrl("file:///android_asset/www/index.html");
	}
}
