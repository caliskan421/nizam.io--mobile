import '../../core/preferences/app_preferences.dart';
import '../../core/storage/shared_preference_store.dart';

/// Keep raw preference storage inside DI; bootstrap receives the typed facade.
AppPreferences createAppPreferences() =>
    AppPreferences(SharedPreferenceStore());
