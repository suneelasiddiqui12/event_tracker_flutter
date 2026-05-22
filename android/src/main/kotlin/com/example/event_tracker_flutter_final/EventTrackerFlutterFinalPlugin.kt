package com.example.event_tracker_flutter_final

import android.content.Context
import android.util.Log
import com.example.eventtrackersdk.EventTracker
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class EventTrackerFlutterFinalPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        channel = MethodChannel(
            binding.binaryMessenger,
            "event_tracker_flutter"
        )

        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {

        when (call.method) {

            "initialize" ->
                handleInitialize(call, result)

            "track" ->
                handleTrack(call, result)

            "identify" ->
                handleIdentify(call, result)

            "page" ->
                handlePage(call, result)

            "flush" ->
                handleFlush(result)

            "identifyAnonymous" ->
                handleIdentifyAnonymous(call, result)

            else ->
                result.notImplemented()
        }
    }

    private fun handleInitialize(
        call: MethodCall,
        result: Result
    ) {

        val eventKey =
            call.argument<String>("eventKey")

        val debug =
            call.argument<Boolean>("debug") ?: false

        if (eventKey.isNullOrBlank()) {

            result.error(
                "INVALID_ARGUMENT",
                "eventKey must not be null or empty",
                null
            )

            return
        }

        try {

            EventTracker.initialize(
                context = context,
                eventKey = eventKey,
                debug = debug
            )

            Log.d(TAG, "SDK initialized")

            result.success(null)

        } catch (e: Exception) {

            Log.e(TAG, "Initialization failed: ${e.message}")

            result.error(
                "INIT_ERROR",
                e.message,
                null
            )
        }
    }

    private fun handleTrack(
        call: MethodCall,
        result: Result
    ) {

        val eventName =
            call.argument<String>("eventName")

        val properties =
            extractStringMap(
                call.argument<Map<String, Any?>>("properties")
            )

        if (eventName.isNullOrBlank()) {

            result.error(
                "INVALID_ARGUMENT",
                "eventName must not be null or empty",
                null
            )

            return
        }

        try {

            EventTracker.getInstance()
                .track(eventName, properties)

            Log.d(TAG, "Track success: $eventName")

            result.success(null)

        } catch (e: Exception) {

            Log.e(TAG, "Track failed: ${e.message}")

            result.error(
                "TRACK_ERROR",
                e.message,
                null
            )
        }
    }

    private fun handleIdentify(
        call: MethodCall,
        result: Result
    ) {

        val contactNumber =
            call.argument<String>("contactNumber")

        val traits =
            extractStringMap(
                call.argument<Map<String, Any?>>("traits")
            )

        if (contactNumber.isNullOrBlank()) {

            result.error(
                "INVALID_ARGUMENT",
                "contactNumber must not be null or empty",
                null
            )

            return
        }

        try {

            EventTracker.getInstance()
                .identify(contactNumber, traits)

            Log.d(TAG, "Identify success")

            result.success(null)

        } catch (e: Exception) {

            Log.e(TAG, "Identify failed: ${e.message}")

            result.error(
                "IDENTIFY_ERROR",
                e.message,
                null
            )
        }
    }

    private fun handlePage(
        call: MethodCall,
        result: Result
    ) {

        val pageName =
            call.argument<String>("pageName")

        val properties =
            extractStringMap(
                call.argument<Map<String, Any?>>("properties")
            )

        if (pageName.isNullOrBlank()) {

            result.error(
                "INVALID_ARGUMENT",
                "pageName must not be null or empty",
                null
            )

            return
        }

        try {

            EventTracker.getInstance()
                .page(pageName, properties)

            Log.d(TAG, "Page success: $pageName")

            result.success(null)

        } catch (e: Exception) {

            Log.e(TAG, "Page failed: ${e.message}")

            result.error(
                "PAGE_ERROR",
                e.message,
                null
            )
        }
    }

    private fun handleFlush(
        result: Result
    ) {

        try {

            EventTracker.getInstance()
                .flush()

            Log.d(TAG, "Flush success")

            result.success(null)

        } catch (e: Exception) {

            Log.e(TAG, "Flush failed: ${e.message}")

            result.error(
                "FLUSH_ERROR",
                e.message,
                null
            )
        }
    }

    private fun handleIdentifyAnonymous(
        call: MethodCall,
        result: Result
    ) {

        val sessionId =
            call.argument<String>("sessionId")

        val traits =
            extractStringMap(
                call.argument<Map<String, Any?>>("traits")
            )

        if (sessionId.isNullOrBlank()) {

            result.error(
                "INVALID_ARGUMENT",
                "sessionId must not be null or empty",
                null
            )

            return
        }

        try {

            EventTracker.getInstance().track(
                "guest_session_started",
                traits + mapOf(
                    "user_type" to "guest",
                    "session_id" to sessionId,
                    "contact_no" to "",
                    "is_anonymous" to "true"
                )
            )

            Log.d(TAG, "Anonymous session tracked")

            result.success(null)

        } catch (e: Exception) {

            Log.e(TAG, "Anonymous tracking failed: ${e.message}")

            result.error(
                "ANONYMOUS_SESSION_ERROR",
                e.message,
                null
            )
        }
    }

    private fun extractStringMap(
        map: Map<String, Any?>?
    ): Map<String, String> {

        return map?.mapValues {
            it.value?.toString() ?: ""
        } ?: emptyMap()
    }

    companion object {
        private const val TAG = "EventTrackerPlugin"
    }
}