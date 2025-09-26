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
    private var networkCallback: ConnectivityManager.NetworkCallback? = null
    private var connectivityManager: ConnectivityManager? = null
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
    }

    private fun bindToCurrentWifi(): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val request = NetworkRequest.Builder()
                    .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                    .build()
                networkCallback = object : ConnectivityManager.NetworkCallback() {
                    override fun onAvailable(network: Network) {
                        try {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                connectivityManager?.bindProcessToNetwork(network)
                            } else {
                                @Suppress("DEPRECATION")
                                ConnectivityManager.setProcessDefaultNetwork(network)
                            }
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                    override fun onLost(network: Network) {
                        super.onLost(network)
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            connectivityManager?.bindProcessToNetwork(null)
                        }
                    }
                }
                connectivityManager?.requestNetwork(request, networkCallback!!)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    private fun disconnectWifi(): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                connectivityManager?.bindProcessToNetwork(null)
            } else {
                @Suppress("DEPRECATION")
                ConnectivityManager.setProcessDefaultNetwork(null)
            }
            networkCallback?.let { callback ->
                connectivityManager?.unregisterNetworkCallback(callback)
                networkCallback = null
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "wifi_channel")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "bindNetwork" -> {
                        val success = bindToCurrentWifi()
                        result.success(success)
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    override fun onDestroy() {
        disconnectWifi()
        super.onDestroy()
    }
}