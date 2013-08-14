package com.example.OpsCheckSampleApp;

import android.app.Activity;
import android.os.Bundle;

import com.slalomdigital.opscheck.OpsCheck;

public class MyActivity extends Activity {
    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Start the ops check...
        OpsCheck.check(this);
        // Go on about our business; if the check fails it will launch an activity

        setContentView(R.layout.main);
    }
}
