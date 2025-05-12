// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dual_momentum_international_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dualMomentumInternationalFamilyHash() =>
    r'1065c26e0fe5950bd737a26e652f678cf5ac2a93';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$DualMomentumInternationalFamily
    extends BuildlessAutoDisposeAsyncNotifier<DualMomentumInternationalModel> {
  late final BacktestParams params;

  FutureOr<DualMomentumInternationalModel> build(
    BacktestParams params,
  );
}

/// See also [DualMomentumInternationalFamily].
@ProviderFor(DualMomentumInternationalFamily)
const dualMomentumInternationalFamilyProvider =
    DualMomentumInternationalFamilyFamily();

/// See also [DualMomentumInternationalFamily].
class DualMomentumInternationalFamilyFamily
    extends Family<AsyncValue<DualMomentumInternationalModel>> {
  /// See also [DualMomentumInternationalFamily].
  const DualMomentumInternationalFamilyFamily();

  /// See also [DualMomentumInternationalFamily].
  DualMomentumInternationalFamilyProvider call(
    BacktestParams params,
  ) {
    return DualMomentumInternationalFamilyProvider(
      params,
    );
  }

  @override
  DualMomentumInternationalFamilyProvider getProviderOverride(
    covariant DualMomentumInternationalFamilyProvider provider,
  ) {
    return call(
      provider.params,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dualMomentumInternationalFamilyProvider';
}

/// See also [DualMomentumInternationalFamily].
class DualMomentumInternationalFamilyProvider
    extends AutoDisposeAsyncNotifierProviderImpl<
        DualMomentumInternationalFamily, DualMomentumInternationalModel> {
  /// See also [DualMomentumInternationalFamily].
  DualMomentumInternationalFamilyProvider(
    BacktestParams params,
  ) : this._internal(
          () => DualMomentumInternationalFamily()..params = params,
          from: dualMomentumInternationalFamilyProvider,
          name: r'dualMomentumInternationalFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dualMomentumInternationalFamilyHash,
          dependencies: DualMomentumInternationalFamilyFamily._dependencies,
          allTransitiveDependencies:
              DualMomentumInternationalFamilyFamily._allTransitiveDependencies,
          params: params,
        );

  DualMomentumInternationalFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.params,
  }) : super.internal();

  final BacktestParams params;

  @override
  FutureOr<DualMomentumInternationalModel> runNotifierBuild(
    covariant DualMomentumInternationalFamily notifier,
  ) {
    return notifier.build(
      params,
    );
  }

  @override
  Override overrideWith(DualMomentumInternationalFamily Function() create) {
    return ProviderOverride(
      origin: this,
      override: DualMomentumInternationalFamilyProvider._internal(
        () => create()..params = params,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        params: params,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DualMomentumInternationalFamily,
      DualMomentumInternationalModel> createElement() {
    return _DualMomentumInternationalFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DualMomentumInternationalFamilyProvider &&
        other.params == params;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, params.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DualMomentumInternationalFamilyRef
    on AutoDisposeAsyncNotifierProviderRef<DualMomentumInternationalModel> {
  /// The parameter `params` of this provider.
  BacktestParams get params;
}

class _DualMomentumInternationalFamilyProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<
        DualMomentumInternationalFamily, DualMomentumInternationalModel>
    with DualMomentumInternationalFamilyRef {
  _DualMomentumInternationalFamilyProviderElement(super.provider);

  @override
  BacktestParams get params =>
      (origin as DualMomentumInternationalFamilyProvider).params;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
