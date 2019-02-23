package io.github.boapps.flutternaplo.Widget;

import java.util.ArrayList;
import java.util.Date;

/**
 * Created by boa on 07/10/17.
 */

public class Week {

    private ArrayList<Lesson> monday;
    private ArrayList<Lesson> tuesday;
    private ArrayList<Lesson> wednesday;
    private ArrayList<Lesson> thursday;
    private ArrayList<Lesson> friday;
    private Date startDay;

    public Week(Date startDay, ArrayList<Lesson> monday, ArrayList<Lesson> tuesday, ArrayList<Lesson> wednesday, ArrayList<Lesson> thursday, ArrayList<Lesson> friday) {
        this.monday = monday;
        this.tuesday = tuesday;
        this.wednesday = wednesday;
        this.thursday = thursday;
        this.friday = friday;
        this.startDay = startDay;
    }

    public Date getStartday() {
        return startDay;
    }

    public void setStartday(Date startDay) {
        this.startDay = startDay;
    }

    public ArrayList<Lesson> getMonday() {
        return monday;
    }

    public void setMonday(ArrayList<Lesson> monday) {
        this.monday = monday;
    }

    public ArrayList<Lesson> getTuesday() {
        return tuesday;
    }

    public void setTuesday(ArrayList<Lesson> tuesday) {
        this.tuesday = tuesday;
    }

    public ArrayList<Lesson> getWednesday() {
        return wednesday;
    }

    public void setWednesday(ArrayList<Lesson> wednesday) {
        this.wednesday = wednesday;
    }

    public ArrayList<Lesson> getThursday() {
        return thursday;
    }

    public void setThursday(ArrayList<Lesson> thursday) {
        this.thursday = thursday;
    }

    public ArrayList<Lesson> getFriday() {
        return friday;
    }

    public void setFriday(ArrayList<Lesson> friday) {
        this.friday = friday;
    }

}
