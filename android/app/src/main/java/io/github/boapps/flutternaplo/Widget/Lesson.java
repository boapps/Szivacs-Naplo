package io.github.boapps.flutternaplo.Widget;

import java.util.Date;

/**
 * Created by boa on 07/10/17.
 */

public class Lesson {
    private int id;
    private int count;
    private int oraszam;
    private Date date;
    private Date start;
    private Date end;
    private String subject;
    private String subjectName;
    private String room;
    private String group;
    private String teacher;
    private String depTeacher;
    private String state;
    private String stateName;
    private String presence;
    private String presenceName;
    private String theme;
    private String homework;
    private String calendarOraType;

    public Lesson(int id, int count, int oraszam, Date date, Date start, Date end, String subject, String subjectName, String room, String group, String teacher, String depTeacher, String state, String stateName, String presence, String presenceName, String theme, String homework, String calendarOraType) {
        this.id = id;
        this.count = count;
        this.oraszam = oraszam;
        this.date = date;
        this.start = start;
        this.end = end;
        this.subject = subject;
        this.subjectName = subjectName;
        this.room = room;
        this.group = group;
        this.teacher = teacher;
        this.depTeacher = depTeacher;
        this.state = state;
        this.stateName = stateName;
        this.presence = presence;
        this.presenceName = presenceName;
        this.theme = theme;
        this.homework = homework;
        this.calendarOraType = calendarOraType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getOraszam() {
        return oraszam;
    }

    public void setOraszam(int oraszam) {
        this.oraszam = oraszam;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Date getStart() {
        return start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public String getRoom() {
        return room;
    }

    public void setRoom(String room) {
        this.room = room;
    }

    public String getGroup() {
        return group;
    }

    public void setGroup(String group) {
        this.group = group;
    }

    public String getTeacher() {
        return teacher;
    }

    public void setTeacher(String teacher) {
        this.teacher = teacher;
    }

    public String getDepTeacher() {
        return depTeacher;
    }

    public void setDepTeacher(String depTeacher) {
        this.depTeacher = depTeacher;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getStateName() {
        return stateName;
    }

    public void setStateName(String stateName) {
        this.stateName = stateName;
    }

    public String getPresence() {
        return presence;
    }

    public void setPresence(String presence) {
        this.presence = presence;
    }

    public String getPresenceName() {
        return presenceName;
    }

    public void setPresenceName(String presenceName) {
        this.presenceName = presenceName;
    }

    public String getTheme() {
        return theme;
    }

    public void setTheme(String theme) {
        this.theme = theme;
    }

    public String getHomework() {
        return homework;
    }

    public void setHomework(String homework) {
        this.homework = homework;
    }

    public String getCalendarOraType() {
        return calendarOraType;
    }

    public void setCalendarOraType(String calendarOraType) {
        this.calendarOraType = calendarOraType;
    }

}
