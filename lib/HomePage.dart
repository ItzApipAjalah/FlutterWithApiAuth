import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _bukus = [];

  @override
  void initState() {
    _getListBuku();
    super.initState();
  }

  Future<void> _getListBuku() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      // Jika tidak ada token, maka tampilkan pesan atau lakukan tindakan lainnya
      return;
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/auth/listbuku'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _bukus = List<Map<String, dynamic>>.from(data['bukus']);
      });
    } else {
      // Handle error response
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('password');
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_bukus.isNotEmpty)
                Column(
                  children: _bukus.map((buku) {
                    return Column(
                      children: [
                        Image.network(
                          'http://127.0.0.1:8000/storage/${buku['thumbnail']}',
                          height: 100,
                          width: 100,
                        ),
                        Text('Judul: ${buku['judul']}'),
                        Text('Penerbit: ${buku['penerbit']}'),
                        Text('Pengarang: ${buku['pengarang']}'),
                        Text('Stok Buku: ${buku['stok_buku']}'),
                        Divider(),
                      ],
                    );
                  }).toList(),
                )
              else
                Text('No Books Available'),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _logout,
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
