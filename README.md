<div align="center">

# Service Pay
### Dompet Digital Kampus — Aplikasi E-Money Berbasis Flutter

<i>Tugas Ujian Akhir Semester (UAS) — Aplikasi Mobile Lanjutan</i>

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![BLoC](https://img.shields.io/badge/BLoC-Pattern-4B32C3?style=for-the-badge)](https://bloclibrary.dev)
[![License](https://img.shields.io/badge/License-Academic-lightgrey?style=for-the-badge)](#-lisensi)

<a href="https://hitscounter.dev">
  <img src="https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2Fannddvaa%2Femoney_service&label=Pengunjung&icon=eye-fill&color=%236C63FF" alt="Visitor Badge" />
</a>

</div>

<br/>

> **Service Pay** adalah dompet digital (E-Money) yang dibangun dengan **Clean Architecture** + **BLoC**, dilengkapi keamanan berlapis (2FA & biometrik), pembayaran QR, serta integrasi *deep link* langsung ke merchant **DavPhone Service** — semuanya dirancang seperti alur e-wallet production-grade, bukan sekadar CRUD saldo.

<div align="center">

| 👤 Nama | 🆔 NIM | 🏫 Kelas | 📚 Mata Kuliah | 👨‍🏫 Dosen Pengampu |
|:---:|:---:|:---:|:---:|:---:|
| Dava Ananda Wahyudi | 1123150164 | TI23SE2P | Aplikasi Mobile Lanjutan | I Ketut Gunawan, S.Kom, M.T.I |

</div>

---

## 📋 Daftar Isi

- [Tentang Aplikasi](#-tentang-aplikasi)
- [Ekosistem Aplikasi](#-ekosistem-aplikasi)
- [Tech Stack](#-tech-stack)
- [Fitur Utama](#-fitur-utama)
- [Arsitektur Aplikasi](#-arsitektur-aplikasi)
- [Flow Integrasi Kedua Aplikasi](#-flow-integrasi-kedua-aplikasi)
- [Struktur Folder](#-struktur-folder)
- [Screenshot Aplikasi](#-screenshot-aplikasi)
- [Video Presentasi](#-video-presentasi)
- [Cara Menjalankan Project](#-cara-menjalankan-project)
- [Lisensi](#-lisensi)

---

## 💡 Tentang Aplikasi

**Service Pay** adalah aplikasi dompet digital (E-Money) berbasis Flutter yang dibangun dengan **Clean Architecture** dan **BLoC State Management**. Aplikasi ini dirancang untuk meniru alur kerja dompet digital di dunia nyata — bukan sekadar simulasi saldo — lengkap dengan transfer saldo, top-up, pembayaran via QR, autentikasi dua faktor (2FA), login biometrik, serta integrasi *seamless* dengan merchant **DavPhone Service** melalui mekanisme *Deep Linking*.

Proyek ini merupakan tugas akhir mata kuliah Aplikasi Mobile Lanjutan yang sengaja dibangun sebagai **dua aplikasi terpisah namun saling terhubung**, untuk mensimulasikan bagaimana penyedia layanan e-money sungguhan (seperti GoPay, OVO, atau ShopeePay) bisa digunakan sebagai metode pembayaran di aplikasi pihak ketiga:

```
Service Pay        ── dompet digital / penyedia layanan pembayaran
DavPhone Service    ── e-commerce toko HP & aksesori (merchant / pihak ketiga)
```

Kedua aplikasi berjalan independen (masing-masing punya backend, database, dan autentikasi sendiri), tetapi bisa saling berkomunikasi melalui *deep link* saat proses checkout — persis seperti bagaimana aplikasi e-commerce sungguhan mengarahkan pengguna ke aplikasi e-wallet untuk menyelesaikan pembayaran.

---

## 🌐 Ekosistem Aplikasi

Proyek ini terdiri dari **4 repository** yang membentuk satu ekosistem terintegrasi:

<div align="center">

| Komponen | Deskripsi | Repository |
|:---:|:---|:---:|
| 📱 Frontend E-Money | Aplikasi Flutter Service Pay *(Anda di sini)* | — |
| ⚙️ Backend E-Money | REST API layanan E-Money & mutasi saldo | [emoney_backend](https://github.com/annddvaa/emoney_backend) |
| 🛍️ Frontend DavPhone Service | Aplikasi Flutter toko HP & aksesori | [service_store](https://github.com/annddvaa/service_store_uts_1123150164) |
| 🗄️ Backend DavPhone Service | REST API berbasis Go + Gin + Firebase | [gin-firebase-backend](https://github.com/annddvaa/gin-firebase-backend) |

</div>

---

## 🧰 Tech Stack

<div align="center">

![BLoC](https://img.shields.io/badge/State%20Management-BLoC-4B32C3?style=flat-square)
![GetIt](https://img.shields.io/badge/DI-get__it-02569B?style=flat-square)
![Dio](https://img.shields.io/badge/Networking-Dio-5C2D91?style=flat-square)
![GoRouter](https://img.shields.io/badge/Routing-go__router-02569B?style=flat-square)
![Secure Storage](https://img.shields.io/badge/Storage-Secure%20Storage-333333?style=flat-square)
![FCM](https://img.shields.io/badge/Notifikasi-Firebase%20Cloud%20Messaging-FFCA28?style=flat-square&logoColor=black)

</div>

---

## ✨ Fitur Utama

<table>
<tr>
<td width="50%" valign="top">

**🔐 Autentikasi & Keamanan**
- Register & Login via Email/OTP atau akun Google (Firebase Auth)
- 2FA (*Two-Factor Authentication*) via kode SMTP Email atau aplikasi TOTP Authenticator, sebagai lapisan verifikasi tambahan saat login
- Login biometrik (fingerprint) untuk membuka aplikasi tanpa perlu mengetik ulang kredensial
- PIN transaksi 6 digit sebagai autentikasi akhir sebelum saldo terpotong

**💰 Keuangan**
- Tampilan saldo real-time yang langsung sinkron dengan backend
- Top-up saldo dengan beberapa metode
- Riwayat mutasi lengkap, mencatat setiap saldo masuk maupun keluar
- Transfer saldo ke sesama pengguna Service Pay melalui alur 3 langkah (pilih penerima → input nominal → konfirmasi)

</td>
<td width="50%" valign="top">

**🏪 Pembayaran & Integrasi Merchant**
- Scan QR untuk membayar langsung di merchant tanpa perlu input manual
- Integrasi *seamless* dengan merchant **DavPhone Service** melalui *Deep Link*, lengkap dengan layar konfirmasi tagihan sebelum saldo dipotong
- Callback otomatis kembali ke aplikasi merchant setelah transaksi selesai

**🔔 Pengalaman Pengguna**
- Notifikasi push transaksi real-time via Firebase Cloud Messaging
- Riwayat transaksi yang bisa ditelusuri kapan saja
- Halaman khusus promo & voucher untuk pengguna

</td>
</tr>
</table>

---

## 🏛️ Arsitektur Aplikasi

Kedua aplikasi dikembangkan menggunakan Dart + Flutter dengan pendekatan arsitektur berbeda, namun sama-sama mengusung prinsip **Separation of Concerns**.

### 1. Service Pay — Clean Architecture

```
┌────────────────────────────────────────────┐
│           Presentation Layer                │
│    (BLoC, Pages, Widgets)                    │
├────────────────────────────────────────────┤
│              Domain Layer                    │
│    (Entities, Use Cases, Repo Interface)     │
├────────────────────────────────────────────┤
│               Data Layer                     │
│    (Models, Datasources, Repo Impl)          │
└────────────────────────────────────────────┘
```

Setiap layer punya tanggung jawab yang jelas dan tidak saling bergantung secara langsung:

- **Presentation Layer** — menangani UI dan state management (BLoC). Layer ini hanya tahu cara menampilkan data, tidak tahu dari mana data itu berasal.
- **Domain Layer** — inti bisnis aplikasi, berisi *entity* murni dan *use case* (aturan bisnis seperti "transfer saldo tidak boleh melebihi saldo tersedia"). Layer ini tidak bergantung pada Flutter maupun package eksternal apa pun.
- **Data Layer** — implementasi nyata dari repository, termasuk pemanggilan API (via Dio) dan penyimpanan lokal (secure storage untuk token & data sensitif).

> Pendekatan ini cocok untuk aplikasi keuangan karena memberi keamanan tinggi (logika bisnis terisolasi dari UI), *testability* (setiap layer bisa diuji terpisah), dan kemudahan *maintenance* saat aplikasi berkembang.

### 2. DavPhone Service — Feature-First Architecture

```
features/
├── auth/         → Fitur autentikasi
├── cart/         → Keranjang belanja
├── checkout/     → Proses checkout
├── dashboard/    → Beranda & produk
├── orders/       → Riwayat pesanan
└── profile/      → Profil pengguna
```

Setiap folder di dalam `features/` adalah modul mandiri yang membungkus `data/`, `domain/`, dan `presentation/`-nya sendiri, sehingga satu fitur bisa dikembangkan atau diperbaiki tanpa menyentuh fitur lain.

> Pendekatan ini memudahkan iterasi cepat, cocok untuk aplikasi e-commerce yang fiturnya terus bertambah (promo, kategori produk baru, metode pembayaran lain, dsb).

---

## 🔄 Flow Integrasi Kedua Aplikasi

```
┌─────────────────────┐         Deep Link          ┌─────────────────────┐
│   DavPhone Service   │ ─────────────────────────► │     Service Pay      │
│   (service_store)    │                            │   (emoney_service)   │
│                       │ ◄───────────────────────── │                       │
└─────────────────────┘      Callback Deep Link     └─────────────────────┘
         │                                                    │
         ▼                                                    ▼
  Backend DavPhone                                    Backend E-Money
  (gin-firebase-backend)                              (emoney_backend)
```

**Alur lengkapnya:**

1. 🛒 **Eksplorasi & Checkout** — Pengguna belanja di DavPhone Service, pilih metode bayar *Service Pay*
2. 🔗 **Deep Link** — App `service_store` generate URL `dompetkampus://payment?...` dan membuka Service Pay
3. 🔒 **Verifikasi Biometrik** — Service Pay meminta autentikasi sidik jari jika app di background
4. 📋 **Konfirmasi Pembayaran** — Layar konfirmasi muncul berisi detail tagihan & info merchant
5. 🔑 **Input PIN** — Pengguna memasukkan PIN 6 digit sebagai autentikasi akhir
6. ⚡ **Proses Transaksi** — Backend E-Money memotong saldo (debit) & mengkredit merchant secara atomik
7. 🔙 **Callback** — Service Pay memanggil deep link callback, pengguna kembali ke DavPhone Service otomatis
8. ✅ **Status Update** — DavPhone Service me-refresh status pesanan menjadi *Dibayar / Diproses*

---

## 📂 Struktur Folder

<details>
<summary><b>📁 Klik untuk melihat struktur <code>lib/</code> — Service Pay (emoney_service)</b></summary>

```text
lib/
├── core/
│   ├── constants/          # API endpoints, app constants
│   ├── error/              # Exceptions & Failures
│   ├── network/             # API Client (Dio)
│   ├── router/               # App Router (go_router)
│   ├── services/             # Biometric, Deep Link, Notification
│   ├── theme/                # Colors, Text Styles, App Theme
│   └── utils/                # BLoC Observer, Formatters
├── data/
│   ├── datasources/
│   │   ├── local/            # Secure Storage
│   │   └── remote/           # Auth, Account, Payment, OTP APIs
│   ├── models/                # Account, Transaction, User Models
│   └── repositories/          # Repository Implementations
├── domain/
│   ├── entities/               # Account, OTP, Payment, Transaction, User
│   ├── repositories/            # Repository Interfaces
│   └── usecases/                 # Auth, Account, Payment Use Cases
├── injection/                     # Dependency Injection (get_it)
├── presentation/
│   ├── blocs/                      # Auth, Account, Payment BLoCs
│   ├── pages/
│   │   ├── auth/                    # Login, Register, 2FA, Verify Email
│   │   ├── home/                     # Home Page
│   │   ├── payment/                   # QR, Deep Link, PIN
│   │   ├── topup/                      # Top Up
│   │   ├── transfer/                    # Transfer (3 steps)
│   │   ├── history/                      # Riwayat Transaksi
│   │   ├── promo/                         # Promo
│   │   └── splash/                         # Splash Screen
│   └── widgets/                              # Reusable Widgets
└── main.dart
```

</details>

<details>
<summary><b>📁 Klik untuk melihat struktur <code>lib/</code> — DavPhone Service (service_store)</b></summary>

```text
lib/
├── core/
│   ├── constants/          # API, Color, Strings
│   ├── providers/           # Theme Provider
│   ├── routes/                # App Router
│   ├── services/                # Deep Link Handler, Dio, Secure Storage
│   └── theme/                     # App Theme
└── features/
    ├── auth/                       # Login, Register, Verify Email
    ├── cart/                        # Keranjang Belanja
    ├── checkout/                     # Proses Checkout & Pembayaran
    ├── dashboard/                      # Beranda, Produk, Detail Produk
    ├── orders/                          # Riwayat Pesanan
    └── profile/                          # Profil Pengguna
```

</details>

---

## 📱 Screenshot Aplikasi

> Screenshot diurutkan sesuai alur pemakaian sebenarnya — mulai dari **splash screen**, **autentikasi**, sampai **transaksi selesai** — untuk masing-masing aplikasi.

### 💳 Service Pay — Dompet Digital

<table>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/39161B91-82F2-4147-93B1-FCFF24B189A6.jpeg" width="100%"/><br/>
<sub><b>1. Splash Screen</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/70EE91A9-26C7-4622-AD57-4932F92EFA7E.jpeg" width="100%"/><br/>
<sub><b>2. Halaman Awal — Buat Akun Baru / Masuk ke Akun</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/062B7AB6-2057-4943-9460-32CEB33D484D.jpeg" width="100%"/><br/>
<sub><b>3. Register — Buat Akun</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/DD3EECA7-302F-4674-83E1-A47006D1B33F.jpeg" width="100%"/><br/>
<sub><b>4. Login — Masuk ke Akun</b></sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/C2C3393D-9829-4093-9A34-EA6351502F73.jpeg" width="100%"/><br/>
<sub><b>5. Pilih Metode Verifikasi 2FA</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/4C47CC96-B347-4FE2-91D0-5D43638C18EC.jpeg" width="100%"/><br/>
<sub><b>6. Verifikasi OTP via Email</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/4592C3CF-C7A0-4FC4-9422-2FFAE3D47071.jpeg" width="100%"/><br/>
<sub><b>7. Hubungkan Authenticator (Scan QR)</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/F2DE2170-263D-4935-9844-DA702CD2CF46.jpeg" width="100%"/><br/>
<sub><b>8. Masukkan Kode Authenticator (TOTP)</b></sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/85ED3CAF-2E59-452C-937C-8E6BE667377A.jpeg" width="100%"/><br/>
<sub><b>9. Aktifkan Login Biometrik</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/145CA1D0-173A-4763-83E6-E8E748CE8970.jpeg" width="100%"/><br/>
<sub><b>10. Aplikasi Terkunci — Buka dengan Sidik Jari</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/51DFE087-84ED-4516-A67B-099D111F2DA3.jpeg" width="100%"/><br/>
<sub><b>11. Beranda — Saldo & Menu Utama</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/AF134CE8-3B17-4755-81CE-8FB748DD8320.jpeg" width="100%"/><br/>
<sub><b>12. Isi Saldo — Pilih Nominal & Metode</b></sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/251FC9E2-619F-46BD-88FA-CE14274C1053.jpeg" width="100%"/><br/>
<sub><b>13. Top Up Berhasil</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/C9EF8A31-C9EB-4481-8F4B-34983780FC14.jpeg" width="100%"/><br/>
<sub><b>14. Masukkan PIN Transaksi</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/EBDFFA49-1B45-4C10-941E-B0A1744A2C2B.jpeg" width="100%"/><br/>
<sub><b>15. Pembayaran Berhasil</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/8CE19DF8-862D-4788-AFC9-3A49D50635FE.jpeg" width="100%"/><br/>
<sub><b>16. Riwayat Transaksi</b></sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/B1510B6A-AA96-4E2D-B37E-B885F395A58C.jpeg" width="100%"/><br/>
<sub><b>17. Promo & Reward</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/3447A421-8FD7-4054-8EE4-41EB7C0E1A3C.jpeg" width="100%"/><br/>
<sub><b>18. Pengaturan Keamanan Akun</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/07FAFCCA-1E20-467A-BE91-E46D9CC90659.jpeg" width="100%"/><br/>
<sub><b>19. Ubah PIN Keamanan</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/8AB82453-38A5-4133-81ED-CE919373B0B4.jpeg" width="100%"/><br/>
<sub><b>20. Menu Akun & Pengaturan</b></sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/D9651473-9B8C-4EBE-8520-327FF1C08A18.jpeg" width="100%"/><br/>
<sub><b>21. Pengaturan — Verifikasi 2 Langkah</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/service-pay/EB381156-075B-4257-8651-9D4FC6A8203F.jpeg" width="100%"/><br/>
<sub><b>22. Biometrik Pembayaran Diaktifkan</b></sub>
</td>
</tr>
</table>

### 🛍️ DavPhone Service — Toko HP & Aksesori

<table>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/3487DE5A-D6A3-4DC9-A759-98B678EFDB38.jpeg" width="100%"/><br/>
<sub><b>1. Splash Screen — Memuat Aplikasi</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/F77DF0FB-80FB-411C-A192-83D5DCE69768.jpeg" width="100%"/><br/>
<sub><b>2. Splash Screen — Logo DavPhone</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/723EA9B9-0C22-4383-8EDC-C4C49BB5473F.jpeg" width="100%"/><br/>
<sub><b>3. Splash Screen — Logo DavPhone (2)</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/FA2E8DBB-EC87-4708-9EB9-9062D4D5692C.jpeg" width="100%"/><br/>
<sub><b>4. Splash Screen — DavPhone Service, Solusi Service HP Terpercaya</b></sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/C15D5D6D-A2DD-4A3A-A04A-3EEA41A2865D.jpeg" width="100%"/><br/>
<sub><b>5. Register — Buat Akun Baru</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/5D42A59E-93B2-4C5D-A2E9-569C645EA331.jpeg" width="100%"/><br/>
<sub><b>6. Login — Selamat Datang</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/04CBA802-F02D-4159-BE3B-D040B9302E21.jpeg" width="100%"/><br/>
<sub><b>7. Beranda — Kategori Semua</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/4BEDD5DA-746F-421F-92D4-5523D7B50FEB.jpeg" width="100%"/><br/>
<sub><b>8. Beranda — Tampilan Awal</b></sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/35702245-44CC-4959-8D9B-1C98A03DC3EE.jpeg" width="100%"/><br/>
<sub><b>9. Cari Layanan — Mengetik "Kamera"</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/8695F05E-D5BB-4FE7-B21A-22A603A139E5.jpeg" width="100%"/><br/>
<sub><b>10. Cari Layanan — Hasil Pencarian "Kamera"</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/DA58BAED-0523-402E-B5B1-B5D21C08124A.jpeg" width="100%"/><br/>
<sub><b>11. Beranda — Kategori Kamera</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/9A626E89-4990-4875-A271-4B8C1A40939D.jpeg" width="100%"/><br/>
<sub><b>12. Beranda — Kategori Charging</b></sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/F3B77494-408E-4962-BCDE-DE761CB49E9A.jpeg" width="100%"/><br/>
<sub><b>13. Beranda — Kategori Layar LCD</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/C702DFCC-5FC8-4467-8225-2895B40BF959.jpeg" width="100%"/><br/>
<sub><b>14. Beranda — Kategori Komponen HP Lainnya</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/F895D841-99F2-4676-BAD1-AA80463827D5.jpeg" width="100%"/><br/>
<sub><b>15. Beranda — Kategori Software</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/2F63A30D-0FA9-4BAA-BDBC-F0A630020CD1.jpeg" width="100%"/><br/>
<sub><b>16. Detail Layanan — Ganti LCD iPhone 13 Pro Max</b></sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/4E4E74FF-F8BD-4AF9-949F-A84C93F717A1.jpeg" width="100%"/><br/>
<sub><b>17. Detail Layanan — Tentang Layanan Ini</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/F39E0B49-5E53-4410-9331-1034981D226D.jpeg" width="100%"/><br/>
<sub><b>18. Keranjang Servis — Kosong</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/E42CAA13-671D-4378-B05D-BF65A38CEE65.jpeg" width="100%"/><br/>
<sub><b>19. Keranjang Servis — Kosongkan Keranjang</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/65E7CD61-F159-4EDF-8B68-D8E9C65B47F5.jpeg" width="100%"/><br/>
<sub><b>20. Checkout — Konfirmasi Pesanan & Pilih Metode Bayar</b></sub>
</td>
</tr>
<tr>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/2E505A09-0D69-4D8B-B590-9F063316A1E0.jpeg" width="100%"/><br/>
<sub><b>21. Konfirmasi Pembayaran (Deep Link ke Service Pay)</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/B3E36C09-98F6-4364-9DFC-A74222235839.jpeg" width="100%"/><br/>
<sub><b>22. Status Pesanan</b></sub>
</td>
<td align="center" width="25%">
<img src="assets/screenshots/davphone/2BC771C5-1A88-4233-A72C-AF4EE743A3B0.jpeg" width="100%"/><br/>
<sub><b>23. Akun Saya — Profil</b></sub>
</td>
</tr>
</table>

---

## 🎥 Video Presentasi

<div align="center">

[![Tonton Video Presentasi](https://img.shields.io/badge/YouTube-Tonton%20Video%20Presentasi-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtu.be/1mOkUh0BSwM?si=ahTFgtn-wwjjTRuO)

</div>

Video ini berisi presentasi lengkap **Service Pay**, mulai dari penjelasan latar belakang, demo alur autentikasi (2FA & biometrik), transaksi (top-up, transfer, pembayaran QR), hingga integrasi *deep link* dengan merchant **DavPhone Service**.

> ✏️ **Catatan:** Video ini dibuat dengan penuh perjuangan (dan kopi tengah malam), jadi mohon ditonton sampai habis ya, Pak/Bu 🙏😄.

---

## 🚀 Cara Menjalankan Project

### Prasyarat

- ✅ Flutter SDK **≥ 3.0.0**
- ✅ Dart **≥ 3.0.0**
- ✅ Android Studio / VS Code
- ✅ Emulator Android atau perangkat fisik
- ✅ Backend E-Money sudah berjalan ([lihat repo](https://github.com/annddvaa/emoney_backend))

### Langkah-Langkah

```bash
# 1. Cek instalasi Flutter
flutter doctor

# 2. Clone repositori ini
git clone https://github.com/annddvaa/emoney_service.git
cd emoney_service

# 3. Install semua dependensi
flutter pub get

# 4. Jalankan aplikasi
flutter run
```

> ⚠️ **Penting:** Pastikan Backend E-Money sudah berjalan sebelum menjalankan aplikasi ini agar fitur API dapat berfungsi dengan baik.

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademik (Ujian Akhir Semester). Tidak untuk dipublikasikan atau digunakan secara komersial tanpa izin.

---

<div align="center">

Made with ❤️ using **Flutter** & **BLoC**

⭐ Jangan lupa beri bintang kalau project ini membantu!

<a href="https://hitscounter.dev">
  <img src="https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2Fannddvaa%2Femoney_service&label=Total%20Pengunjung&icon=github&color=%236C63FF" alt="Total Visitor Badge" />
</a>

</div>
