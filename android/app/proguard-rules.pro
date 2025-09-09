## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**
-keep class io.flutter.embedding.android.FlutterActivity { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.plugin.platform.PlatformPlugin { *; }

# Google Mobile Ads 관련 클래스 보존
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }
-dontwarn com.google.android.gms.**

# Optional: Firebase Crashlytics가 필요한 경우
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Optional: Gson 관련 (flutter_local_notifications 대응)
-keep class com.google.gson.** { *; }
-keepattributes *Annotation*
-keep class android.app.NotificationManager { *; }
-keep class android.app.AlarmManager { *; }

# Keep flutter_local_notifications native bindings
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Needed for workmanager/alarmmanager-style background tasks
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**

# Flutter 앱 진입점 보존
-keepclassmembers class * {
   public static void main(java.lang.String[]);
}

# Needed if your notification taps open the app via intent
-keepclassmembers class * {
    public void onReceive(android.content.Context, android.content.Intent);
}

-keep class com.today25.kuanimalm.ku_animal_m.MainActivity { *; }  