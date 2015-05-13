package com.rithmio.application.ctrl;

import android.content.Context;

/**
 * Created by kamil on 5/12/15.
 */
public class ApplicationCtrl {

    private final String mVersionCheckUrlEndpoint;
    private final String mAppKey;
    public Context mAppContext;

    public ApplicationCtrl(Context appContext, String appKey, String versionCheckUrlEndpoint) {
        mAppContext = appContext;
        mAppKey = appKey;
        mVersionCheckUrlEndpoint = versionCheckUrlEndpoint;
    }

    public void check(Context activityContext) {
        check(activityContext, null, true);
    }

    public void check(Context activityContext, CheckListener checkListener, boolean showPopup) {
        // Create the async task and check server
        CheckTask checkTask = new CheckTask(mAppContext, activityContext, mAppKey, mVersionCheckUrlEndpoint, checkListener, showPopup);
        checkTask.execute();
    }
}
