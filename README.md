# KG to Kyattha Calculator

Flutter Android mobile calculator with **custom 1 KG = 63 Kyattha** business conversion.

## Run

1. Install Flutter SDK and Android build tools.
2. In terminal, run:

```bash
flutter create --platforms android --project-name kg_kyattha_calculator .
flutter pub get
flutter run
```

## Build APK

```bash
flutter build apk --release
```

APK output: `build/app/outputs/flutter-apk/app-release.apk`.

## Formula

`total_kyattha = kg * 63`

`target_price = (total_amount / total_kyattha) * target_kyattha`

Amount is the total price of the weight entered, not necessarily the price of exactly 1 kg.

This uses a custom business conversion rate rather than the standard physical weight conversion.
