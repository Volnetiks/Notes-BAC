package fr.benco11.jlibecoledirecte.student;

import java.util.List;

public class EmploiDuTemps {

    private List<Jour> jours;

    public EmploiDuTemps(List<Jour> jours) {
        this.jours = jours;
    }

    public List<Jour> getJours() {
        return jours;
    }

    public void setJours(List<Jour> jours) {
        this.jours = jours;
    }
}
