package fr.benco11.jlibecoledirecte.student;

import java.time.DayOfWeek;
import java.util.List;

public class Jour {

    private List<Cours> cours;
    private int day;

    public Jour(List<Cours> cours, int day) {
        this.cours = cours;
        this.day = day;
    }

    public List<Cours> getCours() {
        return cours;
    }

    public void setCours(List<Cours> cours) {
        this.cours = cours;
    }

    public int getDay() {
        return day;
    }

    public void setDay(int day) {
        this.day = day;
    }
}
