package com.rithmio.application.ctrl;

import android.app.Activity;
import android.os.Bundle;

/**
 * Created by kamil on 5/12/15.
 */
public class SampleApplicationCtrlActivity extends Activity {

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Start the application-[ctrl] check...
        ApplicationCtrl.check(this);
        // Go on about our business; if the check fails it will launch an activity

        setContentView(R.layout.sample_application_ctrl_main_activity);
    }
}
