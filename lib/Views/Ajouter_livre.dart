import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/livre_controller.dart';
import '../models/livre_model.dart';

class AjouterLivreView extends StatefulWidget {
  const AjouterLivreView({super.key});

  @override
  State<AjouterLivreView> createState() => _AjouterLivreViewState();
}

class _AjouterLivreViewState extends State<AjouterLivreView> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _auteurController = TextEditingController();
  final _anneeController = TextEditingController();
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final livreController = Provider.of<LivreController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un livre'),
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
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Ajouter le livre'),
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
      final nouveauLivre = Livre(
        titre: _titreController.text,
        auteur: _auteurController.text,
        annee: int.parse(_anneeController.text),
      );
      
      try {
        await livreController.ajouterLivre(nouveauLivre);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livre ajouté avec succès')),
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
  
  @override
  void dispose() {
    _titreController.dispose();
    _auteurController.dispose();
    _anneeController.dispose();
    super.dispose();
  }
}