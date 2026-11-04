import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/livre_model.dart';

class LivreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Référence à la collection
  CollectionReference get _livresRef => _firestore.collection('livres');
  
  // CREATE - Ajouter un livre
  Future<void> ajouterLivre(Livre livre) async {
    try {
      await _livresRef.add(livre.toMap());
    } catch (e) {
      throw "Erreur lors de l'ajout: $e";
    }
  }
  
  // READ - Récupérer tous les livres (Stream)
  Stream<List<Livre>> getLivresStream() {
    return _livresRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Livre.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
  
  // READ - Récupérer un livre par ID
  Future<Livre?> getLivreById(String id) async {
    try {
      final doc = await _livresRef.doc(id).get();
      if (doc.exists) {
        return Livre.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw 'Erreur lors de la récupération: $e';
    }
  }
  
  // UPDATE - Modifier un livre
  Future<void> modifierLivre(String id, Livre livre) async {
    try {
      await _livresRef.doc(id).update(livre.toMap());
    } catch (e) {
      throw 'Erreur lors de la modification: $e';
    }
  }
  
  // DELETE - Supprimer un livre
  Future<void> supprimerLivre(String id) async {
    try {
      await _livresRef.doc(id).delete();
    } catch (e) {
      throw 'Erreur lors de la suppression: $e';
    }
  }
  
  // Recherche par titre
  Stream<List<Livre>> rechercherLivres(String query) {
    return _livresRef
        .where('titre', isGreaterThanOrEqualTo: query)
        .where('titre', isLessThan: query + 'z')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Livre.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }
}