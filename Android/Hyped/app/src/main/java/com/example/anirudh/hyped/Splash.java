package com.example.anirudh.hyped;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.google.gson.Gson;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.util.EntityUtils;


public class Splash extends ActionBarActivity {

//    HttpClient httpClient = HttpClientBuilder.create().build();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        RelativeLayout layout = (RelativeLayout) findViewById(R.id.layout);
        layout.setOnTouchListener(new View.OnTouchListener()
        {
            @Override
            public boolean onTouch(View view, MotionEvent ev)
            {
                hideKeyboard(view);
                return false;
            }
        });
    }

    protected void hideKeyboard(View view)
    {
        InputMethodManager in = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
        in.hideSoftInputFromWindow(view.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_splash, menu);
        return true;
    }

    public void sendMessage(View view) {
        //HttpClient httpClient = HttpClientBuilder.create().build();
        final ProgressDialog dialog = ProgressDialog.show(this, "Please wait...", "Logging you in");
        final Intent intent = new Intent(this, TimeActivity.class);
        new AsyncTask<Void, Void, Void>() {
            @Override
            protected Void doInBackground(Void... params) {
                Log.d("Splash", "starting request");
                Gson gson = new Gson();
                HttpClient httpClient = new DefaultHttpClient();
                try {
                    HttpPost request = new HttpPost("http://culcreserve.herokuapp.com/login");
                    EditText username = (EditText)findViewById(R.id.username);
                    String user = username.getText().toString();
                    EditText password = (EditText)findViewById(R.id.password);
                    String pass = password.getText().toString();
                    StringEntity param =new StringEntity(gson.toJson(new LoginRequest(user, pass)));
                    request.addHeader("content-type", "application/json");
                    request.setEntity(param);
                    HttpResponse response = httpClient.execute(request);
                    if (response.getStatusLine().getStatusCode() == HttpStatus.SC_UNAUTHORIZED) {
                        ErrorResult error = gson.fromJson(EntityUtils.toString(response.getEntity()), ErrorResult.class);
                        throw new Exception(error.getError());
                    } else {
                        startActivity(intent);
                        finish();
                    }
                    dialog.dismiss();
                    // handle response here...
                } catch (final Exception ex) {
                    dialog.dismiss();
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(Splash.this, ex.getMessage(), Toast.LENGTH_LONG).show();
                        }
                    });
                    Log.e("Splash", Log.getStackTraceString(ex));
                } finally {
                    httpClient.getConnectionManager().shutdown();
                }
                return null;
            }
        }.execute();


//        EditText editText = (EditText) findViewById(R.id.edit_message);
//        String message = editText.getText().toString();
//        intent.putExtra(EXTRA_MESSAGE, message);

    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
