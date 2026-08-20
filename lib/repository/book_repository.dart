import 'package:app_biblioteca/models/book.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class BookRepository{
  final SupabaseClient _client = Supabase.instance.client;
  

  // Legge tutte i libri
  Future <List<Book>> getAllBooks() async{
    final response  = await _client
    .from('books') // selezionala
    .select('*, authors(full_name)')
    .order('created_at',ascending: false);

    return(response as List)
    // response torna come lista dinamica
    // ogni elemento è una map<string , dynamic> che rappresenta una riga di book.
    // IL cast as list serve a dire che è una lista
    .map((json)=> Book.fromJson(json as Map<String, dynamic>))
    // map() scorre ogni elemento della lista , uno per uno.
    // per ognuno: prima lo castiamo esplicitimante a Map
    // poi lo passiamo a book.fromJson che lo trasforma
    // da json grezzo a Book tipizzato
    // a questo punto map restituisce non piu una lista di Map
    // ma un Iterable<Book>
    .toList();
  }


  // fa una ricerca dei libri
  Future<List<Book>> searchBooks(String query) async{
    final response = await _client
    .from('books')
    .select('* ,authors(full_name)')
    .or('title.ilike.%$query%,authors.full_name.ilike.%$query%')
    // .or applica un filtro where con condizione in OR;
    .order('title');
    // ordina i risultati per titolo

    return (response as List)
    .map((json) => Book.fromJson(json as Map<String,dynamic>))
    .toList();
  }

  // Prende i dettagli del libro
  Future <Book> getBookDetail(String bookId) async{
    // prende il libro singolo, con l'autore collegato via join
    final bookData = await _client
    .from('books')
    .select('* authors(full_name)')
    .eq('id', bookId)
    .single();

    // conto quanti prestiti attivi esistono per questo libro
    final activeLoans = await _client
    .from('loans')
    .select()
    .eq('book_id' , bookId)
    .isFilter('returned_at', null);

    // trasformo il json grezzo del libro in oggetto Book tipizzato
    // a questo punto book.availableCopies è ancora null: non l'abbiamo calcolato
    final book = Book.fromJson(bookData);

    // le copie disponibili = copie totali - quante sono attualmente in prestito.
    // (activeLoans as List) .lenght conta quante righe ha restituito la query 2
    final availableCopies = book.totalCopies - (activeLoans as List).length;


    //Book ha campi final non posso fare book.availableCopies =
    // copywith crea una nuova instanza di book identica a book in tutto per tutto
    // tranne available copies che ora è valorizato con il calcolo appena fatto
    return book.copyWith(availableCopies: availableCopies);
  }
}