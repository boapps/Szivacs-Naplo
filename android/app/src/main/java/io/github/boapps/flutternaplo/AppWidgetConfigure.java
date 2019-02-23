package io.github.boapps.flutternaplo;

import android.app.Activity;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;

import org.json.JSONArray;
import org.json.JSONException;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class AppWidgetConfigure extends Activity {

    public String loadJSONFromAsset(Context context, String filename) {
        String json = null;
        System.out.println(filename);
        try {
            String yourFilePath = context.getDataDir() + "/app_flutter/" + filename + ".json";
            File yourFile = new File( yourFilePath );
            StringBuilder text = new StringBuilder();

            try {
                BufferedReader br = new BufferedReader(new FileReader(yourFile));
                String line;

                while ((line = br.readLine()) != null) {
                    text.append(line);
                    text.append('\n');
                }
                br.close();
            }
            catch (IOException e) {
                //You'll need to add proper error handling here
            }
            json = text.toString();

            System.out.println(json);
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
        return json;

    }

    int appWidgetId;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setResult(RESULT_CANCELED);
        setContentView(R.layout.activity_app_widget_configure);
        ListView lv = findViewById(R.id.listview);
        ArrayList<String> accounts = new ArrayList<>();
        ArrayList<Integer> ids = new ArrayList<>();

        try {
            JSONArray jArray = new JSONArray(loadJSONFromAsset(getApplicationContext(), "users"));
            for (int n = 0; n < jArray.length(); n++) {
                int id = jArray.getJSONObject(n).getInt("id");
                String name = jArray.getJSONObject(n).getString("name");
                accounts.add(name);
                ids.add(id);
            }
            } catch (JSONException e) {
            e.printStackTrace();
        }
        AccountsLVAdapter adapter = new AccountsLVAdapter(accounts, ids, getApplicationContext());
        lv.setAdapter(adapter);
        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapter, View v, int position, long l) {
                appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID;
                System.out.println(ids.get(position));
                Intent intent = getIntent();
                Bundle extras = intent.getExtras();
                if (extras != null) {
                    appWidgetId = extras.getInt(
                            AppWidgetManager.EXTRA_APPWIDGET_ID,
                            AppWidgetManager.INVALID_APPWIDGET_ID);

                    //If the intent doesn’t have a widget ID, then call finish()//

                    if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
                        finish();
                    }
                    Intent resultValue = new Intent();

                    System.out.println("created: " + String.valueOf(appWidgetId));
                    SharedPreferences.Editor prefs = getApplication().getSharedPreferences("prefs", 0).edit();
                    prefs.putInt(String.valueOf(appWidgetId), ids.get(position));
                    prefs.apply();

//Pass the original appWidgetId//

                    resultValue.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);

//Set the results from the configuration Activity//

                    setResult(RESULT_OK, resultValue);

                }
                finish();
            }
        });

    }
}
