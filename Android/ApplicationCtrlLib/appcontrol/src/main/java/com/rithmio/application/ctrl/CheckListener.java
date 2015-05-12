package com.rithmio.application.ctrl;

import org.apache.http.HttpResponse;

/**
 * Created by kamil on 5/12/15.
 */
public interface CheckListener {
    void onCheck(Boolean connect, HttpResponse response);
}
