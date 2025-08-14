package com.example.trackierfluttersdk

import android.app.Application
import android.content.Context
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.NonNull
import com.trackier.sdk.*
import com.trackier.sdk.dynamic_link.AndroidParameters
import com.trackier.sdk.dynamic_link.DesktopParameters
import com.trackier.sdk.dynamic_link.DynamicLink
import com.trackier.sdk.dynamic_link.IosParameters
import com.trackier.sdk.dynamic_link.SocialMetaTagParameters
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.net.URI


/** TrackierfluttersdkPlugin */
class TrackierfluttersdkPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context : Context
    private lateinit var trackierSDKConfig: TrackierSDKConfig

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "trackierfluttersdk")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "setUserId" -> {
              setUserId(call, result);
            }
            
            "setUserEmail" -> {
              setUserEmail(call, result);
            }

            "setUserAdditonalDetail" -> {
               setUserAdditonalDetail(call, result);
            }

            "initializeSDK" -> {
                initializeSDK(call, result)
            }

            "trackierEvent" -> {
                trackEvent(call, result)
            }

            "getTrackierId" -> {
                getTrackierId(call, result)
            }

            "setUserName" -> {
                setUserName(call, result)
            }

            "setUserPhone" -> {
                setUserPhone(call, result)
            }

            "setDOB" -> {
                setDOB(call, result)
            }

            "setGender" -> {
                setGender(call, result)
            }

            "getAd" -> {
                getAd(call, result)
            }

            "getAdID" -> {
                getAdID(call, result)
            }

            "getAdSet" -> {
                getAdSet(call, result)
            }

            "getAdSetID" -> {
                getAdSetID(call, result)
            }

            "getCampaign" -> {
                getCampaign(call, result)
            }

            "getCampaignID" -> {
                getCampaignID(call, result)
            }

            "getChannel" -> {
                getChannel(call, result)
            }

            "getP1" -> {
                getP1(call, result)
            }

            "getP2" -> {
                getP2(call, result)
            }

            "getP3" -> {
                getP3(call, result)
            }

            "getP4" -> {
                getP4(call, result)
            }

            "getP5" -> {
                getP5(call, result)
            }

            "getClickId" -> {
                getClickId(call, result)
            }

            "getDlv" -> {
                getDlv(call, result)
            }

            "getPid" -> {
                getPid(call, result)
            }

            "getIsRetargeting" -> {
                getIsRetargeting(call, result)
            }

            "setPreinstallAttribution" -> {
                setPreinstallAttribution(call, result)
            }

            "setLocalRefTrack" -> {
                setLocalRefTrack(call, result)
            }

            "parseDeeplink" -> {
                parseDeeplink(call, result)
            }

            "fireInstall" -> {
                fireInstall()
            }

            "setIMEI" -> {
                setIMEI(call, result)
            }

            "setMacAddress" -> {
                setMacAddress(call, result)
            }

            "createDynamicLink" -> {
                val args = call.arguments as Map<String, Any>
                try {
                    val builder = DynamicLink.Builder()
                        .setTemplateId(args["templateId"] as String)
                        .setLink(Uri.parse(args["link"] as String))
                        .setDomainUriPrefix(args["domainUriPrefix"] as String)
                        .setDeepLinkValue(args["deepLinkValue"] as String)

                    (args["androidRedirect"] as? String)?.let {
                        builder.setAndroidParameters(
                            AndroidParameters.Builder()
                                .setRedirectLink(it)
                                .build()
                        )
                    }

                    (args["sdkParameters"] as? Map<*, *>)?.let { map ->
                        @Suppress("UNCHECKED_CAST")
                        builder.setSDKParameters(map as Map<String, String>)
                    }

                    (args["attributionParameters"] as? Map<*, *>)?.let { map ->
                        @Suppress("UNCHECKED_CAST")
                        val at = map as Map<String, String>
                        builder.setAttributionParameters(
                            channel = at["channel"] ?: "",
                            campaign = at["campaign"] ?: "",
                            mediaSource = at["media_source"] ?: ""
                        )
                    }

                    (args["iosRedirect"] as? String)?.let {
                        builder.setIosParameters(
                            IosParameters.Builder()
                                .setRedirectLink(it)
                                .build()
                        )
                    }

                    (args["desktopRedirect"] as? String)?.let {
                        builder.setDesktopParameters(
                            DesktopParameters.Builder()
                                .setRedirectLink(it)
                                .build()
                        )
                    }

                    (args["socialMeta"] as? Map<*, *>)?.let { map ->
                        @Suppress("UNCHECKED_CAST")
                        val sm = map as Map<String, String>
                        builder.setSocialMetaTagParameters(
                            SocialMetaTagParameters.Builder()
                                .setTitle(sm["title"] ?: "")
                                .setDescription(sm["description"] ?: "")
                                .setImageLink(sm["imageLink"] ?: "")
                                .build()
                        )
                    }

                    // Build and convert to config
                    val dynamicLink = builder.build()
                    val config = dynamicLink;

                    // Invoke Trackier SDK
                    TrackierSDK.createDynamicLink(
                        config,
                        onSuccess = { url -> result.success(url) },
                        onFailure = { err -> result.error("ERROR", err, null) }
                    )
                } catch (e: Exception) {
                    result.error("EXCEPTION", e.localizedMessage, null)
                }
            }

            "resolveDeeplinkUrl" -> {
                val url = call.argument<String>("url") ?: ""
                TrackierSDK.resolveDeeplinkUrl(
                    url,
                    onSuccess = { dlData ->
                        val resultMap = mapOf(
                            "url" to dlData.url,
                            "sdkParams" to dlData.sdkParams // assuming this is a Map<String, String>
                        )
                        result.success(resultMap)
                    },
                    onError = { error ->
                        result.error("RESOLVE_DEEPLINK_FAILED", error.localizedMessage, null)
                    }
                )
            }
            else -> result.notImplemented()
        }
    }

    private fun initializeSDK(call: MethodCall, result: Result) {
        var appToken = ""
        var environment = ""
        var secretId = ""
        var secretKey = ""
        var manualmode = false
        var disableOrganic = false
        var region = ""
        val configMap = call.arguments as MutableMap<*, *>

        if (configMap.containsKey("appToken")) {
            appToken = configMap.get("appToken") as String
        }

        if (configMap.containsKey("secretId")) {
            secretId = configMap.get("secretId") as String
        }

        if (configMap.containsKey("secretKey")) {
            secretKey = configMap.get("secretKey") as String
        }

        if (configMap.containsKey("environment")) {
            environment = configMap.get("environment") as String
        }

        if (configMap.containsKey("setManualMode")) {
            manualmode = configMap.get("setManualMode") as Boolean
        }

        if (configMap.containsKey("disableOrganicTracking")) {
            disableOrganic = configMap.get("disableOrganicTracking") as Boolean
        }
        trackierSDKConfig = TrackierSDKConfig(context, appToken, environment)
        val attribution = AttributionParams()
        val attributionParams = configMap["attributionParams"] as? Map<String, Any>
        if (attributionParams != null) {
            if (attributionParams.containsKey("partnerId")) {
                attribution.parterId = attributionParams["partnerId"] as String
            }
            if (attributionParams.containsKey("ad")) {
                attribution.ad = attributionParams["ad"] as String
            }
            if (attributionParams.containsKey("channel")) {
                attribution.channel = attributionParams["channel"] as String
            }
            if (attributionParams.containsKey("adId")) {
                attribution.adId = attributionParams["adId"] as String
            }
            if (attributionParams.containsKey("siteId")) {
                attribution.siteId = attributionParams["siteId"] as String
            }
        }
        trackierSDKConfig.setAttributionParams(attribution)
        if (configMap.containsKey("region")) {
            region = configMap.get("region") as String
            when (region) {
                "in" -> trackierSDKConfig.setRegion(TrackierSDKConfig.Region.IN)
                "global" -> trackierSDKConfig.setRegion(TrackierSDKConfig.Region.GLOBAL)
            }
        }

        trackierSDKConfig.setSDKVersion("1.6.74")
        trackierSDKConfig.setSDKType("flutter_sdk")
        trackierSDKConfig.setAppSecret(secretId, secretKey)
        trackierSDKConfig.setManualMode(manualmode)
        trackierSDKConfig.disableOrganicTracking(disableOrganic)

        if (configMap.containsKey("deeplinkCallback")) {
            val dartMethodName = configMap["deeplinkCallback"] as String?
            if (dartMethodName != null && channel != null) {
                    trackierSDKConfig.setDeepLinkListener(object : DeepLinkListener {
                        override fun onDeepLinking(result: DeepLink) {
                            // we have deepLink object and we can get any valve from Object
                            val uriParamsMap = HashMap<String, String>()
                            uriParamsMap["uri"] = result.getUrl()
                            Handler(Looper.getMainLooper()).post { channel.invokeMethod(dartMethodName, uriParamsMap) }
                        }
                    })
            }
        }
        TrackierSDK.initialize(trackierSDKConfig)
    }

    private fun setUserId(call: MethodCall, result: Result) {
        val userId = call.arguments as String
        TrackierSDK.setUserId(userId)
    }

    private fun setUserEmail(call: MethodCall, result: Result) {
        val userEmail = call.arguments as String
        TrackierSDK.setUserEmail(userEmail)
    }

    private fun setUserName(call: MethodCall, result: Result) {
        val userName = call.arguments as String
        TrackierSDK.setUserName(userName)
    }

    private fun setUserPhone(call: MethodCall, result: Result) {
        val userPhone = call.arguments as String
        TrackierSDK.setUserPhone(userPhone)
    }

    private fun setDOB(call: MethodCall, result: Result) {
        val dob = call.arguments as String
        TrackierSDK.setDOB(dob)
    }

    private fun setGender(call: MethodCall, result: Result) {
        val gender = call.arguments as String
        when (gender) {
            "Gender.Male" -> TrackierSDK.setGender(TrackierSDK.Gender.Male)
            "Gender.Female" -> TrackierSDK.setGender(TrackierSDK.Gender.Female)
            "Gender.Others" -> TrackierSDK.setGender(TrackierSDK.Gender.Others)
        }
    }

   private fun setUserAdditonalDetail(call: MethodCall, result: Result) {
       var userAddtionalDetail:MutableMap<String,Any> = mutableMapOf()
       val configMap = call.arguments as MutableMap<*, *>
        if (configMap.containsKey("userAddtionalDetail")) {
            userAddtionalDetail = configMap.get("userAddtionalDetail") as MutableMap<String,Any>
        }
       TrackierSDK.setUserAdditionalDetails(userAddtionalDetail)
    }


    private fun trackEvent(call: MethodCall, result: Result) {
        var eventId: String? = null
        var orderId: String? = null
        var currency: String? = null
        var discount: Double? = null
        var couponCode: String? = null
        var productId: String? = null
        var param1: String? = null
        var param2: String? = null
        var param3: String? = null
        var param4: String? = null
        var param5: String? = null
        var param6: String? = null
        var param7: String? = null
        var param8: String? = null
        var param9: String? = null
        var param10: String? = null
        var revenue: Double? = null
        var ev = mutableMapOf<String, Any>()
        lateinit var trackierEvent: TrackierEvent

        val configMap = call.arguments as MutableMap<*, *>

        if (configMap.containsKey("eventId")) {
            eventId = configMap.get("eventId") as String
            trackierEvent = TrackierEvent(eventId)
        }
        if (configMap.containsKey("orderId")) {
            orderId = configMap.get("orderId") as String
            trackierEvent.orderId = orderId
        }
        if (configMap.containsKey("revenue")) {
            revenue = configMap.get("revenue") as Double
            trackierEvent.revenue = revenue
        }
        if (configMap.containsKey("currency")) {
            currency = configMap.get("currency") as String
            trackierEvent.currency = currency
        }
        if (configMap.containsKey("discount")) {
            discount = configMap.get("discount") as Double
            trackierEvent.discount = discount.toFloat()
        }
        if (configMap.containsKey("couponCode")) {
            couponCode = configMap.get("couponCode") as String
            trackierEvent.couponCode = couponCode
        }
        if (configMap.containsKey("productId")) {
            productId = configMap.get("productId") as String
            trackierEvent.productId = productId
        }
        if (configMap.containsKey("param1")) {
            param1 = configMap.get("param1") as String
            trackierEvent.param1 = param1
        }
        if (configMap.containsKey("param2")) {
            param2 = configMap.get("param2") as String
            trackierEvent.param2 = param2
        }
        if (configMap.containsKey("param3")) {
            param3 = configMap.get("param3") as String
            trackierEvent.param3 = param3
        }
        if (configMap.containsKey("param4")) {
            param4 = configMap.get("param4") as String
            trackierEvent.param4 = param4
        }
        if (configMap.containsKey("param5")) {
            param5 = configMap.get("param5") as String
            trackierEvent.param5 = param5
        }
        if (configMap.containsKey("param6")) {
            param6 = configMap.get("param6") as String
            trackierEvent.param6 = param6
        }
        if (configMap.containsKey("param7")) {
            param7 = configMap.get("param7") as String
            trackierEvent.param7 = param7
        }
        if (configMap.containsKey("param8")) {
            param8 = configMap.get("param8") as String
            trackierEvent.param8 = param8
        }
        if (configMap.containsKey("param9")) {
            param9 = configMap.get("param9") as String
            trackierEvent.param9 = param9
        }
        if (configMap.containsKey("param10")) {
            param10 = configMap.get("param10") as String
            trackierEvent.param10 = param10
        }
        if (configMap.containsKey("ev")) {
            ev = configMap.get("ev") as MutableMap<String, Any>
            trackierEvent.ev = ev
        }

        Log.d("com.trackier.flutter", "eventId: " + eventId)
        Log.d("com.trackier.flutter", "orderId: " + orderId)
        Log.d("com.trackier.flutter", "revenue: " + revenue)
        Log.d("com.trackier.flutter", "currency: " + currency)
        Log.d("com.trackier.flutter", "param1: " + param1)
        Log.d("com.trackier.flutter", "param2: " + param2)
        Log.d("com.trackier.flutter", "param3: " + param3)
        Log.d("com.trackier.flutter", "param4: " + param4)
        Log.d("com.trackier.flutter", "param5: " + param5)
        Log.d("com.trackier.flutter", "param6: " + param6)
        Log.d("com.trackier.flutter", "param7: " + param7)
        Log.d("com.trackier.flutter", "param8: " + param8)
        Log.d("com.trackier.flutter", "param9: " + param9)
        Log.d("com.trackier.flutter", "param10: " + param10)
        Log.d("com.trackier.flutter", "ev: " + ev.toString())

        TrackierSDK.trackEvent(trackierEvent)
    }

    private fun getTrackierId(call: MethodCall, result: Result) {
        val installID = TrackierSDK.getTrackierId()
        result.success(installID)
    }

    private fun getAd(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getAd())
    }
    private fun getAdID(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getAdID())
    }
    private fun getAdSet(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getAdSet())
    }

    private fun getAdSetID(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getAdSetID())
    }

    private fun getCampaign(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getCampaign())
    }

    private fun getCampaignID(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getCampaignID())
    }

    private fun getChannel(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getChannel())
    }

    private fun getP1(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getP1())
    }

    private fun getP2(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getP2())
    }

    private fun getP3(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getP3())
    }

    private fun getP4(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getP4())
    }

    private fun getP5(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getP5())
    }

    private fun getClickId(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getClickId())
    }

    private fun getDlv(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getDlv())
    }

    private fun getPid(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getPid())
    }

    private fun getIsRetargeting(call: MethodCall, result: Result) {
        result.success(TrackierSDK.getIsRetargeting())
    }

    private fun setPreinstallAttribution(call: MethodCall, result: Result) {
        val pid = call.argument<String>("pid").toString()
        val campaign = call.argument<String>("campaign").toString()
        val campaignId = call.argument<String>("campaignId").toString()
        TrackierSDK.setPreinstallAttribution(pid, campaign, campaignId)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun setLocalRefTrack(call: MethodCall, result: Result) {
        val boolValue = call.argument<Boolean>("boolValue")
        val delimeter = call.argument<String>("delimeter")
        TrackierSDK.setLocalRefTrack(boolValue!!, delimeter!!)
    }

    private fun parseDeeplink(call: MethodCall, result: Result) {
        val uriDeeplink = call.arguments as String
        val uri = Uri.parse(uriDeeplink)
        TrackierSDK.parseDeepLink(uri)
    }

    private fun fireInstall() {
        TrackierSDK.fireInstall()
    }

    private fun setIMEI(call: MethodCall, result: Result) {
        val imei1 = call.argument<String>("imei1")
        val imei2 = call.argument<String>("imei2")
        TrackierSDK.setIMEI(imei1!!, imei2!!)
    }

    private fun setMacAddress(call: MethodCall, result: Result) {
        val macAddress = call.arguments as String
        TrackierSDK.setMacAddress(macAddress)
    }
}