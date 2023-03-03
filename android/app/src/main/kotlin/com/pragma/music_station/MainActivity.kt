package com.pragma.music_station

import android.app.PendingIntent
import android.app.PictureInPictureParams
import android.app.RemoteAction
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.graphics.Rect
import android.graphics.drawable.Icon
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.util.Rational
import androidx.annotation.DrawableRes
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Type


private const val CHANNEL_NAME: String = "pragma_app/music_player_channel"

private const val ACTION_STOPWATCH_CONTROL = "stopwatch_control"
private const val EXTRA_CONTROL_TYPE = "control_type"
private const val PLAY = "Play"
private const val PAUSE = "Pause"

private const val CONTROL_PLAY = 1
private const val CONTROL_PAUSE = 2


class MainActivity : FlutterActivity() {

    private val TAG: String = MainActivity::class.java.simpleName


    private val isSupportPIP by lazy {
        packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
    }

    private lateinit var channel: MethodChannel


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Registra el broadcast listener de eventos desde los íconos de acción en el modo PIP.
        registerReceiver(broadcastReceiver, IntentFilter(ACTION_STOPWATCH_CONTROL))
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)

        //Receive data from flutter
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                MusicPlayerMethodChannelMethods.prepareForReproduceInBackground.name -> {
                    handleReproduceInBackgroundCall(arguments = call.arguments)
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



    private fun handleReproduceInBackgroundCall(arguments: Any?) {
        //Start mode PIP
        if (isSupportPIP) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                onUserLeaveHint()
            }
        }

        //val song = Gson().fromJson(arguments, PlayListSong::class.java)
        //Log.i(TAG, "BACKGROUND handleReproduceInBackgroundCall ${song.toString()}")
    }

    private fun handleReproduceInForegroundCall() {
        Log.i(TAG, "FOREGROUND handleReproduceInForegroundCall")
    }




    /************ METHODS PIP  **************/
    private fun getPIPParams(): PictureInPictureParams? {
        var visibleRect = Rect()
        val params = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            PictureInPictureParams.Builder()
                .setSourceRectHint(visibleRect)
                .setAspectRatio(Rational(16, 9))
                .setActions(
                    listOf(
                        createRemoteAction(
                            android.R.drawable.ic_media_play,
                            PLAY,
                            CONTROL_PLAY
                        ),
                        createRemoteAction(
                            android.R.drawable.ic_media_pause,
                            PAUSE,
                            CONTROL_PAUSE
                        )
                    )
                ).build()
        } else {
            TODO("VERSION.SDK_INT < O")
        }
        setPictureInPictureParams(params)
        return params
    }


    private fun createRemoteAction(
        @DrawableRes iconResId: Int,
        title: String,
        requestCode: Int
    ): RemoteAction {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            RemoteAction(
                Icon.createWithResource(applicationContext, iconResId),
                title,
                title,
                PendingIntent.getBroadcast(
                    applicationContext,
                    requestCode,
                    Intent(ACTION_STOPWATCH_CONTROL).putExtra(EXTRA_CONTROL_TYPE, requestCode),
                    PendingIntent.FLAG_IMMUTABLE
                )
            )
        } else {
            TODO("VERSION.SDK_INT < O")
        }
    }

    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent == null || intent.action != ACTION_STOPWATCH_CONTROL) {
                return
            }
            when (intent.getIntExtra(EXTRA_CONTROL_TYPE, 0)) {
                CONTROL_PAUSE -> {
                    //Send data to flutter
                    channel.invokeMethod("pause", 0)
                    Log.e(TAG,"SE PUSO PAUSA")
                }
                CONTROL_PLAY -> {
                    //Send data to flutter
                    channel.invokeMethod("play", 0)
                    Log.e(TAG,"SE PUSO PLAY")
                }
                else -> {  Log.e(TAG,"NO DEFINIDO") }
            }
        }
    }





    /*PERMITE DETECTAR CUANDO EL USUARIO PRESIONA HOME*/
    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        Log.e(TAG,"onUserLeaveHint")
        if (!isSupportPIP) {
            return
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            getPIPParams()?.let { params -> enterPictureInPictureMode(params) }
        }
    }


}
