import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
    static Future<void> initialize() async{
        await Supabase.initialize(
            url: 'https://wplpfekjcwdvpoocejhn.supabase.co',
            publishableKey: 'sb_publishable_oWHilFu2vGreoiCJb2Vm6Q_mPDFjt_8'
        );
    }
    static SupabaseClient get client => Supabase.instance.client;
}   