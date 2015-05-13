package com.rithmio.application.ctrl;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.text.TextUtils;
import android.util.Log;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 * Created by kamil on 5/12/15.
 */
public class CheckTask extends AsyncTask<Void, Void, Boolean> {

    private static final String TAG = CheckTask.class.getSimpleName();

    private final Context mAppContext;
    private final Context mActivityContext;
    private final String mAppKey;
    private final String mVersionCheckUrlEndpoint;
    private final CheckListener mCheckListener;
    private final boolean mShowPopUp;
    private String mUrl;

    private HttpResponse mResponse;
    private String mType;
    private String mEncoding;
    private String mBody;

    public CheckTask(Context appContext, Context activityContext, String appKey, String versionCheckUrlEndpoint, CheckListener checkListener, boolean showPopup) {
        mAppContext = appContext;
        mActivityContext = activityContext;
        mAppKey = appKey;
        mVersionCheckUrlEndpoint = versionCheckUrlEndpoint;
        mCheckListener = checkListener;
        mShowPopUp = showPopup;
    }

    @Override
    protected Boolean doInBackground(Void... params) {
        boolean isOperatingNormally = true;

        String versionName = null;
        String appName = null;

        try {
            appName = mAppContext.getPackageName();
            PackageInfo pInfo = mAppContext.getPackageManager().getPackageInfo(appName, 0);
            versionName = pInfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            // Let the app operate normally when there's a problem with ApplicationCtrl
            Log.e(TAG, "Exception in CheckTask: " + e.getLocalizedMessage(), e);
        }

        if (!TextUtils.isEmpty(mVersionCheckUrlEndpoint) && !TextUtils.isEmpty(mAppKey) && !TextUtils.isEmpty(versionName) && !TextUtils.isEmpty(appName)) {
            mUrl = mVersionCheckUrlEndpoint + "?app_key=" + mAppKey + "&version=" + versionName + "&build=" + appName;

//            @kamtodo: use HttpURLConnection,  http://developer.android.com/reference/java/net/HttpURLConnection.html
            HttpClient httpClient = new DefaultHttpClient();
            HttpGet httpGet = new HttpGet(mUrl);

            try {
                mResponse = httpClient.execute(httpGet);
                if (mResponse.getStatusLine().getStatusCode() == 200) {
                    // Check the server status in the headers
                    Header serverStatusHeader = mResponse.getFirstHeader("Version-Check");
                    if (serverStatusHeader != null && !serverStatusHeader.getValue().trim().equalsIgnoreCase("connect")) {
                        // Connected to server, but Version-Check != 'connect', which means we force upgrade
                        isOperatingNormally = false;
                    } else {
                        isOperatingNormally = true;
                    }
                } else {
                    Log.e("ApplicationCtrl", "Server returned: " + mResponse.getStatusLine().toString());

                    // When we fail to do the check we let the application operate normally...
                    isOperatingNormally = true;
                }

                // Get hold of the mResponse entity
                // If the mResponse does not enclose an entity, there is no need
                // to worry about connection release
                HttpEntity entity = mResponse.getEntity();

                mType = entity.getContentType().getValue();

                // Get the encoding
                try {
                    mEncoding = entity.getContentEncoding().getValue();
                } catch (Exception e) {
                    Log.i("ApplicationCtrl", "Exception getting encoding header: " + e.getLocalizedMessage());
                }

                InputStream inStream = entity.getContent();
                mBody = convertStreamToString(inStream);
                // now you have the string representation of the HTML request
                inStream.close();


            } catch (IOException e) {
                Log.e("ApplicationCtrl", "Exception during check: " + e.getLocalizedMessage(), e);

                // When we fail to do the check we let the application operate normally...
                isOperatingNormally = true;
            }
        }

        return isOperatingNormally;
    }

    @Override
    protected void onPostExecute(Boolean isOperatingNormally) {
        // Show an alert if needed...
        if (mShowPopUp && !isOperatingNormally && mUrl != null && mBody != null) {
            Intent intent = new Intent(mActivityContext, ApplicationCtrlDialogActivity.class);
            intent.putExtra(ApplicationCtrlDialogActivity.EXTRA_BODY, mBody);

            if (mType != null)
                intent.putExtra(ApplicationCtrlDialogActivity.EXTRA_TYPE, mType);

            if (mEncoding != null)
                intent.putExtra(ApplicationCtrlDialogActivity.EXTRA_ENCODING, mEncoding);

            intent.putExtra(ApplicationCtrlDialogActivity.EXTRA_URL, mUrl);
            mActivityContext.startActivity(intent);
        }

        // Call the callback if one was set...
        if (mCheckListener != null) {
            //Call the listener
            mCheckListener.onCheck(isOperatingNormally, mResponse);
        }
    }

    /*
     * To convert the InputStream to String we use the BufferedReader.readLine()
     * method. We iterate until the BufferedReader return null which means
     * there's no more data to read. Each line will appended to a StringBuilder
     * and returned as String.
     */
    private static String convertStreamToString(InputStream is) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        StringBuilder sb = new StringBuilder();

        String line = null;
        try {
            while ((line = reader.readLine()) != null) {
                sb.append(line + "\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return sb.toString();
    }
}
