package com.adeptusartifex.reactnativelauncharguments

import com.facebook.react.BaseReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.module.model.ReactModuleInfo
import com.facebook.react.module.model.ReactModuleInfoProvider
import java.util.HashMap

class ReactNativeLaunchArgumentsPackage : BaseReactPackage() {
  override fun getModule(name: String, reactContext: ReactApplicationContext): NativeModule? {
    return if (name == ReactNativeLaunchArgumentsModule.NAME) {
      ReactNativeLaunchArgumentsModule(reactContext)
    } else {
      null
    }
  }

  override fun getReactModuleInfoProvider(): ReactModuleInfoProvider {
    return ReactModuleInfoProvider {
      val moduleInfos: MutableMap<String, ReactModuleInfo> = HashMap()
      moduleInfos[ReactNativeLaunchArgumentsModule.NAME] = ReactModuleInfo(
        name = ReactNativeLaunchArgumentsModule.NAME,
        className = ReactNativeLaunchArgumentsModule.NAME,
        canOverrideExistingModule = false,  // canOverrideExistingModule
        needsEagerInit = false,  // needsEagerInit
        isCxxModule = false,  // isCxxModule
        isTurboModule = true // isTurboModule
      )
      moduleInfos
    }
  }
}
