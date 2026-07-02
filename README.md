<div align="center">

# 💳 Service Pay — E-Money Frontend
**Tugas Ujian Akhir Semester (UAS) — Aplikasi Mobile Lanjutan**

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![BLoC](https://img.shields.io/badge/BLoC-Pattern-blue?style=for-the-badge)](https://bloclibrary.dev)

![Visitor Badge](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fannddvaa%2Femoney_service&count_bg=%236C63FF&title_bg=%23555555&icon=github.svg&icon_color=%23FFFFFF&title=Pengunjung&edge_flat=false)

Aplikasi E-Money modern dengan keamanan berlapis, integrasi biometrik, deep linking ke merchant, dan manajemen saldo real-time.

---

| 👤 **Nama** | Dava Ananda Wahyudi |
|:---|:---|
| 🆔 **NIM** | 1123150164 |
| 🏫 **Kelas** | TI23SE2P |
| 📚 **Mata Kuliah** | Aplikasi Mobile Lanjutan |
| 👨‍🏫 **Dosen Pengampu** | I Ketut Gunawan, S.Kom, M.T.I |

</div>

---

## 📋 Daftar Isi

- [Tentang Aplikasi](#-tentang-aplikasi)
- [Ekosistem Aplikasi](#-ekosistem-aplikasi)
- [Fitur Utama](#-fitur-utama)
- [Arsitektur](#-arsitektur-aplikasi)
- [Flow Integrasi](#-flow-integrasi-kedua-aplikasi)
- [Struktur Folder](#-struktur-folder)
- [Screenshot](#-screenshot-aplikasi)
- [Cara Menjalankan](#-cara-menjalankan-project)
- [Lisensi](#-lisensi)

---

## 💡 Tentang Aplikasi

**Service Pay** adalah aplikasi dompet digital (E-Money) berbasis Flutter yang dibangun dengan **Clean Architecture** dan **BLoC State Management**. Aplikasi ini mendukung transfer saldo, top-up, pembayaran via QR, autentikasi dua faktor (2FA), login biometrik, serta terintegrasi seamless dengan merchant **DavPhone Service** melalui mekanisme Deep Linking.

> 🔗 Aplikasi ini merupakan bagian dari ekosistem dua aplikasi yang saling terhubung — **Service Pay** sebagai dompet digital dan **DavPhone Service** sebagai platform e-commerce toko HP.

---

## 🌐 Ekosistem Aplikasi

Proyek ini terdiri dari **4 repository** yang membentuk satu ekosistem terintegrasi:

| Komponen | Deskripsi | Repository |
|:---:|:---|:---:|
| 📱 **Frontend E-Money** | Aplikasi Flutter Service Pay *(Anda di sini)* | — |
| ⚙️ **Backend E-Money** | REST API layanan E-Money & mutasi saldo | [Klik disini](https://github.com/annddvaa/emoney_backend) |
| 🛍️ **Frontend DavPhone Service** | Aplikasi Flutter toko HP & aksesori | [Klik disini](https://github.com/annddvaa/service_store_uts_1123150164) |
| 🗄️ **Backend DavPhone Service** | REST API berbasis Go + Gin + Firebase | [Klik disini](https://github.com/annddvaa/gin-firebase-backend) |

---

## ✨ Fitur Utama

| Fitur | Keterangan |
|:---|:---|
| 🔐 **Autentikasi Lengkap** | Register & Login via Email/OTP atau Google (Firebase Auth) |
| 🛡️ **2FA (Two-Factor Authentication)** | Verifikasi dua langkah via SMTP Email atau TOTP Authenticator |
| 👆 **Login Biometrik** | Keamanan tambahan dengan sidik jari (fingerprint) |
| 💰 **Manajemen Saldo** | Tampilan saldo real-time, top-up, dan riwayat mutasi |
| 📤 **Transfer Saldo** | Kirim saldo ke sesama pengguna Service Pay |
| 🔍 **Scan QR** | Bayar langsung via kode QR di merchant |
| 🏪 **Integrasi Merchant** | Pembayaran seamless ke DavPhone Service via Deep Link |
| 🔔 **Notifikasi Push** | Notifikasi transaksi real-time via Firebase Cloud Messaging |
| 📊 **Riwayat Transaksi** | Histori lengkap semua transaksi masuk dan keluar |
| 🎫 **Promo & Voucher** | Halaman khusus promo untuk pengguna |

---

## 🏛️ Arsitektur Aplikasi

Kedua aplikasi dikembangkan menggunakan Dart + Flutter dengan pendekatan arsitektur yang berbeda namun sama-sama mengusung prinsip **Separation of Concerns**.

### 1. Service Pay — Clean Architecture

```
┌────────────────────────────────────────────┐
│           Presentation Layer               │
│    (BLoC, Pages, Widgets)                  │
├────────────────────────────────────────────┤
│              Domain Layer                  │
│    (Entities, Use Cases, Repo Interface)   │
├────────────────────────────────────────────┤
│               Data Layer                   │
│    (Models, Datasources, Repo Impl)        │
└────────────────────────────────────────────┘
```

> Sangat cocok untuk aplikasi keuangan karena memberikan keamanan tinggi, *testability*, dan kemudahan *maintenance*.

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

> Memudahkan iterasi cepat karena setiap fitur merupakan modul mandiri (data, domain, presentation).

---

## 🔄 Flow Integrasi Kedua Aplikasi

```
┌─────────────────────┐         Deep Link          ┌─────────────────────┐
│   DavPhone Service  │ ─────────────────────────► │    Service Pay      │
│   (service_store)   │                            │   (emoney_service)  │
│                     │ ◄───────────────────────── │                     │
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
6. ⚡ **Proses Transaksi** — Backend E-Money memotong saldo (Debit) & mengkredit merchant secara atomik
7. 🔙 **Callback** — Service Pay memanggil deep link callback, pengguna kembali ke DavPhone Service otomatis
8. ✅ **Status Update** — DavPhone Service me-refresh status pesanan menjadi *Dibayar / Diproses*

---

## 📂 Struktur Folder

<details>
<summary><b>📁 Klik untuk melihat struktur <code>lib/</code> — Service Pay (emoneyservice)</b></summary>

```text
lib/
├── core/
│   ├── constants/          # API endpoints, app constants
│   ├── error/              # Exceptions & Failures
│   ├── network/            # API Client (Dio)
│   ├── router/             # App Router (go_router)
│   ├── services/           # Biometric, Deep Link, Notification
│   ├── theme/              # Colors, Text Styles, App Theme
│   └── utils/              # BLoC Observer, Formatters
├── data/
│   ├── datasources/
│   │   ├── local/          # Secure Storage
│   │   └── remote/         # Auth, Account, Payment, OTP APIs
│   ├── models/             # Account, Transaction, User Models
│   └── repositories/       # Repository Implementations
├── domain/
│   ├── entities/           # Account, OTP, Payment, Transaction, User
│   ├── repositories/       # Repository Interfaces
│   └── usecases/           # Auth, Account, Payment Use Cases
├── injection/              # Dependency Injection (get_it)
├── presentation/
│   ├── blocs/              # Auth, Account, Payment BLoCs
│   ├── pages/
│   │   ├── auth/           # Login, Register, 2FA, Verify Email
│   │   ├── home/           # Home Page
│   │   ├── payment/        # QR, Deep Link, PIN
│   │   ├── topup/          # Top Up
│   │   ├── transfer/       # Transfer (3 steps)
│   │   ├── history/        # Riwayat Transaksi
│   │   ├── promo/          # Promo
│   │   └── splash/         # Splash Screen
│   └── widgets/            # Reusable Widgets
└── main.dart
```

</details>

<details>
<summary><b>📁 Klik untuk melihat struktur <code>lib/</code> — DavPhone Service (service_store)</b></summary>

```text
lib/
├── core/
│   ├── constants/          # API, Color, Strings
│   ├── providers/          # Theme Provider
│   ├── routes/             # App Router
│   ├── services/           # Deep Link Handler, Dio, Secure Storage
│   └── theme/              # App Theme
└── features/
    ├── auth/               # Login, Register, Verify Email
    ├── cart/               # Keranjang Belanja
    ├── checkout/           # Proses Checkout & Pembayaran
    ├── dashboard/          # Beranda, Produk, Detail Produk
    ├── orders/             # Riwayat Pesanan
    └── profile/            # Profil Pengguna
```

</details>

---

## 📱 Screenshot Aplikasi

<p align="center">
  <img src="assets/screenshots/04CBA802-F02D-4159-BE3B-D040B9302E21.jpeg" width="22%" />
  <img src="assets/screenshots/062B7AB6-2057-4943-9460-32CEB33D484D.jpeg" width="22%" />
  <img src="assets/screenshots/07FAFCCA-1E20-467A-BE91-E46D9CC90659.jpeg" width="22%" />
  <img src="assets/screenshots/145CA1D0-173A-4763-83E6-E8E748CE8970.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/251FC9E2-619F-46BD-88FA-CE14274C1053.jpeg" width="22%" />
  <img src="assets/screenshots/2BC771C5-1A88-4233-A72C-AF4EE743A3B0.jpeg" width="22%" />
  <img src="assets/screenshots/2E505A09-0D69-4D8B-B590-9F063316A1E0.jpeg" width="22%" />
  <img src="assets/screenshots/2F63A30D-0FA9-4BAA-BDBC-F0A630020CD1.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/3447A421-8FD7-4054-8EE4-41EB7C0E1A3C.jpeg" width="22%" />
  <img src="assets/screenshots/3487DE5A-D6A3-4DC9-A759-98B678EFDB38.jpeg" width="22%" />
  <img src="assets/screenshots/35702245-44CC-4959-8D9B-1C98A03DC3EE.jpeg" width="22%" />
  <img src="assets/screenshots/39161B91-82F2-4147-93B1-FCFF24B189A6.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/4592C3CF-C7A0-4FC4-9422-2FFAE3D47071.jpeg" width="22%" />
  <img src="assets/screenshots/4BEDD5DA-746F-421F-92D4-5523D7B50FEB.jpeg" width="22%" />
  <img src="assets/screenshots/4C47CC96-B347-4FE2-91D0-5D43638C18EC.jpeg" width="22%" />
  <img src="assets/screenshots/4E4E74FF-F8BD-4AF9-949F-A84C93F717A1.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/51DFE087-84ED-4516-A67B-099D111F2DA3.jpeg" width="22%" />
  <img src="assets/screenshots/5D42A59E-93B2-4C5D-A2E9-569C645EA331.jpeg" width="22%" />
  <img src="assets/screenshots/65E7CD61-F159-4EDF-8B68-D8E9C65B47F5.jpeg" width="22%" />
  <img src="assets/screenshots/70EE91A9-26C7-4622-AD57-4932F92EFA7E.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/723EA9B9-0C22-4383-8EDC-C4C49BB5473F.jpeg" width="22%" />
  <img src="assets/screenshots/85ED3CAF-2E59-452C-937C-8E6BE667377A.jpeg" width="22%" />
  <img src="assets/screenshots/8695F05E-D5BB-4FE7-B21A-22A603A139E5.jpeg" width="22%" />
  <img src="assets/screenshots/8AB82453-38A5-4133-81ED-CE919373B0B4.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/8CE19DF8-862D-4788-AFC9-3A49D50635FE.jpeg" width="22%" />
  <img src="assets/screenshots/9A626E89-4990-4875-A271-4B8C1A40939D.jpeg" width="22%" />
  <img src="assets/screenshots/AF134CE8-3B17-4755-81CE-8FB748DD8320.jpeg" width="22%" />
  <img src="assets/screenshots/B1510B6A-AA96-4E2D-B37E-B885F395A58C.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/B3E36C09-98F6-4364-9DFC-A74222235839.jpeg" width="22%" />
  <img src="assets/screenshots/C15D5D6D-A2DD-4A3A-A04A-3EEA41A2865D.jpeg" width="22%" />
  <img src="assets/screenshots/C2C3393D-9829-4093-9A34-EA6351502F73.jpeg" width="22%" />
  <img src="assets/screenshots/C702DFCC-5FC8-4467-8225-2895B40BF959.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/C9EF8A31-C9EB-4481-8F4B-34983780FC14.jpeg" width="22%" />
  <img src="assets/screenshots/D9651473-9B8C-4EBE-8520-327FF1C08A18.jpeg" width="22%" />
  <img src="assets/screenshots/DA58BAED-0523-402E-B5B1-B5D21C08124A.jpeg" width="22%" />
  <img src="assets/screenshots/DD3EECA7-302F-4674-83E1-A47006D1B33F.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/E42CAA13-671D-4378-B05D-BF65A38CEE65.jpeg" width="22%" />
  <img src="assets/screenshots/EB381156-075B-4257-8651-9D4FC6A8203F.jpeg" width="22%" />
  <img src="assets/screenshots/EBDFFA49-1B45-4C10-941E-B0A1744A2C2B.jpeg" width="22%" />
  <img src="assets/screenshots/F2DE2170-263D-4935-9844-DA702CD2CF46.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/F39E0B49-5E53-4410-9331-1034981D226D.jpeg" width="22%" />
  <img src="assets/screenshots/F3B77494-408E-4962-BCDE-DE761CB49E9A.jpeg" width="22%" />
  <img src="assets/screenshots/F77DF0FB-80FB-411C-A192-83D5DCE69768.jpeg" width="22%" />
  <img src="assets/screenshots/F895D841-99F2-4676-BAD1-AA80463827D5.jpeg" width="22%" />
</p>
<p align="center">
  <img src="assets/screenshots/FA2E8DBB-EC87-4708-9EB9-9062D4D5692C.jpeg" width="22%" />
</p>

---

## 🚀 Cara Menjalankan Project

### Prasyarat

- ✅ Flutter SDK **≥ 3.0.0**
- ✅ Dart **≥ 3.0.0**
- ✅ Android Studio / VS Code
- ✅ Emulator Android atau perangkat fisik
- ✅ Backend E-Money sudah berjalan ([lihat repo](https://github.com/annddvaa/emoney_backend))

### Langkah-Langkah

**1. Cek instalasi Flutter**
```bash
flutter doctor
```

**2. Clone repositori ini**
```bash
git clone https://github.com/annddvaa/emoney_service.git
cd emoney_service
```

**3. Install semua dependensi**
```bash
flutter pub get
```

**4. Jalankan aplikasi**
```bash
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

![Visitor Badge](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fannddvaa%2Femoney_service&count_bg=%236C63FF&title_bg=%23555555&icon=github.svg&icon_color=%23FFFFFF&title=Total+Pengunjung&edge_flat=false)

</div>
