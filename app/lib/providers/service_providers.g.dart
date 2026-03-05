// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 토큰 저장소 (싱글톤).

@ProviderFor(tokenStorage)
const tokenStorageProvider = TokenStorageProvider._();

/// 토큰 저장소 (싱글톤).

final class TokenStorageProvider
    extends $FunctionalProvider<TokenStorage, TokenStorage, TokenStorage>
    with $Provider<TokenStorage> {
  /// 토큰 저장소 (싱글톤).
  const TokenStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStorageHash();

  @$internal
  @override
  $ProviderElement<TokenStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStorage create(Ref ref) {
    return tokenStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStorage>(value),
    );
  }
}

String _$tokenStorageHash() => r'a42816fb1cf5af728e44ff5c48bfcaf5dc6b12aa';

/// API 클라이언트 (싱글톤).

@ProviderFor(apiClient)
const apiClientProvider = ApiClientProvider._();

/// API 클라이언트 (싱글톤).

final class ApiClientProvider
    extends $FunctionalProvider<ApiClient, ApiClient, ApiClient>
    with $Provider<ApiClient> {
  /// API 클라이언트 (싱글톤).
  const ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientHash();

  @$internal
  @override
  $ProviderElement<ApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiClient create(Ref ref) {
    return apiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiClient>(value),
    );
  }
}

String _$apiClientHash() => r'c320b273cd785c1628b430ac6a6160e9290914f4';

/// 인증 서비스.

@ProviderFor(authService)
const authServiceProvider = AuthServiceProvider._();

/// 인증 서비스.

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  /// 인증 서비스.
  const AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthService>(value),
    );
  }
}

String _$authServiceHash() => r'fb55beaf820dded9ab3b3ffe1f4cec7fcd94753a';

/// 상품 서비스.

@ProviderFor(productService)
const productServiceProvider = ProductServiceProvider._();

/// 상품 서비스.

final class ProductServiceProvider
    extends $FunctionalProvider<ProductService, ProductService, ProductService>
    with $Provider<ProductService> {
  /// 상품 서비스.
  const ProductServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productServiceHash();

  @$internal
  @override
  $ProviderElement<ProductService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ProductService create(Ref ref) {
    return productService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductService>(value),
    );
  }
}

String _$productServiceHash() => r'2a0c35f00e641aa3b689753752e8ecba5d0131b5';

/// 알림(Alert) 서비스.

@ProviderFor(alertService)
const alertServiceProvider = AlertServiceProvider._();

/// 알림(Alert) 서비스.

final class AlertServiceProvider
    extends $FunctionalProvider<AlertService, AlertService, AlertService>
    with $Provider<AlertService> {
  /// 알림(Alert) 서비스.
  const AlertServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertServiceHash();

  @$internal
  @override
  $ProviderElement<AlertService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AlertService create(Ref ref) {
    return alertService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlertService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlertService>(value),
    );
  }
}

String _$alertServiceHash() => r'4ce1b2f8588f1dab644395acbac7c3196b156a9c';

/// 알림(Notification) 서비스.

@ProviderFor(notificationService)
const notificationServiceProvider = NotificationServiceProvider._();

/// 알림(Notification) 서비스.

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          NotificationService,
          NotificationService,
          NotificationService
        >
    with $Provider<NotificationService> {
  /// 알림(Notification) 서비스.
  const NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationService>(value),
    );
  }
}

String _$notificationServiceHash() =>
    r'a159a1c413079b813281d43470b8a63c0ac13663';

/// 디바이스 서비스.

@ProviderFor(deviceService)
const deviceServiceProvider = DeviceServiceProvider._();

/// 디바이스 서비스.

final class DeviceServiceProvider
    extends $FunctionalProvider<DeviceService, DeviceService, DeviceService>
    with $Provider<DeviceService> {
  /// 디바이스 서비스.
  const DeviceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceService create(Ref ref) {
    return deviceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceService>(value),
    );
  }
}

String _$deviceServiceHash() => r'1a36cd05cd58d601e5adc9fd7380ca3d2ee21c00';

/// AI 예측 서비스.

@ProviderFor(predictionService)
const predictionServiceProvider = PredictionServiceProvider._();

/// AI 예측 서비스.

final class PredictionServiceProvider
    extends
        $FunctionalProvider<
          PredictionService,
          PredictionService,
          PredictionService
        >
    with $Provider<PredictionService> {
  /// AI 예측 서비스.
  const PredictionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'predictionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$predictionServiceHash();

  @$internal
  @override
  $ProviderElement<PredictionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PredictionService create(Ref ref) {
    return predictionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PredictionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PredictionService>(value),
    );
  }
}

String _$predictionServiceHash() => r'f24f4e69f0a25c221bb8b7df9e698da572f984f1';

/// 푸시 서비스.

@ProviderFor(pushService)
const pushServiceProvider = PushServiceProvider._();

/// 푸시 서비스.

final class PushServiceProvider
    extends $FunctionalProvider<PushService, PushService, PushService>
    with $Provider<PushService> {
  /// 푸시 서비스.
  const PushServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushServiceHash();

  @$internal
  @override
  $ProviderElement<PushService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PushService create(Ref ref) {
    return pushService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PushService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PushService>(value),
    );
  }
}

String _$pushServiceHash() => r'c9c951575b065e59d4d08bb4d0d88e6141ee65ef';
/// 보상 서비스.

@ProviderFor(rewardService)
const rewardServiceProvider = RewardServiceProvider._();

/// 보상 서비스.

final class RewardServiceProvider
    extends $FunctionalProvider<RewardService, RewardService, RewardService>
    with $Provider<RewardService> {
  /// 보상 서비스.
  const RewardServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardServiceHash();

  @$internal
  @override
  $ProviderElement<RewardService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RewardService create(Ref ref) {
    return rewardService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RewardService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RewardService>(value),
    );
  }
}

String _$rewardServiceHash() => r'reward_service_placeholder_hash_v1_2026';
