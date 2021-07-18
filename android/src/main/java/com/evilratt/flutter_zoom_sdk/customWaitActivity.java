package com.evilratt.flutter_zoom_sdk;

import android.app.Activity;
import android.os.Bundle;

import androidx.annotation.Nullable;

public class customWaitActivity extends Activity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.custom_wait_activity);
    }
}
