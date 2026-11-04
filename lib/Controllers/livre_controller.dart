import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/livre_model.dart';

class LivreController {
  // Instance principale de Firestore (point d’accès à la base de données)
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Référence à la collection "livres" dans Firestore
  // Cela évite de répéter _firestore.collection('livres') partout
  CollectionReference get _livresRef => _firestore.collection('livres');
  
  // ======================
  // ? CREATE - Ajouter un livre
  // ======================
  Future<void> ajouterLivre(Livre livre) async {
    try {
      // Ajoute un nouveau document dans la collection "livres"
      await _livresRef.add(livre.toMap());
    } catch (e) {
      throw "Erreur lors de l'ajout: $e";
    }
  }
  
  // ======================
  // ? READ - Récupérer tous les livres (en temps réel)
  // ======================
  Stream<List<Livre>> getLivresStream() {
    // Écoute en continu la collection "livres" (avec snapshots)
    // Chaque changement (ajout, modif, suppression) est automatiquement émis dans le Stream
    return _livresRef.snapshots().map((snapshot) {
      // Convertit chaque document Firestore en objet Livre
      return snapshot.docs.map((doc) {
        return Livre.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
  
  // ======================
  // ? READ - Récupérer un livre par son ID
  // ======================
  Future<Livre?> getLivreById(String id) async {
    try {
      // Récupère un document spécifique selon son ID
      final doc = await _livresRef.doc(id).get();
      
      // Si le document existe, on le transforme en objet Livre
      if (doc.exists) {
        return Livre.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      // Sinon, on retourne null
      return null;
    } catch (e) {
      throw 'Erreur lors de la récupération: $e';
    }
  }
  
  // ======================
  // ? UPDATE - Modifier un livre existant
  // ======================
  Future<void> modifierLivre(String id, Livre livre) async {
    try {
      // Met à jour le document correspondant à l’ID avec les nouvelles données
      await _livresRef.doc(id).update(livre.toMap());
    } catch (e) {
      throw 'Erreur lors de la modification: $e';
    }
  }
  
  // ======================
  // ? DELETE - Supprimer un livre
  // ======================
  Future<void> supprimerLivre(String id) async {
    try {
      // Supprime le document correspondant à l’ID fourni
      await _livresRef.doc(id).delete();
    } catch (e) {
      throw 'Erreur lors de la suppression: $e';
    }
  }
  
  // ======================
  // ? SEARCH - Rechercher des livres par titre
  // ======================
  Stream<List<Livre>> rechercherLivres(String query) {
    // Effectue une recherche "commence par" sur le champ 'titre'
    // grâce à isGreaterThanOrEqualTo et isLessThan
    return _livresRef
        .where('titre', isGreaterThanOrEqualTo: query)
        .where('titre', isLessThan: query + 'z')
        .snapshots()
        .map((snapshot) {
          // Transforme les résultats Firestore en liste de Livres
          return snapshot.docs.map((doc) {
            return Livre.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();
        });
  }
}