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
      maxClasse: double.parse(json["maxClasse"]),
      minClasse: double.parse(json["minClasse"]),
      moyenneClasse: double.parse(json["moyenneClasse"]),
      noteSur: double.parse(json["noteSur"]),
      typeDevoir: json["typeDevoir"],
      note: double.parse(json["valeur"].toString().replaceAll(",", ".")),
      enLettre: json["enLettre"].toString().toLowerCase() == "true",
      nonSignificatif:
          json["nonSignificatif"].toString().toLowerCase() == "true",
      valeurisee: json["valeurisee"].toString().toLowerCase() == "true",
      elementsProgramme: List<String>.from(json["elementsProgramme"]),
    );
  }
}
