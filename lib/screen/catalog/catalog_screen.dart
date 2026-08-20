import 'package:app_biblioteca/models/book.dart';
import 'package:app_biblioteca/repository/book_repository.dart';
import 'package:flutter/material.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({ Key? key }) : super(key: key);

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _repository = BookRepository();
  late Future<List<Book>> _booksFuture;


  @override
  void initState(){
    super.initState();
    // Il caricamento parte una sola volta , alla creazione dello screen.
    // Il future viene salvato in una variabile di stato FutureBuilder lo "osserva" senza rieseguire la query a ogni rebuild del widget.
    _booksFuture = _repository.getAllBooks();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catalogo')),
      body: FutureBuilder <List<Book>>(
        future: _booksFuture, 
        builder: (context, snapshot){
          // Stato 1 : richiesta ancora in corso -> spinner centrato
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),

            );
          }
          // Stato 2 la Future è fallita 
          if(snapshot.hasError){
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Errore nel caricamento del catalogo:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                )
              ),
            );
          }
          // Richiesta completata con sucesso
          // snapshot.data potrebbe teoricamente essere null, quindi usiamo ?? [] come difesa.
          final books = snapshot.data ?? [];

          // Stato 3 query andata buon fine ma nessun libro trovato
          if(books.isEmpty){
            return const Center(child: Text('Nessun libro trovato'));
          }

          // stato 4 mostriamo la lista
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index){
              final book = books[index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.authorName ?? 'Autore sconosciuto'),
                // Qui in futoro aggiungeremo la navigazione verso
                // book_detail_screen.dart passando book.id
              );
            },
          );
        }),
      
      
    );
  }
}