// DSRuntimeModule.java
package com.yourapp;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import androidx.annotation.NonNull;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.bridge.Callback;
import android.app.Service;
import android.os.IBinder;

public class DSRuntimeModule extends ReactContextBaseJavaModule {
    private static ReactApplicationContext reactContext;
    private SharedPreferences preferences;

    DSRuntimeModule(ReactApplicationContext context) {
        super(context);
        reactContext = context;
        preferences = context.getSharedPreferences("DSRuntimePrefs", Context.MODE_PRIVATE);
        // Register broadcast receiver for boot completed
        IntentFilter filter = new IntentFilter(Intent.ACTION_BOOT_COMPLETED);
        context.registerReceiver(new BootReceiver(), filter);
    }

    @NonNull
    @Override
    public String getName() {
        return "DSRuntimeNative";
    }

    @ReactMethod
    public void updateSetting(String key, String value) {
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString(key, value);
        editor.apply();
    }

    // Additional methods to handle background tasks

    private void sendEvent(String eventName, WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }
}

// BootReceiver.java
public class BootReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_BOOT_COMPLETED)) {
            Intent serviceIntent = new Intent(context, DSRuntimeService.class);
            context.startService(serviceIntent);
        }
    }
}

// DSRuntimeService.java
public class DSRuntimeService extends Service {
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // Handle background tasks here
        return START_STICKY;
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}