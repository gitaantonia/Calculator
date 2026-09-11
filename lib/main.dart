import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiKalkulator());
}

// WARNA
const Color biru = Color(0xFF1565C0);
const Color putih = Color(0xFFFFFFFF);

bool _isOperator(String karakter) {
  return ['÷', 'x', '-', '+'].contains(karakter);
}

bool _isAngka(String karakter) {
  return RegExp(r'[0-9]').hasMatch(karakter);
}

String _normalisasiEkspresi(String ekspresi) {
  String hasil = '';

  for (int i = 0; i < ekspresi.length; i++) {
    final karakter = ekspresi[i];
    final karakterSebelumnya = i > 0 ? ekspresi[i - 1] : '';
    final karakterBerikutnya = i + 1 < ekspresi.length ? ekspresi[i + 1] : '';

    if (karakter == '(' &&
        (karakterSebelumnya == ')' || _isAngka(karakterSebelumnya))) {
      hasil += '*(';
      continue;
    }

    if (karakter == ')' &&
        (karakterBerikutnya == '(' || _isAngka(karakterBerikutnya))) {
      hasil += ')';
      if (karakterBerikutnya.isNotEmpty) {
        hasil += '*';
      }
      continue;
    }

    hasil += karakter;
  }

  return hasil.replaceAll('x', '*').replaceAll('÷', '/');
}

List<String> _tokenisasiEkspresi(String ekspresi) {
  final tokens = <String>[];
  String buffer = '';

  for (int i = 0; i < ekspresi.length; i++) {
    final karakter = ekspresi[i];

    if (RegExp(r'[0-9.]').hasMatch(karakter)) {
      buffer += karakter;
      continue;
    }

    if (buffer.isNotEmpty) {
      tokens.add(buffer);
      buffer = '';
    }

    if (karakter == '-' &&
        (i == 0 || ['+', '-', '*', '/', '('].contains(ekspresi[i - 1]))) {
      tokens.add('u-');
      continue;
    }

    if (karakter == '+' &&
        (i == 0 || ['+', '-', '*', '/', '('].contains(ekspresi[i - 1]))) {
      tokens.add('u+');
      continue;
    }

    if (['+', '-', '*', '/', '(', ')'].contains(karakter)) {
      tokens.add(karakter);
    }
  }

  if (buffer.isNotEmpty) {
    tokens.add(buffer);
  }

  return tokens;
}

class _ParserEkspresi {
  final List<String> tokens;
  int index = 0;

  _ParserEkspresi(this.tokens);

  double parse() {
    final result = _parseTambahKurang();
    if (index != tokens.length) {
      throw Exception('Ekspresi tidak valid');
    }
    return result;
  }

  double _parseTambahKurang() {
    double value = _parseKaliBagi();

    while (index < tokens.length &&
        (tokens[index] == '+' || tokens[index] == '-')) {
      final op = tokens[index++];
      final rhs = _parseKaliBagi();
      if (op == '+') {
        value += rhs;
      } else {
        value -= rhs;
      }
    }

    return value;
  }

  double _parseKaliBagi() {
    double value = _parseUnary();

    while (index < tokens.length &&
        (tokens[index] == '*' || tokens[index] == '/')) {
      final op = tokens[index++];
      final rhs = _parseUnary();
      if (op == '*') {
        value *= rhs;
      } else {
        if (rhs == 0) {
          throw Exception('Pembagi nol');
        }
        value /= rhs;
      }
    }

    return value;
  }

  double _parseUnary() {
    if (index < tokens.length &&
        (tokens[index] == 'u-' || tokens[index] == 'u+')) {
      final op = tokens[index++];
      final value = _parseUnary();
      return op == 'u-' ? -value : value;
    }

    return _parsePrimary();
  }

  double _parsePrimary() {
    if (index >= tokens.length) {
      throw Exception('Ekspresi tidak lengkap');
    }

    final token = tokens[index];

    if (token == '(') {
      index++;
      final value = _parseTambahKurang();
      if (index >= tokens.length || tokens[index] != ')') {
        throw Exception('Kurung tidak tertutup');
      }
      index++;
      return value;
    }

    if (RegExp(r'^[0-9]+(\.[0-9]+)?$').hasMatch(token)) {
      index++;
      return double.parse(token);
    }

    throw Exception('Token tidak valid');
  }
}

double? hitungEkspresi(String ekspresi) {
  final teks = _normalisasiEkspresi(ekspresi);
  final tokens = _tokenisasiEkspresi(teks);

  if (tokens.isEmpty) {
    return null;
  }

  try {
    return _ParserEkspresi(tokens).parse();
  } catch (_) {
    return null;
  }
}

// APLIKASI
class AplikasiKalkulator extends StatefulWidget {
  const AplikasiKalkulator({super.key});

  @override
  State<AplikasiKalkulator> createState() => _AplikasiKalkulatorState();
}

class _AplikasiKalkulatorState extends State<AplikasiKalkulator> {
  bool sudahLogin = false;

  void loginBerhasil() {
    setState(() {
      sudahLogin = true;
    });
  }

  void logout() {
    setState(() {
      sudahLogin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kalkulator',
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: putih,
        colorScheme: const ColorScheme.light(
          primary: biru,
          onPrimary: putih,
          secondary: biru,
          onSecondary: putih,
          surface: putih,
          onSurface: biru,
          error: biru,
          onError: putih,
        ),
      ),
      home: sudahLogin
          ? HalamanUtama(onLogout: logout)
          : HalamanLogin(onLogin: loginBerhasil),
    );
  }
}

// HALAMAN LOGIN

class HalamanLogin extends StatefulWidget {
  final VoidCallback onLogin;

  const HalamanLogin({super.key, required this.onLogin});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool sembunyikanPassword = true;

  void login() {
    if (usernameController.text == 'admin' &&
        passwordController.text == 'admin123') {
      widget.onLogin();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Username atau password salah',
            style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
          ),
          backgroundColor: putih,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: biru,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: putih,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    color: biru,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 30),

                // USERNAME
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: biru),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(color: biru),
                    prefixIcon: const Icon(Icons.person, color: biru),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: biru, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: biru, width: 3),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // PASSWORD
                TextField(
                  controller: passwordController,
                  obscureText: sembunyikanPassword,
                  style: const TextStyle(color: biru),
                  onSubmitted: (_) => login(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: biru),
                    prefixIcon: const Icon(Icons.lock, color: biru),
                    suffixIcon: IconButton(
                      icon: Icon(
                        sembunyikanPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: biru,
                      ),
                      onPressed: () {
                        setState(() {
                          sembunyikanPassword = !sembunyikanPassword;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: biru, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: biru, width: 3),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // TOMBOL LOGIN
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: biru,
                      foregroundColor: putih,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: putih,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// HALAMAN UTAMA
class HalamanUtama extends StatefulWidget {
  final VoidCallback onLogout;

  const HalamanUtama({super.key, required this.onLogout});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int nilaiPertama = 0;
  int nilaiKedua = 0;
  String operatorHitung = '';

  String tampilan = '0';
  void tampilkanJumlahAngka() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        String hasil = '';

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: putih,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'JUMLAH TOTAL ANGKA',
                style: TextStyle(color: biru, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Masukkan angka',
                      hintText: 'Contoh: 10, 20, 30',
                      prefixIcon: const Icon(Icons.calculate, color: biru),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: biru, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: biru, width: 3),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (hasil.isNotEmpty)
                    Text(
                      hasil,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: biru,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup', style: TextStyle(color: biru)),
                ),

                ElevatedButton(
                  onPressed: () {
                    try {
                      List<String> data = controller.text.split(',');

                      int total = 0;

                      for (String angka in data) {
                        total += int.parse(angka.trim());
                      }

                      setDialogState(() {
                        hasil = 'Jumlah total = $total';
                      });
                    } catch (e) {
                      setDialogState(() {
                        hasil = 'Format angka tidak valid!';
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: biru,
                    foregroundColor: putih,
                  ),
                  child: const Text('Hitung'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void tampilkanGanjilGenap() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        String hasil = '';

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: putih,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'GANJIL / GENAP',
                style: TextStyle(color: biru, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Masukkan bilangan',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: biru, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: biru, width: 3),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (hasil.isNotEmpty)
                    Text(
                      hasil,
                      style: const TextStyle(
                        color: biru,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup', style: TextStyle(color: biru)),
                ),

                ElevatedButton(
                  onPressed: () {
                    int? angka = int.tryParse(controller.text);

                    if (angka == null) {
                      setDialogState(() {
                        hasil = 'Masukkan angka yang valid!';
                      });
                      return;
                    }

                    setDialogState(() {
                      if (angka % 2 == 0) {
                        hasil = '$angka adalah bilangan GENAP';
                      } else {
                        hasil = '$angka adalah bilangan GANJIL';
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: biru,
                    foregroundColor: putih,
                  ),
                  child: const Text('Cek'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: putih,

      // APP BAR
      appBar: AppBar(
        backgroundColor: biru,
        foregroundColor: putih,
        title: const Text(
          'Kalkulator',
          style: TextStyle(color: putih, fontWeight: FontWeight.bold),
        ),
        actions: [
          // POPUP MENU
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: putih),
            onSelected: (pilihan) {
              if (pilihan == 'ganjil') {
                tampilkanGanjilGenap();
              } else if (pilihan == 'jumlah') {
                tampilkanJumlahAngka();
              } else if (pilihan == 'kelompok') {
                tampilkanDataKelompok();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'ganjil',
                child: Text('Ganjil / Genap'),
              ),
              const PopupMenuItem(
                value: 'jumlah',
                child: Text('Jumlah Total Angka'),
              ),
              const PopupMenuItem(
                value: 'kelompok',
                child: Text('Data Kelompok'),
              ),
            ],
          ),
          //
          
          IconButton(
            tooltip: 'Logout',
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout, color: putih),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // DISPLAY HASIL
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: biru,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FittedBox(
                    child: Text(
                      tampilan,
                      style: const TextStyle(
                        color: putih,
                        fontSize: 75,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // TOMBOL KALKULATOR
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 5, 12, 12),
                child: Column(
                  children: [
                    // BARIS ATAS - PERSEGI PANJANG
                    SizedBox(
                      height: 72,
                      child: Row(
                        children: [
                          _tombolLebar('C', warna: biru, aksi: hapusSemua),
                          _tombolLebar(
                            '(',
                            warna: biru,
                            aksi: () => tambahkanInput('('),
                          ),
                          _tombolLebar(
                            ')',
                            warna: biru,
                            aksi: () => tambahkanInput(')'),
                          ),
                          _tombolLebar('⌫', warna: biru, aksi: hapusTerakhir),
                          _tombolLebar(
                            '÷',
                            warna: biru,
                            aksi: () => tambahkanInput('÷'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // BARIS 2 - BULAT
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _tombolBulat('7'),
                          _tombolBulat('8'),
                          _tombolBulat('9'),
                          _tombolBulat(
                            'x',
                            warna: biru,
                            aksi: () => tambahkanInput('x'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // BARIS 3 - BULAT
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _tombolBulat('4'),
                          _tombolBulat('5'),
                          _tombolBulat('6'),
                          _tombolBulat(
                            '-',
                            warna: biru,
                            aksi: () => tambahkanInput('-'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // BARIS 4 - BULAT
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _tombolBulat('1'),
                          _tombolBulat('2'),
                          _tombolBulat('3'),
                          _tombolBulat(
                            '+',
                            warna: biru,
                            aksi: () => tambahkanInput('+'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // BARIS PALING BAWAH - PERSEGI PANJANG
                    SizedBox(
                      height: 72,
                      child: Row(
                        children: [
                          _tombolLebar(
                            '0',
                            warna: putih,
                            aksi: () => tambahkanInput('0'),
                          ),
                          _tombolLebar('=', warna: biru, aksi: prosesHitung),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DATA KELOMPOK
  void tampilkanDataKelompok() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: putih,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'DATA KELOMPOK',
            style: TextStyle(color: biru, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '1. Gita Antonia S. - 124240132\n'
            '2. Serena Luna H. - 124240035 \n'
            '3. Lucy Katarina B. 124240040\n'
            '4. Gevinta Aprilia P. - 124240114 ',
            style: TextStyle(color: biru, fontSize: 16, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(backgroundColor: biru),
              child: const Text(
                'Tutup',
                style: TextStyle(color: putih, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  // TOMBOL
  // TOMBOL BULAT
  Widget _tombolBulat(String teks, {Color warna = putih, VoidCallback? aksi}) {
    return SizedBox(
      width: 65,
      height: 65,
      child: ElevatedButton(
        onPressed: aksi ?? () => tambahkanInput(teks),
        style: ElevatedButton.styleFrom(
          backgroundColor: warna,
          foregroundColor: warna == biru ? putih : biru,
          padding: EdgeInsets.zero,
          side: const BorderSide(color: biru, width: 2),
          shape: const CircleBorder(),
          elevation: 0,
        ),
        child: Text(
          teks,
          style: TextStyle(
            color: warna == biru ? putih : biru,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // TOMBOL PERSEGI PANJANG
  Widget _tombolLebar(
    String teks, {
    required Color warna,
    required VoidCallback aksi,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: SizedBox(
          height: 72,
          child: ElevatedButton(
            onPressed: aksi,
            style: ElevatedButton.styleFrom(
              backgroundColor: warna,
              foregroundColor: warna == biru ? putih : biru,
              padding: EdgeInsets.zero,
              side: const BorderSide(color: biru, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
            ),
            child: Text(
              teks,
              style: TextStyle(
                color: warna == biru ? putih : biru,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // LOGIKA KALKULATOR
  void tambahkanInput(String input) {
    setState(() {
      if (tampilan == 'Error') {
        tampilan = '0';
      }

      final karakterTerakhir = tampilan == '0'
          ? ''
          : tampilan.substring(tampilan.length - 1);

      if (input == '0' && tampilan == '0') {
        return;
      }

      if (input == '(') {
        if (tampilan == '0') {
          tampilan = '(';
          return;
        }

        if (_isAngka(karakterTerakhir) || karakterTerakhir == ')') {
          tampilan += 'x';
        }

        tampilan += '(';
        return;
      }

      if (input == ')') {
        if (tampilan == '0' || !tampilan.contains('(')) {
          return;
        }

        if (_isOperator(karakterTerakhir) || karakterTerakhir == '(') {
          return;
        }

        tampilan += ')';
        return;
      }

      if (_isOperator(input)) {
        if (tampilan == '0') {
          if (input == '-') {
            tampilan = '-';
          }
          return;
        }

        if (karakterTerakhir == '(') {
          if (input == '-') {
            tampilan += '-';
          }
          return;
        }

        if (_isOperator(karakterTerakhir)) {
          tampilan = tampilan.substring(0, tampilan.length - 1) + input;
          operatorHitung = input;
          return;
        }

        operatorHitung = input;
        tampilan += input;
        return;
      }

      if (karakterTerakhir == ')' && _isAngka(input)) {
        tampilan += 'x';
      }

      if (tampilan == '0') {
        tampilan = input;
      } else {
        tampilan += input;
      }
    });
  }

  void prosesHitung() {
    setState(() {
      if (tampilan == '0' || tampilan == 'Error' || tampilan.isEmpty) {
        return;
      }

      final hasil = hitungEkspresi(tampilan);
      if (hasil == null) {
        tampilan = 'Error';
        operatorHitung = '';
        return;
      }

      if (hasil % 1 == 0) {
        tampilan = hasil.toInt().toString();
      } else {
        tampilan = hasil.toString();
      }

      operatorHitung = '';
    });
  }

  void hapusTerakhir() {
    setState(() {
      if (tampilan.length <= 1) {
        tampilan = '0';
        operatorHitung = '';
        return;
      }

      final karakterTerakhir = tampilan.substring(tampilan.length - 1);

      if (_isOperator(karakterTerakhir)) {
        operatorHitung = '';
      }

      tampilan = tampilan.substring(0, tampilan.length - 1);
    });
  }

  void hapusSemua() {
    setState(() {
      tampilan = '0';
      nilaiPertama = 0;
      nilaiKedua = 0;
      operatorHitung = '';
    });
  }
}