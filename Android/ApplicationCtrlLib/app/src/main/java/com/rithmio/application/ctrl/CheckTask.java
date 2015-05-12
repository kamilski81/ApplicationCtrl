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
import java.util.Properties;

/**
 * Created by kamil on 5/12/15.
 */
public class CheckTask extends AsyncTask<Void, Void, Boolean> {

    private static final String TAG = CheckTask.class.getSimpleName();

    private final CheckListener mCheckListener;
    private final boolean mShowPopUp;
    private final Context mContext;
    private String mUrl;
    private HttpResponse mResponse;
    private String mType;
    private String mEncoding;
    private String mBody;

    public CheckTask(CheckListener checkListener, boolean showPopup, Context context) {
        mCheckListener = checkListener;
        mShowPopUp = showPopup;
        mContext = context;
    }

    @Override
    protected Boolean doInBackground(Void... params) {
        boolean isOperatingNormally = true;

        String versionName = null;
        int versionCode;
        String appName = null;
        String key = null;
        String server = null;

        try {
            appName = mContext.getPackageName();
            PackageInfo pInfo = mContext.getPackageManager().getPackageInfo(appName, 0);
            versionName = pInfo.versionName;
            versionCode = pInfo.versionCode;

            // Get the key and server
            InputStream inputStream = mContext.getResources().getAssets().open("applicationctrl.properties");
            Properties properties = new Properties();
            properties.load(inputStream);
            key = properties.getProperty("key", null);
            server = properties.getProperty("server", null);

        } catch (PackageManager.NameNotFoundException | IOException e) {
            Log.e(TAG, "Exception in CheckTask: " + e.getLocalizedMessage(), e);
            // Let the app operate normally when there's a problem with ApplicationCtrl
            isOperatingNormally = true;
        }

        if (!TextUtils.isEmpty(server) && !TextUtils.isEmpty(key) && !TextUtils.isEmpty(versionName) && !TextUtils.isEmpty(appName)) {
            mUrl = server + "?app_key=" + key + "&version=" + versionName + "&build=" + appName;

//            @kamtodo: use HttpURLConnection,  http://developer.android.com/reference/java/net/HttpURLConnection.html
            HttpClient httpClient = new DefaultHttpClient();
            HttpGet httpGet = new HttpGet(mUrl);

            try {
                mResponse = httpClient.execute(httpGet);
                if (mResponse.getStatusLine().getStatusCode() == 200) {
                    // Check the server status in the headers
                    Header serverStatusHeader = mResponse.getFirstHeader("Version-Check");
                    if (serverStatusHeader != null && !serverStatusHeader.getValue().trim().equalsIgnoreCase("connect")) {
                        // Connected to server, but Version-Check != 'connect'
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
            Intent intent = new Intent(mContext, ApplicationCtrlDialogActivity.class);
            intent.putExtra(ApplicationCtrlDialogActivity.EXTRA_BODY, mBody);

            if (mType != null)
                intent.putExtra(ApplicationCtrlDialogActivity.EXTRA_TYPE, mType);

            if (mEncoding != null)
                intent.putExtra(ApplicationCtrlDialogActivity.EXTRA_ENCODING, mEncoding);

            intent.putExtra(ApplicationCtrlDialogActivity.EXTRA_URL, mUrl);
            mContext.startActivity(intent);
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
