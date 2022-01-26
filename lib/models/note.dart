import 'package:intl/intl.dart';

class Note {
  String codeMatiere,
      codePeriode,
      codeSousMatiere,
      coef,
      dateSaisie,
      devoir,
      libelleMatiere,
      typeDevoir;
  bool enLettre, nonSignificatif, valeurisee;
  List<String> elementsProgramme;
  double note, minClasse, moyenneClasse, maxClasse, noteSur;
  DateTime date;

  Note(
      {required this.codeMatiere,
      required this.codePeriode,
      required this.codeSousMatiere,
      required this.coef,
      required this.date,
      required this.dateSaisie,
      required this.devoir,
      required this.libelleMatiere,
      required this.note,
      required this.maxClasse,
      required this.minClasse,
      required this.moyenneClasse,
      required this.noteSur,
      required this.typeDevoir,
      required this.enLettre,
      required this.nonSignificatif,
      required this.valeurisee,
      required this.elementsProgramme});

  factory Note.fromJSON(Map<String, dynamic> json) {
    return Note(
      codeMatiere: json["codeMatiere"],
      codePeriode: json["codePeriode"],
      codeSousMatiere: json["codeSousMatiere"],
      coef: json["coef"],
      date: DateFormat("yyyy-M-d").parse(json["date"]),
      dateSaisie: json["dateSaisie"],
      devoir: json["devoir"],
      libelleMatiere: json["libelleMatiere"],
      maxClasse:
          json["maxClasse"] == "" ? -1.0 : double.parse(json["maxClasse"]),
      minClasse:
          json["minClasse"] == "" ? -1.0 : double.parse(json["minClasse"]),
      moyenneClasse: json["moyenneClasse"] == ""
          ? -1.0
          : double.parse(json["moyenneClasse"]),
      noteSur: double.parse(json["noteSur"]),
      typeDevoir: json["typeDevoir"],
      note: double.tryParse(json["valeur"].toString().replaceAll(",", ".")) !=
              null
          ? double.parse(json["valeur"].toString().replaceAll(",", "."))
          : -1.0,
      enLettre: json["enLettre"].toString().toLowerCase() == "true",
      nonSignificatif:
          json["nonSignificatif"].toString().toLowerCase() == "true",
      valeurisee: json["valeurisee"].toString().toLowerCase() == "true",
      elementsProgramme: List<String>.from(json["elementsProgramme"]),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "codeMatiere": codeMatiere,
      "codePeriode": codePeriode,
      "codeSousMatiere": codeSousMatiere,
      "coef": coef,
      "date": DateFormat("yyyy-M-d").format(date),
      "dateSaisie": dateSaisie,
      "devoir": devoir,
      "libelleMatiere": libelleMatiere,
      "maxClasse": maxClasse,
      "minClasse": minClasse,
      "moyenneClasse": moyenneClasse,
      "noteSur": noteSur,
      "typeDevoir": typeDevoir,
      "note": note,
      "enLettre": enLettre,
      "nonSignificatif": nonSignificatif,
      "valeurisee": valeurisee,
      "elementsProgramme": elementsProgramme,
    };
  }
}
