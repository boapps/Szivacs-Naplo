package io.github.boapps.flutternaplo.Widget;

import android.app.Activity;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.util.Log;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import org.json.JSONArray;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import io.github.boapps.flutternaplo.R;


/**
 * Created by boa on 21/10/17.
 */

public class WidgetRemoteViewsFactory implements RemoteViewsService.RemoteViewsFactory {
    public static Week ttweek;
    public static ArrayList<Lesson> lessons;
    ArrayList<Lesson> lessonsc = new ArrayList<>();
    private Context context = null;
    private int appWidgetId;
    private SharedPreferences sharedPreferences;
    private String user_id;


    public WidgetRemoteViewsFactory(Context context, Intent intent) {
        this.context = context;
        appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID);
        Log.d("AppWidgetId", String.valueOf(appWidgetId));

//        dbhelper = new DBHelper(this.context);
    }

    public String loadJSONFromAsset(Context context, String filename) {
        String json = null;
        String yourFilePath;
        try {
            yourFilePath = context.getFilesDir().toString().replace("files", "app_flutter") + "/timetable_" + filename + ".json";

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
                e.printStackTrace();
            }
            json = text.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return json;
        }
        return json;
    }
    private void updateWidgetListView() {
        sharedPreferences = context.getSharedPreferences("prefs", Activity.MODE_PRIVATE);
        user_id = String.valueOf(sharedPreferences.getInt(String.valueOf(appWidgetId), 0));
        Date from = new Date();
        Date to = new Date();
        from.setDate(from.getDate() - from.getDay() + 1);
        to.setDate(from.getDate() + 7);

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-M-d");

        lessons = new ArrayList<>();
        try {
            JSONArray jArray = new JSONArray(loadJSONFromAsset(context, String.valueOf(simpleDateFormat.format(from) + "_" + simpleDateFormat.format(to) + "-" + user_id)));
            System.out.println(jArray);
            System.out.println(jArray.get(1));
            for (int n = 0; n < jArray.length(); n++) {
                int id = jArray.getJSONObject(n).getInt("LessonId");
                int count = jArray.getJSONObject(n).getInt("Count");
                Date date = simpleDateFormat.parse(jArray.getJSONObject(n).getString("Date"));
                Date start = simpleDateFormat.parse(jArray.getJSONObject(n).getString("StartTime"));
                Date end = simpleDateFormat.parse(jArray.getJSONObject(n).getString("EndTime"));
                String subject = jArray.getJSONObject(n).getString("Subject");
                String subjectName = jArray.getJSONObject(n).getString("SubjectCategoryName");
                String room = jArray.getJSONObject(n).getString("ClassRoom");
                String group = jArray.getJSONObject(n).getString("ClassGroup");
                String teacher = jArray.getJSONObject(n).getString("Teacher");
                String depTeacher = jArray.getJSONObject(n).getString("DeputyTeacher");
                String state = jArray.getJSONObject(n).getString("State");
                String stateName = jArray.getJSONObject(n).getString("StateName");
                String presence = jArray.getJSONObject(n).getString("PresenceType");
                String presenceName = jArray.getJSONObject(n).getString("PresenceTypeName");
                String theme = jArray.getJSONObject(n).getString("Theme");
                String homework = jArray.getJSONObject(n).getString("Homework");
                String calendarOraType = jArray.getJSONObject(n).getString("CalendarOraType");

                int oraSzam = 0;
                Lesson lesson = new Lesson(id, count, oraSzam, date, start, end, subject, subjectName, room, group, teacher, depTeacher, state, stateName, presence, presenceName, theme, homework, calendarOraType);
                lessons.add(lesson);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        ArrayList<Lesson> lessonsm = new ArrayList<>();
        ArrayList<Lesson> lessonst = new ArrayList<>();
        ArrayList<Lesson> lessonsw = new ArrayList<>();
        ArrayList<Lesson> lessonsth = new ArrayList<>();
        ArrayList<Lesson> lessonsf = new ArrayList<>();

        for (Lesson lesson : lessons) {
            switch (lesson.getDate().getDay()) {
                case 1:
                    lessonsm.add(lesson);
                    break;
                case 2:
                    lessonst.add(lesson);
                    break;
                case 3:
                    lessonsw.add(lesson);
                    break;
                case 4:
                    lessonsth.add(lesson);
                    break;
                case 5:
                    lessonsf.add(lesson);
                    break;
            }
        }
        Date d = new Date();
        System.out.println(d.getDay());
        int day = 1;
        if (d.getDay() < 6)
            day = d.getDay();

        lessonsc.clear();
        for (Lesson lesson : lessons) {
            if (lesson.getDate().getDay() == day) {
                lessonsc.add(lesson);
            }
        }

        ttweek = new Week(from, lessonsm, lessonst, lessonsw, lessonsth, lessonsf);


    }

    @Override
    public int getCount() {
        return lessonsc.size();
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public RemoteViews getLoadingView() {
        return null;
    }

    @Override
    public RemoteViews getViewAt(int position) {
        RemoteViews remoteView = new RemoteViews(context.getPackageName(),
                R.layout.main_lv_item);
        remoteView.setTextViewText(R.id.value_tv, String.valueOf(lessonsc.get(position).getCount()));
        remoteView.setTextViewText(R.id.subject_tv, lessonsc.get(position).getSubjectName());
        remoteView.setTextViewText(R.id.date_tv, lessonsc.get(position).getRoom());

        return remoteView;
    }

    @Override
    public int getViewTypeCount() {
        // TODO Auto-generated method stub
        return 1;
    }

    @Override
    public boolean hasStableIds() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public void onCreate() {
        // TODO Auto-generated method stub
        updateWidgetListView();
    }

    @Override
    public void onDataSetChanged() {
        // TODO Auto-generated method stub
        updateWidgetListView();
    }

    @Override
    public void onDestroy() {
        // TODO Auto-generated method stub
        lessonsc.clear();
//        dbhelper.close();
    }
}
