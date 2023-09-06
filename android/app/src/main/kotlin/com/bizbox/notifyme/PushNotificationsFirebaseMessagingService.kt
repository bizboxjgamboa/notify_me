package com.bizbox.notifyme

import android.os.Handler
import android.os.Looper
import com.bizbox.notifyme.services.NotificationActionService
import com.bizbox.notifyme.services.NotificationRegistrationService
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class PushNotificationsFirebaseMessagingService : FirebaseMessagingService() {

    companion object {
        var token : String? = null
        var notificationRegistrationService : NotificationRegistrationService? = null
        var notificationActionService : NotificationActionService? = null
    }

    override fun onNewToken(token: String) {
        Companion.token = token

        Handler(Looper.getMainLooper()).post {
            notificationRegistrationService?.refreshRegistration()
        }
    }


    override fun onMessageReceived(message: RemoteMessage) {
        message.data.let {
            Handler(Looper.getMainLooper()).post {
                notificationActionService?.triggerAction(it.getOrDefault("action", null))
            }
        }
    }
}