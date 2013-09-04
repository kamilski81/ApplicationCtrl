package com.slalomdigital.applicationctrl;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Window;
import android.webkit.WebView;
import android.widget.TextView;

/**
 * Created with IntelliJ IDEA.
 * User: aaronc
 * Date: 8/17/13
 * Time: 9:22 PM
 * To change this template use File | Settings | File Templates.
 */
public class ApplicationCtrlDialogActivity extends Activity {
    public static final String EXTRA_BODY = "extra_body";
    public static final String EXTRA_TYPE = "extra_type";
    public static final String EXTRA_ENCODING = "extra_encoding";
    public static final String EXTRA_URL = "extra_url";

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //Remove title bar
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);

        Intent intent = getIntent();
        String body = intent.getStringExtra(EXTRA_BODY);
        String url = intent.getStringExtra(EXTRA_URL);
        String type = intent.getStringExtra(EXTRA_TYPE);
        String encoding = intent.getStringExtra(EXTRA_ENCODING);

        if (body == null || type == null || !type.toLowerCase().contains("text/html")) {
            // Simple text box with OK button...
            setContentView(R.layout.application_ctrl_textview_activity);
            if (body != null) {
                TextView textView = (TextView) findViewById(R.id.textView);
                textView.setText(body);
            }

            // TODO: Add ok button functionality
        }
        else {
            // WebView...
            setContentView(R.layout.application_ctrl_webview_activity);
            WebView webView = (WebView)findViewById(R.id.webView);
            // I had some problems with reloading the data so for now it's either a pop-up with text in it
            // or a webView and the page gets re-loaded.  Here's the code that had issues...
            //
            //webView.loadDataWithBaseURL(url, body, type, encoding, null);
            //
            webView.loadUrl(url);
        }
    }
}
