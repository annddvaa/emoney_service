## Aplikasi Service Pay dan Aplikasi DavPhone Service 

 * Nama: Dava Ananda Wahyudi
 * NIM: 1123150164
 * Kelas: TI23SE2P
 * Dosen Pengampu: I Ketut Gunawan,S.Kom,M.T.I
 * Mata Kuliah: Aplikasi Mobile Lanjutan

 Aplikasi ini di buat berdasarkan perintah yang di berikan oleh dosen pengampu mata kuliah aplikasi mobile lanjutan

## Arsitektur Aplikasi

Kedua aplikasi dikembangkan menggunakan bahasa pemrograman Dart dengan framework Flutter. Pendekatan arsitektur yang digunakan sedikit berbeda namun mengusung prinsip pemisahan tanggung jawab (*Separation of Concerns*).

1. **Service Pay (emoneyservice)** 
   Menggunakan pendekatan **Clean Architecture** (berbasis layer). Logika bisnis, pengelolaan data, dan antarmuka pengguna dipisah ke dalam layer `domain`, `data`, dan `presentation`. Arsitektur ini sangat cocok untuk aplikasi keuangan/e-money karena memberikan keamanan tingkat tinggi, *testability*, dan kemudahan *maintenance*. *State Management* yang digunakan adalah **BLoC (Business Logic Component)**.

2. **DavPhone Service (service_store)** 
   Menggunakan pendekatan **Feature-First Architecture** (berbasis fitur). Kode diatur berdasarkan fitur fungsional (contoh: *cart*, *dashboard*, *profile*), di mana setiap fitur memiliki presentasi, state, dan layanannya sendiri. Hal ini memudahkan iterasi cepat pada aplikasi e-commerce/toko karena mempermudah pencarian kode dalam satu modul utuh.

## Struktur Folder

### 1. Service Pay (`emoneyservice`)
```text
lib/
├── core/           # Utilitas inti, konfigurasi routing, tema (colors, typography), constant, error handling, services
├── data/           # Layer Data: Models, Repositories Implementation, Data Sources (Remote API, Local Storage)
├── domain/         # Layer Domain: Entities, Repositories Interface, Usecases
├── injection/      # Konfigurasi Dependency Injection (GetIt)
├── presentation/   # Layer Presentasi: Pages (UI), Widgets, BLoC (State Management)
├── main.dart       # Entry point aplikasi utama
└── firebase_options.dart # Konfigurasi integrasi Firebase
```

### 2. DavPhone Service (`service_store`)
```text
lib/
├── core/           # Konfigurasi utama aplikasi, routing, tema, utility, formatters
├── features/       # Berisi modul-modul fitur aplikasi
│   ├── auth/       # Fitur Autentikasi (Login, Register)
│   ├── cart/       # Fitur Keranjang Belanja/Service
│   ├── dashboard/  # Tampilan Utama (Beranda, Menu, Splash)
│   ├── history/    # Riwayat Transaksi/Layanan
│   ├── merchant/   # Fitur Toko / Merchant
│   ├── profile/    # Pengaturan Profil Pengguna
│   └── service/    # Modul pemesanan layanan (Service HP)
├── main.dart       # Entry point aplikasi utama
└── firebase_options.dart
```

## Flow Integrasi Kedua Aplikasi
Kedua aplikasi ini saling terhubung (terintegrasi) melalui mekanisme **Deep Linking (App Links)** dan komunikasi **REST API / Backend**.

1. **Eksplorasi & Pemesanan (DavPhone Service)**
   - Pengguna membuka **DavPhone Service** untuk melihat daftar layanan perbaikan HP atau suku cadang.
   - Pengguna menambahkan layanan ke dalam keranjang (*Cart*) dan melakukan *Checkout*.
   - Saat di halaman pembayaran, pengguna akan diberikan opsi metode pembayaran menggunakan **Service Pay**.

2. **Proses Pembayaran via Deep Link**
   - Saat tombol bayar ditekan, aplikasi `service_store` akan mem-*generate* URL Deep Link khusus (contoh: `dompetkampus://payment?...`) dan memanggil aplikasi **Service Pay**.
   - Aplikasi **Service Pay** akan otomatis terbuka. Jika aplikasi sedang dalam keadaan mati atau di-_background_, pengguna wajib melewati verifikasi sidik jari/biometrik.
   - Layar konfirmasi pembayaran akan muncul di Service Pay yang memuat detail tagihan dan informasi merchant.

3. **Verifikasi & Eksekusi Transaksi (Service Pay)**
   - Pengguna menekan tombol "Bayar" di layar konfirmasi Service Pay.
   - Keamanan transaksi ditingkatkan dengan autentikasi ganda, di mana pengguna wajib memasukkan **PIN 6 digit**.
   - Setelah PIN tervalidasi benar, Service Pay akan mengirimkan *request* mutasi saldo ke **Backend E-Money**.
   - Backend memproses transaksi tersebut dengan memotong (Debit) saldo pengguna dan mengirim dana (Kredit) ke merchant secara atomik.

4. **Callback & Konfirmasi Sukses**
   - Setelah transaksi berhasil diproses oleh sistem E-Money, Service Pay akan memanggil *Deep Link Callback* untuk mengarahkan pengguna kembali ke aplikasi **DavPhone Service** secara otomatis.
   - **DavPhone Service** menerima sinyal kembali dan me-*refresh* status pesanan di database menjadi "Dibayar / Diproses".
   - Secara bersamaan, pengguna juga dapat melihat riwayat transaksinya langsung di fitur Mutasi pada Service Pay.