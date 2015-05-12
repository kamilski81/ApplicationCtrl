package com.rithmio.application.ctrl;

import android.content.Context;

/**
 * Created by kamil on 5/12/15.
 */
public class ApplicationCtrl {

    public static Context context;


    public static void check(Context context) {
        ApplicationCtrl.check(null, true, context);
    }

    public static void check(CheckListener checkListener, boolean showPopup, Context context) {
        // Create the async task and check
        ApplicationCtrl.context = context;
        CheckTask checkTask = new CheckTask(checkListener, showPopup, context);
        checkTask.execute();
    }
}
