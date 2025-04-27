package com.abusalh.ironfit

import android.app.Application
import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        FirebaseApp.initializeApp(this)
        
        // Configure App Check with longer token expiration time
        val debugFactory = DebugAppCheckProviderFactory.getInstance()
        val appCheck = FirebaseAppCheck.getInstance()
        appCheck.setTokenAutoRefreshEnabled(false)  // Disable auto-refresh to prevent excessive calls
        appCheck.installAppCheckProviderFactory(debugFactory)
    }
} 