package com.example.anirudh.hyped;

import java.util.Map;

/**
 * Created by Anirudh on 4/18/2015.
 */
public class LoginResult {

    private String cookies;
    private Map<String, String> requestSpaces;

    public LoginResult(String cookies, Map<String, String> requestSpaces) {
        this.cookies = cookies;
        this.requestSpaces = requestSpaces;
    }

    public String getCookies() {
        return cookies;
    }

    public Map<String, String> getRequestSpaces() {
        return requestSpaces;
    }
}
