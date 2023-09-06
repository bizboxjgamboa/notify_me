package com.bizbox.notifyme

import android.content.Intent
import android.os.Bundle
import com.google.android.gms.tasks.OnCompleteListener
import com.bizbox.notifyme.services.DeviceInstallationService
import com.bizbox.notifyme.services.NotificationActionService
import com.bizbox.notifyme.services.NotificationRegistrationService
import io.flutter.embedding.android.FlutterActivity
import com.google.firebase.messaging.FirebaseMessaging


class MainActivity: FlutterActivity() {
    private lateinit var deviceInstallationService: DeviceInstallationService

    private fun processNotificationActions(intent: Intent, launchAction: Boolean = false) {
        if (intent.hasExtra("action")) {
            val action = intent.getStringExtra("action")

            if (action != null) {
                if (launchAction) {
                    PushNotificationsFirebaseMessagingService.notificationActionService?.launchAction = action
                }
                else {
                    PushNotificationsFirebaseMessagingService.notificationActionService?.triggerAction(action)
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        processNotificationActions(intent)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.let {
            deviceInstallationService = DeviceInstallationService(context, it)
            PushNotificationsFirebaseMessagingService.notificationActionService = NotificationActionService(it)
            PushNotificationsFirebaseMessagingService.notificationRegistrationService = NotificationRegistrationService(it)

            if(deviceInstallationService.playServicesAvailable) {
                FirebaseMessaging.getInstance().token
                        .addOnCompleteListener(OnCompleteListener { task ->
                            if (!task.isSuccessful)
                                return@OnCompleteListener

                            PushNotificationsFirebaseMessagingService.token = task.result
                            PushNotificationsFirebaseMessagingService.notificationRegistrationService?.refreshRegistration()
                        })
            }
            processNotificationActions(this.intent, true)
        }
    }
}
