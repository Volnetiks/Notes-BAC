package com.volnetiks.bac_note;

import android.os.AsyncTask;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

import fr.benco11.jlibecoledirecte.Session;
import fr.benco11.jlibecoledirecte.exceptions.EcoleDirecteLoginException;
import fr.benco11.jlibecoledirecte.exceptions.EcoleDirecteUnknownConnectionException;
import fr.benco11.jlibecoledirecte.student.Cours;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "samples.volnetiks.dev/ecoledirecte";

    private static Session session;

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if (call.method.equals("connect")) {
                class ConnectionLoader extends AsyncTask<String, Integer, String> {
                    @Override
                    protected String doInBackground(String... strings) {
                        session = new Session(call.argument("username"), call.argument("password"));
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

                new ConnectionLoader().execute();
            } else if(call.method.equals("getStudentName")) {
                result.success(session.getAccount().getPrenom() + " " + session.getAccount().getNom());
            } else if(call.method.equals("getEmploiDuTemps")) {
                class EmploiDuTempsLoader extends AsyncTask<String, Integer, String> {
                    @Override
                    protected String doInBackground(String... strings) {
                        List<String> coursJson = new ArrayList<>();
                        try {
                            String cours = session.getEmploiDuTemps();
                            return cours;
                        } catch (EcoleDirecteUnknownConnectionException e) {
                            e.printStackTrace();
                            return "";
                        }
                    }

                    @Override
                    protected void onPostExecute(String cours) {
                        result.success(cours);
                    }
                }

                new EmploiDuTempsLoader().execute();
            } else {
                result.notImplemented();
            }
        });
    }
}
