package com.pragma.music_station

import android.app.PendingIntent
import android.app.PictureInPictureParams
import android.app.RemoteAction
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Rect
import android.graphics.drawable.Icon
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.util.Rational
import androidx.annotation.RequiresApi
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {


    private val isSupportPIP by lazy {
        packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
    }


    private val TAG: String = MainActivity::class.java.simpleName
    private val CHANNEL_NAME: String = "pragma_app/music_player_channel"
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)

        //Receive data from flutter
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                MusicPlayerMethodChannelMethods.prepareForReproduceInBackground.name -> {
                    handleReproduceInBackgroundCall(arguments = call.arguments.toString())
                }
                MusicPlayerMethodChannelMethods.prepareForReproduceInForeground.name -> {
                    handleReproduceInForegroundCall()
                }
                else -> {
                    result.notImplemented()
                    Log.i(TAG, "NO IMPLEMENTADO")
                }
            }
        }
    }

    override fun onResume() {
        super.onResume()
        //Send data to flutter
        channel.invokeMethod("pause", 0)
    }

    private fun handleReproduceInBackgroundCall(arguments: String?) {
        //Start mode PIP
        if (isSupportPIP) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                Log.e(TAG, "BACKGROUND handleReproduceInBackgroundCall ")
                //getPIPParams()?.let { params -> enterPictureInPictureMode(params) }
            }
        }


        val song = Gson().fromJson(arguments, PlayListSong::class.java)
        Log.i(TAG, "BACKGROUND handleReproduceInBackgroundCall ${song.toString()}")
    }


    private fun handleReproduceInForegroundCall() {
        Log.i(TAG, "FOREGROUND handleReproduceInForegroundCall")
    }


    @RequiresApi(Build.VERSION_CODES.O)
    private fun getPIPParams(): PictureInPictureParams? {
        var visibleRect = Rect()
        val params = PictureInPictureParams.Builder()
            .setSourceRectHint(visibleRect)
            .setAspectRatio(Rational(16, 9))
            .setActions(
                listOf(
                    RemoteAction(
                        Icon.createWithResource(
                            applicationContext,
                            android.R.drawable.ic_media_pause
                        ),
                        "Pause",
                        "Pause",
                        PendingIntent.getBroadcast(
                            applicationContext,
                            0,
                            Intent(applicationContext, MyReceiver::class.java),
                            PendingIntent.FLAG_IMMUTABLE
                        )
                    )
                )
            )
            .build()
        setPictureInPictureParams(params)
        return params
    }

    class MyReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent?) {
            println("Click on PIP")
        }
    }


    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        if (!isSupportPIP) {
            return
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            getPIPParams()?.let { params -> enterPictureInPictureMode(params) }
        }
    }


}
