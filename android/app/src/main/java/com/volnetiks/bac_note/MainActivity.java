package com.volnetiks.bac_note;

import android.os.AsyncTask;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import fr.benco11.jlibecoledirecte.Session;
import fr.benco11.jlibecoledirecte.exceptions.EcoleDirecteLoginException;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "samples.volnetiks.dev/ecoledirecte";

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("loginToEcoleDirecte")) {
                class NameLoader extends AsyncTask<String, Integer, String> {
                    @Override
                    protected String doInBackground(String... strings) {
                        Session session = new Session(call.argument("username"), call.argument("password"));
                        try {
                            session.connect();
                            String name = session.getAccount().getPrenom() + " " + session.getAccount().getNom();
                            return name;
                        } catch (EcoleDirecteLoginException e) {
                            e.printStackTrace();
                            return "Not Implemented";
                        }
                    }

                    @Override
                    protected void onPostExecute(String s) {
                        result.success(s);
                    }
                }

                new NameLoader().execute();
            } else {
                result.notImplemented();
            }
        });
    }
}
