package com.slalomdigital.applicationctrl;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Window;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;

/**
 * Created with IntelliJ IDEA.
 * User: aaronc
 * Date: 8/17/13
 * Time: 9:22 PM
 * To change this template use File | Settings | File Templates.
 */
@SuppressLint("SetJavaScriptEnabled")
public class ApplicationCtrlDialogActivity extends Activity {
    public static final String EXTRA_BODY = "extra_body";
    public static final String EXTRA_TYPE = "extra_type";
    public static final String EXTRA_ENCODING = "extra_encoding";
    public static final String EXTRA_URL = "extra_url";
    private class ApplicationCtrlWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
/*
            if (Uri.parse(url).getHost().equals("www.example.com")) {
                // This is my web site, so do not override; let my WebView load the page
                return false;
            }
            // Otherwise, the link is not for a page on my site, so launch another Activity that handles URLs
            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
            startActivity(intent);
            return true;
*/
            return false;
        }
    }

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
            initializeBrowser(webView);
            webView.loadDataWithBaseURL(url, body, type, encoding, null);
        }
    }
    // helpers
    private void initializeBrowser(WebView browser) {
        browser.getSettings().setJavaScriptEnabled(true);
        browser.setWebViewClient(new ApplicationCtrlWebViewClient());
    }
}

