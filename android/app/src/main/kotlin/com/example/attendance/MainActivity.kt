package com.ijessi.attendance

import io.flutter.embedding.android.FlutterFragmentActivity
import android.os.Bundle
import android.net.ConnectivityManager
import android.net.Network
import android.os.Build
import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.net.NetworkRequest
import android.net.NetworkCapabilities

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    private fun bindToCurrentWifi() {
        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val request = NetworkRequest.Builder()
                .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                .build()

            connectivityManager.requestNetwork(request, object : ConnectivityManager.NetworkCallback() {
                override fun onAvailable(network: Network) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        connectivityManager.bindProcessToNetwork(network)
                    } else {
                        ConnectivityManager.setProcessDefaultNetwork(network)
                    }
                }
            })
        }
    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "wifi_channel")
            .setMethodCallHandler { call, result ->
                if (call.method == "bindNetwork") {
                    bindToCurrentWifi()
                    result.success(true)
                }
            }
    }
}