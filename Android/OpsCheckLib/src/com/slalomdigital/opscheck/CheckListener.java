package com.slalomdigital.opscheck;

import org.apache.http.HttpResponse;

/**
 * Created with IntelliJ IDEA.
 * User: aaronc
 * Date: 8/12/13
 * Time: 6:55 PM
 * To change this template use File | Settings | File Templates.
 */
public interface CheckListener {
    abstract void onCheck(Boolean connect, HttpResponse response);
}
