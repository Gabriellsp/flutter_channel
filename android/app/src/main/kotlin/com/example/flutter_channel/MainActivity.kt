package com.example.flutter_channel

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutter.seventh/network_connection"
    private lateinit var channel: MethodChannel

    @RequiresApi(Build.VERSION_CODES.M)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler {
                call, result ->
            if (call.method == "hasInternet"){
                var hasInternet = isInternetAvailable(this)
                result.success(hasInternet)
            } else {
                result.notImplemented()
            }

        }
    }
    @RequiresApi(Build.VERSION_CODES.M)
    fun isInternetAvailable(context: Context): Boolean {
        val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val network = connectivityManager.activeNetwork
        val networkCapabilities = connectivityManager.getNetworkCapabilities(network)

        return networkCapabilities?.hasTransport(NetworkCapabilities.TRANSPORT_WIFI) == true || networkCapabilities?.hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) == true
    }
}
