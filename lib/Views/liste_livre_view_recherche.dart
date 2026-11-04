import '../views/modifier_livre_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/livre_controller.dart';
import '../models/livre_model.dart';
import 'ajouter_livre.dart';

class ListeLivresView extends StatefulWidget {
  const ListeLivresView({super.key});

  @override
  State<ListeLivresView> createState() => _ListeLivresViewState();
}

class _ListeLivresViewState extends State<ListeLivresView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final livreController = Provider.of<LivreController>(context, listen: false);

    // On choisit le flux en fonction du champ de recherche
    final Stream<List<Livre>> livresStream = _searchQuery.isEmpty
        ? livreController.getLivresStream()
        : livreController.rechercherLivres(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Bibliothèque'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AjouterLivreView()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ? Zone de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Rechercher un livre par titre...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
          ),

          // ? Liste des livres
          Expanded(
            child: StreamBuilder<List<Livre>>(
              stream: livresStream,
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AjouterLivreView()),
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
                 Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModifierLivreView(livre: livre),
          ),
        );
        break;
      case 'supprimer':
        _showDeleteDialog(context, livreController, livre.id!);
        break;
    }
  },
          itemBuilder: (context) => [
  PopupMenuItem(
    value: 'modifier',
    child: Row(
      children: [
        Icon(Icons.edit, color: Color(0xFF4CAF50), size: 20),
        const SizedBox(width: 8),
        const Text('Modifier'),
      ],
    ),
  ),
  PopupMenuItem(
    value: 'supprimer',
    child: Row(
      children: [
        Icon(Icons.delete, color: Colors.red[600], size: 20),
        const SizedBox(width: 8),
        const Text('Supprimer'),
      ],
    ),
  ),
],
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, LivreController controller, String id) {
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