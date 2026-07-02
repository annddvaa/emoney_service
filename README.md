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
lib
|   firebase_options.dart
|   main.dart
|   
+---core
|   +---constants
|   |       api_endpoints.dart
|   |       app_constants.dart
|   +---error
|   |       exceptions.dart
|   |       failures.dart
|   +---network
|   |       api_client.dart
|   +---router
|   |       app_router.dart
|   +---services
|   |       biometric_service.dart
|   |       deeplink_callback_service.dart
|   |       deeplink_service.dart
|   |       notification_service.dart
|   +---theme
|   |       app_colors.dart
|   |       app_text_styles.dart
|   |       app_theme.dart
|   \---utils
|           app_bloc_observer.dart
|           currency_formatter.dart
|           date_formatter.dart
+---data
|   +---datasources
|   |   +---local
|   |   |       secure_storage_datasource.dart
|   |   \---remote
|   |           account_remote_datasource.dart
|   |           auth_remote_datasource.dart
|   |           otp_remote_datasource.dart
|   |           payment_remote_datasource.dart
|   +---models
|   |       account_model.dart
|   |       transaction_model.dart
|   |       user_model.dart
|   \---repositories
|           account_repository_impl.dart
|           auth_repository_impl.dart
|           otp_repository_impl.dart
|           payment_repository_impl.dart
+---domain
|   +---entities
|   |       account_entity.dart
|   |       otp_entity.dart
|   |       payment_result_entity.dart
|   |       transaction_entity.dart
|   |       user_entity.dart
|   +---repositories
|   |       account_repository.dart
|   |       auth_repository.dart
|   |       otp_repository.dart
|   |       payment_repository.dart
|   \---usecases
|       +---account
|       |       get_account_usecase.dart
|       +---auth
|       |       get_me_usecase.dart
|       |       logout_usecase.dart
|       |       register_with_otp_usecase.dart
|       |       send_otp_usecase.dart
|       |       verify_email_otp_usecase.dart
|       |       verify_firebase_token_usecase.dart
|       \---payment
|               payment_usecases.dart
+---injection
|       injection_container.dart
\---presentation
    +---blocs
    |   +---account
    |   |       account_bloc.dart
    |   +---auth
    |   |       auth_bloc.dart
    |   |       otp_bloc.dart
    |   +---home
    |   \---payment
    |           payment_bloc.dart
    +---pages
    |   +---account
    |   |       account_page.dart
    |   +---auth
    |   |       login_page.dart
    |   |       register_page.dart
    |   |       setup_2fa_page.dart
    |   |       twofa_notif_page.dart
    |   |       twofa_smtp_page.dart
    |   |       twofa_totp_page.dart
    |   |       verify_email_page.dart
    |   +---history
    |   |       history_page.dart
    |   +---home
    |   |       home_page.dart
    |   +---merchant
    |   |       merchant_checkout_page.dart
    |   +---payment
    |   |       payment_deeplink_page.dart
    |   |       payment_qr_page.dart
    |   |       pin_page.dart
    |   +---promo
    |   |       promo_page.dart
    |   +---splash
    |   |       splash_page.dart
    |   +---success
    |   |       success_page.dart
    |   +---topup
    |   |       topup_page.dart
    |   +---transfer
    |   |       transfer_amount_page.dart
    |   |       transfer_confirm_page.dart
    |   |       transfer_page.dart
    |   \---welcome
    |           welcome_page.dart
    \---widgets
            app_avatar.dart
            app_badge.dart
            app_button.dart
            app_field.dart
            app_logo.dart
            app_tab_bar.dart
            app_top_bar.dart
            code_input.dart
            feature_icon.dart
            num_pad.dart
            pin_pad.dart
            success_check.dart
            transaction_row.dart
```

### 2. DavPhone Service (`service_store`)
```text
lib
|   firebase_options.dart
|   main.dart
|   
+---core
|   +---constants
|   |       api_constants.dart
|   |       app_color.dart
|   |       app_strings.dart
|   +---providers
|   |       theme_provider.dart
|   +---routes
|   |       app_router.dart
|   +---services
|   |       deeplink_handler.dart
|   |       dio_client.dart
|   |       secure_storage.dart
|   \---theme
|           app_theme.dart
\---features
    +---auth
    |   +---data
    |   |   +---models
    |   |   |       auth_response_model.dart
    |   |   \---repositories
    |   |           auth_repository_impl.dart
    |   +---domain
    |   |   \---repositories
    |   |           auth_repository.dart
    |   \---presentation
    |       +---pages
    |       |       login_page.dart
    |       |       register_page.dart
    |       |       verify_email_page.dart
    |       +---providers
    |       |       auth_provider.dart
    |       \---widgets
    |               auth_header.dart
    |               custom_button.dart
    |               custom_text_field.dart
    |               divider_with_text.dart
    |               google_sign_in_button.dart
    |               loading_overlay.dart
    +---cart
    |   +---data
    |   |   \---models
    |   |           cart_model.dart
    |   \---presentation
    |       +---pages
    |       |       cart.dart
    |       \---providers
    |               cart_provider.dart
    +---checkout
    |   \---pages
    |           checkout.dart
    +---dashboard
    |   +---data
    |   |   +---models
    |   |   |       product_model.dart
    |   |   \---repositories
    |   |           product_repository_impl.dart
    |   +---domain
    |   |   \---repositories
    |   |           product_repository.dart
    |   \---presentation
    |       +---pages
    |       |       dashboard_page.dart
    |       |       product_detail_page.dart
    |       |       splash_page.dart
    |       \---providers
    |               product_provider.dart
    +---orders
    |   +---data
    |   |   \---models
    |   |           order_model.dart
    |   \---presentation
    |       +---pages
    |       |       orders_page.dart
    |       \---providers
    |               order_provider.dart
    \---profile
        \---presentation
            \---pages
                    profile_page.dart
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