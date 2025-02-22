package com.kcoding.get_done

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService


class Application : FlutterApplication(),PluginRegistry.PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this)

    }
    override fun registerWith(registry: PluginRegistry?) {
       FirebaseCloudMessagingPlugin.registerWith(registry!!)
    }

}