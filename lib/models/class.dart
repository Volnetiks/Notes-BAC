import 'package:intl/intl.dart';

class Cours {
  String startDateString,
      endDateString,
      classe,
      classeCode,
      prof,
      matiere,
      salle,
      codeMatiere,
      typeCours,
      icone,
      text,
      groupe,
      groupeCode;
  bool dispensable,
      isFlexible,
      isAnnule,
      isModifie,
      contenuDeSeance,
      devoirAFaire;
  int dispense, classeId, groupeId;
  DateTime startDate, endDate;

  Cours({
    required this.startDateString,
    required this.endDateString,
    required this.classe,
    required this.classeCode,
    required this.prof,
    required this.matiere,
    required this.salle,
    required this.codeMatiere,
    required this.typeCours,
    required this.icone,
    required this.text,
    required this.groupe,
    required this.groupeCode,
    required this.dispensable,
    required this.isFlexible,
    required this.isAnnule,
    required this.isModifie,
    required this.contenuDeSeance,
    required this.devoirAFaire,
    required this.dispense,
    required this.classeId,
    required this.groupeId,
    required this.startDate,
    required this.endDate,
  });

  factory Cours.fromJSON(Map<String, dynamic> json) {
    DateFormat format = DateFormat("yyyy-M-d HH:m");

    return Cours(
      startDateString: json["start_date"],
      endDateString: json["end_date"],
      classe: json["classe"],
      classeCode: json["classeCode"],
      prof: json["prof"],
      matiere: json["matiere"],
      salle: json["salle"].replaceAll("<S.LYCEE->", ""),
      codeMatiere: json["codeMatiere"],
      typeCours: json["typeCours"],
      icone: json["icone"],
      text: json["text"],
      groupe: json["groupe"],
      groupeCode: json["groupeCode"],
      dispensable: json["dispensable"].toString().toLowerCase() == "true",
      isFlexible: json["isFlexible"].toString().toLowerCase() == "true",
      isAnnule: json["isAnnule"].toString().toLowerCase() == "true",
      isModifie: json["isModifie"].toString().toLowerCase() == "true",
      contenuDeSeance:
          json["contenuDeSeance"].toString().toLowerCase() == "true",
      devoirAFaire: json["devoirAFaire"].toString().toLowerCase() == "true",
      dispense: json["dispense"],
      classeId: json["classeId"],
      groupeId: json["groupeId"],
      startDate: format.parse(json["start_date"]),
      endDate: format.parse(json["end_date"]),
    );
  }
}
