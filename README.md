# reChat – iOS (.ipa)

`www/index.html` = senin kodun + iOS yamaları. Capacitor (WKWebView) ile sarılıp .ipa'ya dönüşür.

## Yol A – Mac yok: GitHub Actions (en kolay)
1. Bu klasörü yeni bir GitHub reposuna yükle (`.github` klasörü dahil).
2. Actions → "reChat iOS .ipa" → Run workflow.
3. ~10 dk sonra Artifacts → `reChat-ipa` içinden `reChat.ipa` indir.
4. İmzasız .ipa'yı **Sideloadly / AltStore / TrollStore** ile kendi Apple ID'nle telefona yükle
   (ücretsiz hesapta 7 gün, 99$ geliştirici hesabında 1 yıl; App Store/TestFlight için Xcode'da imzalamak gerekir).

## Yol B – Mac'te
```
npm install
npx cap add ios
npx capacitor-assets generate --ios
./ios-patch/patch-ios.sh
npx cap sync ios
npx cap open ios
```
Xcode: App hedefi → Signing & Capabilities → Team seç → Product ▸ Archive ▸ Distribute.

## Yapılan iOS yamaları
- Viewport zoom kilidi, input odaklanınca zoom olmaması (16px min.), safe-area (çentik/home bar)
- `-webkit-backdrop-filter` (cam temalar iOS 16/17'de çalışsın)
- Videolar `playsinline`; ses kilidi `touchend/click` ile açılıyor (iOS kuralı)
- "Uygulamadan çık" butonu iOS'ta gizlendi (iOS uygulamayı kapatamaz; "Çıkış yap" duruyor)
- Mikrofon, kamera, galeri, konum izin metinleri + arka planda ses (`UIBackgroundModes: audio`)
- Min. iOS 16.4 (kodda `color-mix()` var, 16.2 altında temalar bozulur)
- İkon/splash logodan otomatik üretildi (`resources/`) – kendi ikonunla `icon.png` (1024×1024) değiştir.

## Bilinen sınırlar
- iOS arka plana atılan uygulamayı askıya alır: WebRTC bağlantısı/ntfy dinleme kopar, bildirim gelmez
  (uygulama açılınca yeniden bağlanır). Sesli oda sırasında ses modu bunu kısmen korur. Gerçek push için APNs + sunucu gerekir.
- `webkitSpeechRecognition` WKWebView'da yok; kodundaki MediaRecorder yedeği kullanılır.
- Web `Notification` API yok → bildirim için `@capacitor/local-notifications` eklenebilir.

## v2 değişiklikleri
- Mikrofon gerektiğinde açıklama penceresi + iOS izin penceresi; izin kapalıysa Ayarlar yönlendirmesi
- Giriş alanlarının köşe yuvarlaklığı hatası düzeltildi
- Klavye için @capacitor/keyboard eklendi
- Workflow dosyası build.yml olarak yeniden adlandırıldı
