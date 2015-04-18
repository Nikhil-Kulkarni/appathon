package com.example.anirudh.hyped;

/**
 * Created by Anirudh on 4/18/2015.
 */
public class LoginRequest {

    private String user;
    private String pass;

    public LoginRequest(String user, String pass) {
        this.user = user;
        this.pass = pass;
    }

    public String getUser() {
        return user;
    }

    public String getPass() {
        return pass;
    }
}
