import 'dart:convert';

import 'package:app_biblioteca/models/book.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class BookRepository{
  final SupabaseClient _client = Supabase.instance.client;
  

  // Legge tutte i libri
  Future getAllBooks() async{
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
}