package com.slalomdigital.opscheck;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.util.Log;
import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import java.io.InputStream;

/**
 * Created with IntelliJ IDEA.
 * User: aaronc
 * Date: 8/12/13
 * Time: 6:43 PM
 * To change this template use File | Settings | File Templates.
 */
public class CheckTask extends AsyncTask<Void, Void, Boolean> {
    private CheckListener checkListener;
    private Context context;
    private HttpResponse response;
    private boolean showPopup;

    public CheckTask(CheckListener checkListener, boolean showPopup, Context context) {
        this.checkListener = checkListener;
        this.context = context;
        this.showPopup = showPopup;
    }

    @Override
    protected Boolean doInBackground(Void... params) {
        boolean returnValue = true;
        // Get the base URL from the preferences

        // Get the key from the preferences

        //TODO: properly create the url
        String url = "http://m.yahoo.com/";

        HttpClient httpclient = new DefaultHttpClient();

        // Prepare a request object
        HttpGet httpget = new HttpGet(url);

        // Execute the request
        try {
            response = httpclient.execute(httpget);
            // Examine the response status
            if (response.getStatusLine().getStatusCode() == 200) {
                // Check the server status in the headers...
                Header serverStatusHeader = response.getFirstHeader("Server Status");
                if (serverStatusHeader != null && !serverStatusHeader.getValue().trim().equalsIgnoreCase("connect")) {
                    // Don't Connect...
                    returnValue = false;
                }
                else {
                    returnValue = true;
                }
            } else {
                Log.e("OpsCheck", "Server returned: " + response.getStatusLine().toString());

                // When we fail to do the check we let the application operate normally...
                returnValue = true;
            }

            // Get hold of the response entity
            HttpEntity entity = response.getEntity();
            // If the response does not enclose an entity, there is no need
            // to worry about connection release

            if (entity != null) {

                // A Simple JSON Response Read
                InputStream instream = entity.getContent();
                instream.close();
            }
        } catch (Exception e) {
            Log.e("OpsCheck", "Exception during check: " + e.getLocalizedMessage());

            // When we fail to do the check we let the application operate normally...
            returnValue = true;
        }

        // update the preference
        SharedPreferences opsCheckPrefs = context.getSharedPreferences(OpsCheck.PREFERENCES, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = opsCheckPrefs.edit();
        editor.putBoolean(OpsCheck.SHOULD_CONNECT, returnValue);
        editor.commit();

        return returnValue;
    }

    @Override
    protected void onPostExecute(Boolean result) {
        //TODO: Show a dialog if needed

        if (checkListener != null) {
            //Call the listener
            checkListener.onCheck(result, response);
        }
    }

}
