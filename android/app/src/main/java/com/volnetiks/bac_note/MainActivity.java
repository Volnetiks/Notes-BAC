package com.volnetiks.bac_note;

import android.os.AsyncTask;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.google.gson.Gson;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import fr.benco11.jlibecoledirecte.Session;
import fr.benco11.jlibecoledirecte.exceptions.EcoleDirecteAccountTypeException;
import fr.benco11.jlibecoledirecte.exceptions.EcoleDirecteIOException;
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
            } else if(call.method.equals("getEmploiDuTempsOn")) {
                class EmploiDuTempsLoader extends AsyncTask<String, Integer, String> {
                    @Override
                    protected String doInBackground(String... strings) {
                        try {
                            String cours = session.getEmploiDuTempsOn(call.argument("date"));
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
            } else if(call.method.equals("getNotes")) {
                class NotesLoader extends AsyncTask<String, Integer, String> {
                    @Override
                    protected String doInBackground(String... strings) {
                        try {
                            String json = session.getGrades();
                            return "";
                        } catch (EcoleDirecteIOException e) {
                            e.printStackTrace();
                        } catch (EcoleDirecteAccountTypeException e) {
                            e.printStackTrace();
                        }
                        return "";
                    }

                    @Override
                    protected void onPostExecute(String grade) {
                        result.success(grade);
                    }
                }

                new NotesLoader().execute();
            } else {
                result.notImplemented();
            }
        });
    }
}
