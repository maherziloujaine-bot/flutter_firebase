import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/livre_controller.dart';
import '../models/livre_model.dart';
import 'ajouter_livre.dart';

class ListeLivresView extends StatelessWidget {
  const ListeLivresView({super.key});

  @override
  Widget build(BuildContext context) {
    final livreController = Provider.of<LivreController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Bibliothèque'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AjouterLivreView()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Livre>>(
        stream: livreController.getLivresStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final livres = snapshot.data ?? [];
          
          if (livres.isEmpty) {
            return const Center(child: Text('Aucun livre trouvé'));
          }
          
          return ListView.builder(
            itemCount: livres.length,
            itemBuilder: (context, index) {
              final livre = livres[index];
              return LivreTile(livre: livre);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterLivreView()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LivreTile extends StatelessWidget {
  final Livre livre;
  
  const LivreTile({super.key, required this.livre});

  @override
  Widget build(BuildContext context) {
    final livreController = Provider.of<LivreController>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(livre.titre),
        subtitle: Text('${livre.auteur} - ${livre.annee}'),
        trailing: PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 'modifier':
                // Navigation vers modification
                break;
              case 'supprimer':
                _showDeleteDialog(context, livreController, livre.id!);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'modifier', child: Text('Modifier')),
            const PopupMenuItem(value: 'supprimer', child: Text('Supprimer')),
          ],
        ),
      ),
    );
  }
  
  void _showDeleteDialog(BuildContext context, LivreController controller, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce livre ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await controller.supprimerLivre(id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Livre supprimé avec succès')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur: $e')),
                );
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}