package fr.benco11.jlibecoledirecte.student;

import java.util.List;

public class Note {

    public String codeMatiere, codePeriode, codeSousMatiere, coef, date, dateSaisie, devoir, libelleMatiere, maxClasse, minClasse, moyenneClasse, noteSur, typeDevoir, valeur;
    public boolean enLettre, nonSignificatif, valeurisee;
    public List<String> elementsProgramme;

    public Note(String codeMatiere, String codePeriode, String codeSousMatiere, String coef, String date, String dateSaisie, String devoir, String libelleMatiere, String maxClasse, String minClasse, String moyenneClasse, String noteSur, String typeDevoir, String valeur, boolean enLettre, boolean nonSignificatif, boolean valeurisee, List<String> elementsProgramme) {
        this.codeMatiere = codeMatiere;
        this.codePeriode = codePeriode;
        this.codeSousMatiere = codeSousMatiere;
        this.coef = coef;
        this.date = date;
        this.dateSaisie = dateSaisie;
        this.devoir = devoir;
        this.libelleMatiere = libelleMatiere;
        this.maxClasse = maxClasse;
        this.minClasse = minClasse;
        this.moyenneClasse = moyenneClasse;
        this.noteSur = noteSur;
        this.typeDevoir = typeDevoir;
        this.valeur = valeur;
        this.enLettre = enLettre;
        this.nonSignificatif = nonSignificatif;
        this.valeurisee = valeurisee;
        this.elementsProgramme = elementsProgramme;
    }

    public String getCodeMatiere() {
        return codeMatiere;
    }

    public void setCodeMatiere(String codeMatiere) {
        this.codeMatiere = codeMatiere;
    }

    public String getCodePeriode() {
        return codePeriode;
    }

    public void setCodePeriode(String codePeriode) {
        this.codePeriode = codePeriode;
    }

    public String getCodeSousMatiere() {
        return codeSousMatiere;
    }

    public void setCodeSousMatiere(String codeSousMatiere) {
        this.codeSousMatiere = codeSousMatiere;
    }

    public String getCoef() {
        return coef;
    }

    public void setCoef(String coef) {
        this.coef = coef;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getDateSaisie() {
        return dateSaisie;
    }

    public void setDateSaisie(String dateSaisie) {
        this.dateSaisie = dateSaisie;
    }

    public String getDevoir() {
        return devoir;
    }

    public void setDevoir(String devoir) {
        this.devoir = devoir;
    }

    public String getLibelleMatiere() {
        return libelleMatiere;
    }

    public void setLibelleMatiere(String libelleMatiere) {
        this.libelleMatiere = libelleMatiere;
    }

    public String getMaxClasse() {
        return maxClasse;
    }

    public void setMaxClasse(String maxClasse) {
        this.maxClasse = maxClasse;
    }

    public String getMinClasse() {
        return minClasse;
    }

    public void setMinClasse(String minClasse) {
        this.minClasse = minClasse;
    }

    public String getMoyenneClasse() {
        return moyenneClasse;
    }

    public void setMoyenneClasse(String moyenneClasse) {
        this.moyenneClasse = moyenneClasse;
    }

    public String getNoteSur() {
        return noteSur;
    }

    public void setNoteSur(String noteSur) {
        this.noteSur = noteSur;
    }

    public String getTypeDevoir() {
        return typeDevoir;
    }

    public void setTypeDevoir(String typeDevoir) {
        this.typeDevoir = typeDevoir;
    }

    public String getValeur() {
        return valeur;
    }

    public void setValeur(String valeur) {
        this.valeur = valeur;
    }

    public boolean isEnLettre() {
        return enLettre;
    }

    public void setEnLettre(boolean enLettre) {
        this.enLettre = enLettre;
    }

    public boolean isNonSignificatif() {
        return nonSignificatif;
    }

    public void setNonSignificatif(boolean nonSignificatif) {
        this.nonSignificatif = nonSignificatif;
    }

    public boolean isValeurisee() {
        return valeurisee;
    }

    public void setValeurisee(boolean valeurisee) {
        this.valeurisee = valeurisee;
    }

    public List<String> getElementsProgramme() {
        return elementsProgramme;
    }

    public void setElementsProgramme(List<String> elementsProgramme) {
        this.elementsProgramme = elementsProgramme;
    }
}
