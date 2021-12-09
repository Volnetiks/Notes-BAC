package fr.benco11.jlibecoledirecte.student;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Cours {

    public String start_date, end_date, classe, classeCode, prof, matiere, salle, codeMatiere, typeCours, icone, text, groupe, groupeCode;
    public boolean dispensable, isFlexible, isAnnule, isModifie, contenuDeSeance, devoirAFaire;
    public int dispense, classeId, groupeId;
    public Date startDate, endDate;

    public Cours(String start_date, String end_date, String classe, String classeCode, String prof, String matiere, String salle, String codeMatiere, String typeCours, String icone, String text, String groupe, String groupeCode, boolean dispensable, boolean isFlexible, boolean isAnnule, boolean isModifie, boolean contenuDeSeance, boolean devoirAFaire, int dispense, int classeId, int groupeId) throws ParseException {
        this.start_date = start_date;
        this.end_date = end_date;
        this.classe = classe;
        this.classeCode = classeCode;
        this.prof = prof;
        this.matiere = matiere;
        this.salle = salle;
        this.codeMatiere = codeMatiere;
        this.typeCours = typeCours;
        this.icone = icone;
        this.text = text;
        this.groupe = groupe;
        this.groupeCode = groupeCode;
        this.dispensable = dispensable;
        this.isFlexible = isFlexible;
        this.isAnnule = isAnnule;
        this.isModifie = isModifie;
        this.contenuDeSeance = contenuDeSeance;
        this.devoirAFaire = devoirAFaire;
        this.dispense = dispense;
        this.classeId = classeId;
        this.groupeId = groupeId;
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        this.startDate = formatter.parse(this.start_date);
        this.endDate = formatter.parse(this.end_date);
    }

    public Cours() {}

    public String getStart_date() {
        return start_date;
    }

    public void setStart_date(String start_date) {
        this.start_date = start_date;
    }

    public String getEnd_date() {
        return end_date;
    }

    public void setEnd_date(String end_date) {
        this.end_date = end_date;
    }

    public String getClasse() {
        return classe;
    }

    public void setClasse(String classe) {
        this.classe = classe;
    }

    public String getClasseCode() {
        return classeCode;
    }

    public void setClasseCode(String classeCode) {
        this.classeCode = classeCode;
    }

    public String getProf() {
        return prof;
    }

    public void setProf(String prof) {
        this.prof = prof;
    }

    public String getMatiere() {
        return matiere;
    }

    public void setMatiere(String matiere) {
        this.matiere = matiere;
    }

    public String getSalle() {
        return salle;
    }

    public void setSalle(String salle) {
        this.salle = salle;
    }

    public String getCodeMatiere() {
        return codeMatiere;
    }

    public void setCodeMatiere(String codeMatiere) {
        this.codeMatiere = codeMatiere;
    }

    public String getTypeCours() {
        return typeCours;
    }

    public void setTypeCours(String typeCours) {
        this.typeCours = typeCours;
    }

    public String getIcon() {
        return icone;
    }

    public void setIcon(String icone) {
        this.icone = icone;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public String getGroupe() {
        return groupe;
    }

    public void setGroupe(String groupe) {
        this.groupe = groupe;
    }

    public String getGroupeCode() {
        return groupeCode;
    }

    public void setGroupeCode(String groupeCode) {
        this.groupeCode = groupeCode;
    }

    public boolean isDispensable() {
        return dispensable;
    }

    public void setDispensable(boolean dispensable) {
        this.dispensable = dispensable;
    }

    public boolean isFlexible() {
        return isFlexible;
    }

    public void setFlexible(boolean flexible) {
        isFlexible = flexible;
    }

    public boolean isAnnule() {
        return isAnnule;
    }

    public void setAnnule(boolean annule) {
        isAnnule = annule;
    }

    public boolean isModifie() {
        return isModifie;
    }

    public void setModifie(boolean modifie) {
        isModifie = modifie;
    }

    public boolean isContenuDeSeance() {
        return contenuDeSeance;
    }

    public void setContenuDeSeance(boolean contenuDeSeance) {
        this.contenuDeSeance = contenuDeSeance;
    }

    public boolean isDevoirAFaire() {
        return devoirAFaire;
    }

    public void setDevoirAFaire(boolean devoirAFaire) {
        this.devoirAFaire = devoirAFaire;
    }

    public int getDispense() {
        return dispense;
    }

    public void setDispense(int dispense) {
        this.dispense = dispense;
    }

    public int getClasseId() {
        return classeId;
    }

    public void setClasseId(int classeId) {
        this.classeId = classeId;
    }

    public int getGroupeId() {
        return groupeId;
    }

    public void setGroupeId(int groupeId) {
        this.groupeId = groupeId;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getStartTime() {
        return startDate.getHours() + ":" + startDate.getMinutes();
    }

    public String getEndTime() {
        return endDate.getHours() + ":" + endDate.getMinutes();
    }
}
