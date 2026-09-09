# Aplikasi Kalkulator Flutter

Aplikasi kalkulator sederhana yang dibuat menggunakan **Flutter** dan **Dart**. Aplikasi ini memiliki fitur login, operasi aritmatika dasar, pengecekan bilangan ganjil/genap, perhitungan jumlah total angka, serta informasi data kelompok.

## Fitur

### 1. Login
Pengguna harus melakukan login sebelum dapat mengakses aplikasi.

**Username:**

```
admin
```

**Password:**

```
admin123
```

Tersedia juga fitur **show/hide password** menggunakan tombol mata.

---

### 2. Kalkulator
Aplikasi menyediakan operasi aritmatika dasar:

- Penjumlahan `+`
- Pengurangan `-`
- Perkalian `x`
- Pembagian `÷`
- Hapus semua `C`
- Hapus satu karakter `⌫`
- Hasil perhitungan `=`

Contoh:

```
10 + 5 = 15
20 - 8 = 12
6 x 5 = 30
20 ÷ 4 = 5
```

---

### 3. Ganjil / Genap
Pengguna dapat memasukkan sebuah bilangan untuk menentukan apakah bilangan tersebut termasuk **ganjil** atau **genap**.

Contoh:

```
Input:
25

Output:
25 adalah bilangan GANJIL
```

atau:

```
Input:
20

Output:
20 adalah bilangan GENAP
```

---

### 4. Jumlah Total Angka
Pengguna dapat memasukkan beberapa angka dalam satu field input. Angka dipisahkan menggunakan tanda koma.

Contoh:

```
Input:
10, 20, 30, 40

Output:
Jumlah total = 100
```

---

### 5. Data Kelompok
Aplikasi menyediakan informasi anggota kelompok.

```
1. 
2. 
3. 
4. 
```

---

### 6. Logout
Pengguna dapat keluar dari aplikasi melalui tombol **Logout** pada bagian kanan atas halaman utama.

Setelah logout, pengguna akan kembali ke halaman login.

---

## Tampilan
Aplikasi menggunakan desain sederhana dengan kombinasi warna:

- 🔵 Biru
- ⚪ Putih

Tampilan dibuat dengan konsep sederhana dan mudah digunakan.

Komponen utama:

- Login form
- AppBar
- Popup menu
- Display kalkulator
- Tombol kalkulator berbentuk bulat
- Tombol operasi berbentuk persegi panjang
- Dialog untuk fitur tambahan

---

## Teknologi yang Digunakan

| Teknologi | Keterangan |
| --- | --- |
| Flutter | Framework untuk membangun aplikasi |
| Dart | Bahasa pemrograman |
| Material Design | Komponen dan desain antarmuka |
| Visual Studio Code | Code editor |
| Git & GitHub | Version control |

---

## Struktur Project

Struktur utama project:

```
calculator/
├── android/
├── ios/
├── lib/
│   └── main.dart
├── test/
├── web/
├── windows/
├── pubspec.yaml
└── README.md
```

File utama aplikasi berada di:

```
lib/main.dart
```

---

## Cara Menjalankan Project

### 1. Clone Repository

```
git clone https://github.com/gitaantonia/Calculator.git
```

### 2. Masuk ke Folder Project

```
cd NAMA-REPOSITORY
```

### 3. Install Dependencies

```
flutter pub get
```

### 4. Jalankan Aplikasi

```
flutter run
```

Pastikan emulator atau perangkat yang digunakan sudah terhubung.

---

## Akun Login

Gunakan akun berikut untuk masuk:

| Username | Password |
| --- | --- |
| `admin` | `admin123` |

---

## Alur Penggunaan

```text
┌───────────────┐
│     LOGIN     │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ HALAMAN UTAMA │
└───────┬───────┘
        │
        ├───────────────┐
        │               │
        ▼               ▼
   KALKULATOR       MENU TAMBAHAN
                       │
             ┌─────────┼──────────┐
             ▼         ▼          ▼
         Ganjil/   Jumlah      Data
          Genap     Angka      Kelompok
             │         │
             └─────────┴──────────┘
                       │
                       ▼
                    LOGOUT
                       │
                       ▼
                     LOGIN
```

---

## Tujuan Project

Project ini dibuat sebagai implementasi dasar pemrograman menggunakan **Dart dan Flutter**, khususnya dalam penerapan:

- Input dan output
- Variabel
- Tipe data
- Operator aritmatika
- Percabangan `if-else`
- Percabangan `switch-case`
- Perulangan `for`
- Fungsi
- State management sederhana menggunakan `setState()`
- Widget Flutter
- Form input
- Dialog
- Navigasi sederhana
- Event handling

---

## Anggota Kelompok

1. **Gita Antonia Sipayung**
2. 

---