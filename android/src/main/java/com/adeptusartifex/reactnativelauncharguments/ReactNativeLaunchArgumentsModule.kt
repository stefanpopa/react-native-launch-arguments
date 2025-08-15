package com.adeptusartifex.reactnativelauncharguments

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.annotations.ReactModule

@ReactModule(name = ReactNativeLaunchArgumentsModule.NAME)
class ReactNativeLaunchArgumentsModule(reactContext: ReactApplicationContext) :
  NativeReactNativeLaunchArgumentsSpec(reactContext) {

  override fun getName(): String = NAME

  override fun getTypedExportedConstants(): Map<String, Map<String, Any?>> {
    if (!isAppKilled()) {
      waitForActivity()
    }
    return hashMapOf("VALUE" to parseIntentExtras())
  }

  private fun waitForActivity() {
    var tries = 0
    while (tries < ACTIVITY_WAIT_TRIES && !isActivityReady()) {
      sleep(ACTIVITY_WAIT_INTERVAL)
      tries++
    }
  }

  private fun parseIntentExtras(): Map<String, Any?> {
    val activity = currentActivity ?: return mapOf()
    val intent = activity.intent ?: return mapOf()

    // Combine Detox and ADB extras; ADB extras override Detox on key collisions
    return parseDetoxExtras(intent) + parseADBArgsExtras(intent)
  }

  private fun parseDetoxExtras(intent: Intent): Map<String, Any?> {
    return intent.getBundleExtra(DETOX_LAUNCH_ARGS_KEY)?.let { bundle ->
      bundle.keySet()
        .associateWith { key ->
          bundle.getString(key) as Any?
        }
    } ?: emptyMap()
  }

  private fun parseADBArgsExtras(intent: Intent): Map<String, Any?> {
    val extras = intent.extras ?: return emptyMap()
    return extras.keySet()
      .asSequence()
      .filterNot { it == DETOX_LAUNCH_ARGS_KEY || it == NFC_MESSAGES_EXTRA }
      .associateWith { key ->
        when (val v = extras.get(key)) {
          is Int, is Double, is Boolean, is String -> v
          else -> extras.getString(key)
        }
      }
  }

  private fun isActivityReady(): Boolean = reactApplicationContext.hasCurrentActivity()

  private fun sleep(millis: Long) {
    try {
      Thread.sleep(millis)
    } catch (exception: InterruptedException) {
      Thread.currentThread().interrupt()
    }
  }

  private fun isAppKilled(): Boolean {
    val activityManager =
      reactApplicationContext.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
    val appProcesses = activityManager.runningAppProcesses ?: return true
    val packageName = reactApplicationContext.packageName

    for (appProcess in appProcesses) {
      if (appProcess.processName == packageName) {
        return false // App process found; app is not killed
      }
    }
    return true // App process not found; app is killed
  }

  companion object {
    const val NAME = "ReactNativeLaunchArguments"
    const val ACTIVITY_WAIT_INTERVAL = 100L
    const val ACTIVITY_WAIT_TRIES = 200
    const val DETOX_LAUNCH_ARGS_KEY = "launchArgs"
    const val NFC_MESSAGES_EXTRA = "android.nfc.extra.NDEF_MESSAGES"
  }
}
