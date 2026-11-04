import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/livre_controller.dart';
import '../models/livre_model.dart';

class ModifierLivreView extends StatefulWidget {
  final Livre livre;
  
  const ModifierLivreView({
    super.key,
    required this.livre,
  });

  @override
  State<ModifierLivreView> createState() => _ModifierLivreViewState();
}

class _ModifierLivreViewState extends State<ModifierLivreView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titreController;
  late TextEditingController _auteurController;
  late TextEditingController _anneeController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialiser les contrôleurs avec les valeurs existantes du livre
    _titreController = TextEditingController(text: widget.livre.titre);
    _auteurController = TextEditingController(text: widget.livre.auteur);
    _anneeController = TextEditingController(text: widget.livre.annee.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le livre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _auteurController,
                decoration: const InputDecoration(
                  labelText: 'Auteur',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un auteur';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _anneeController,
                decoration: const InputDecoration(
                  labelText: 'Année',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une année';
                  }
                  final annee = int.tryParse(value);
                  if (annee == null || annee < 0) {
                    return 'Veuillez entrer une année valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Modifier'),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final livreController = Provider.of<LivreController>(context, listen: false);
      
      // Créer un livre mis à jour avec le même ID
      final livreModifie = Livre(
        id: widget.livre.id, // Garder le même ID
        titre: _titreController.text,
        auteur: _auteurController.text,
        annee: int.parse(_anneeController.text),
      );
      
      try {
        // Appel à votre méthode modifierLivre qui prend l'ID et le livre
        await livreController.modifierLivre(livreModifie.id!, livreModifie);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livre modifié avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Supprimer le livre'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce livre ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Fermer la dialog
                await _deleteLivre(context);
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteLivre(BuildContext context) async {
    setState(() => _isLoading = true);
    
    final livreController = Provider.of<LivreController>(context, listen: false);
    
    try {
      await livreController.supprimerLivre(widget.livre.id!);
      Navigator.pop(context); // Retour à la liste
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livre supprimé avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  void dispose() {
    _titreController.dispose();
    _auteurController.dispose();
    _anneeController.dispose();
    super.dispose();
  }
}