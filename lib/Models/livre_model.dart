class Livre {
  String? id;
  String titre;
  String auteur;
  int annee;
  
  Livre({
    this.id,
    required this.titre,
    required this.auteur,
    required this.annee,
  });
  
  // Convertir Livre en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'titre': titre,
      'auteur': auteur,
      'annee': annee,
    };
  }
  
  // Créer Livre depuis Firestore document
  factory Livre.fromFirestore(Map data, String id) {
    return Livre(
      id: id,
      titre: data['titre'] ?? '',
      auteur: data['auteur'] ?? '',
      annee: data['annee'] ?? 0,
    );
  }
}