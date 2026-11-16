// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_activity.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kişinin işlem geçmişi (`actor_account_id` süzgeci; kullanıcı ayrıntısı). Yalnız şirket
/// yöneticisi okur; diğerlerinde [ActivityUnavailable].

@ProviderFor(personActivity)
final personActivityProvider = PersonActivityFamily._();

/// Kişinin işlem geçmişi (`actor_account_id` süzgeci; kullanıcı ayrıntısı). Yalnız şirket
/// yöneticisi okur; diğerlerinde [ActivityUnavailable].

final class PersonActivityProvider
    extends
        $FunctionalProvider<
          AsyncValue<ActivityLog>,
          ActivityLog,
          FutureOr<ActivityLog>
        >
    with $FutureModifier<ActivityLog>, $FutureProvider<ActivityLog> {
  /// Kişinin işlem geçmişi (`actor_account_id` süzgeci; kullanıcı ayrıntısı). Yalnız şirket
  /// yöneticisi okur; diğerlerinde [ActivityUnavailable].
  PersonActivityProvider._({
    required PersonActivityFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'personActivityProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personActivityHash();

  @override
  String toString() {
    return r'personActivityProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ActivityLog> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ActivityLog> create(Ref ref) {
    final argument = this.argument as String;
    return personActivity(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonActivityProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personActivityHash() => r'13b6ee833fa7bbcdc64ee450c8f43a42e5887871';

/// Kişinin işlem geçmişi (`actor_account_id` süzgeci; kullanıcı ayrıntısı). Yalnız şirket
/// yöneticisi okur; diğerlerinde [ActivityUnavailable].

final class PersonActivityFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ActivityLog>, String> {
  PersonActivityFamily._()
    : super(
        retry: null,
        name: r'personActivityProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kişinin işlem geçmişi (`actor_account_id` süzgeci; kullanıcı ayrıntısı). Yalnız şirket
  /// yöneticisi okur; diğerlerinde [ActivityUnavailable].

  PersonActivityProvider call(String accountId) =>
      PersonActivityProvider._(argument: accountId, from: this);

  @override
  String toString() => r'personActivityProvider';
}
