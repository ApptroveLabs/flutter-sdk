import Flutter
import UIKit
import trackier_ios_sdk

public class SwiftTrackierfluttersdkPlugin: NSObject, FlutterPlugin, DeepLinkListener {
	
	private var channel: FlutterMethodChannel
	
	private init(channel: FlutterMethodChannel) {
		self.channel = channel
	}
	
	public func onDeepLinking(result: trackier_ios_sdk.DeepLink) {
		var dict = Dictionary<String, Any>()
		dict["uri"] = result.getUrl()
		self.channel.invokeMethod("deferred-deeplink", arguments: dict)
	}
	
	public static func register(with registrar: FlutterPluginRegistrar) {
		let channel = FlutterMethodChannel(name: "trackierfluttersdk", binaryMessenger: registrar.messenger())
		let instance = SwiftTrackierfluttersdkPlugin(channel: channel)
		registrar.addMethodCallDelegate(instance, channel: channel)
	}
	
	public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
		//result("iOS " + UIDevice.current.systemVersion)
			if (call.method == "setUserId") {
				let dict = call.arguments as? String
				if (dict != nil) { setUserId(dict: dict!) }
			} else if (call.method == "setUserEmail") {
				let dict = call.arguments as? String
				if (dict != nil) { setUserEmail(dict: dict!) }
			} else if (call.method == "setUserPhone") {
				let dict = call.arguments as? String
				if (dict != nil) { setUserPhone(dict: dict!) }
			} else if (call.method == "setUserName") {
				let dict = call.arguments as? String
				if (dict != nil) { setUserName(dict: dict!) }
			} else if (call.method == "setDOB") {
				let dict = call.arguments as? String
				if (dict != nil) { setDOB(dict: dict!) }
			} else if (call.method == "setGender") {
				let dict = call.arguments as? String
				if (dict != nil) { setGender(dict: dict!) }
			} else if (call.method == "setUserAdditonalDetail") {
				let dict = call.arguments as? [String:Any]
				if (dict != nil) { setUserAdditionalDetails(dict: dict!) }
			} else if (call.method == "updatePostbackConversion") {
				let dict = call.arguments as? Int
				if (dict != nil) { updatePostbackConversion(dict: dict!) }
			} else if (call.method == "updateAppleAdsToken") {
				let dict = call.arguments as? String
				if (dict != nil) { updateAppleAdsToken(dict: dict!) }
			} else if (call.method == "parseDeeplink") {
				let dict = call.arguments as? String
				if (dict != nil) { parseDeeplink(dict: dict!) }
			} else if (call.method == "setIMEI") {
				let dict = call.arguments as? String
				if (dict != nil) { setIMEI(dict: dict!) }
			} else if (call.method == "setMacAddress") {
				let dict = call.arguments as? String
				if (dict != nil) { setMacAddress(dict: dict!) }
			} else if (call.method == "initializeSDK") {
				let dict = call.arguments as? [String:Any]
				if (dict != nil) { initializeSDK(dict: dict) }
			} else if (call.method == "trackierEvent") {
				let dict = call.arguments as? [String:Any]
				if (dict != nil) { trackEvent(dict: dict) }
			} else if (call.method == "getAd") {
				getAd(result: result)
			} else if (call.method == "getAdID") {
				getAdID(result: result)
			} else if (call.method == "getAdSet") {
				getAdSet(result: result)
			} else if (call.method == "getAdSetID") {
				getAdSetID(result: result)
			} else if (call.method == "getCampaign") {
				getCampaign(result: result)
			} else if (call.method == "getCampaignID") {
				getCampaignID(result: result)
			} else if (call.method == "getP1") {
				getP1(result: result)
			} else if (call.method == "getP2") {
				getP2(result: result)
			} else if (call.method == "getP3") {
				getP3(result: result)
			} else if (call.method == "getP4") {
				getP4(result: result)
			} else if (call.method == "getP5") {
				getP5(result: result)
			} else if (call.method == "getClickId") {
				getClickId(result: result)
			} else if (call.method == "getDlv") {
				getDlv(result: result)
			} else if (call.method == "getPid") {
				getPid(result: result)
			} else if (call.method == "getIsRetargeting") {
				getIsRetargeting(result: result)
			} else if (call.method == "getTrackierId") {
				getTrackierId(result: result)
			} else if (call.method == "createDynamicLink") {
				guard let args = call.arguments as? [String: Any] else {
					result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
					return
				}
				do {
					let builder = DynamicLink.Builder()
					
					// Required Parameters
					if let templateId = args["templateId"] as? String {
						builder.setTemplateId(templateId)
					}
					if let link = args["link"] as? String {
						builder.setLink(link)
					}
					if let domainUriPrefix = args["domainUriPrefix"] as? String {
						builder.setDomainUriPrefix(domainUriPrefix)
					}
					if let deepLinkValue = args["deepLinkValue"] as? String {
						builder.setDeepLinkValue(deepLinkValue)
					}

					// Android Redirection
					if let androidRedirect = args["androidRedirect"] as? String {
						let androidParams = AndroidParameters.Builder()
							.setRedirectLink(androidRedirect)
							.build()
						builder.setAndroidParameters(androidParams)
					}

					// iOS Redirection
					if let iosRedirect = args["iosRedirect"] as? String {
						let iosParams = IosParameters.Builder()
							.setRedirectLink(iosRedirect)
							.build()
						builder.setIosParameters(iosParams)
					}

					// Desktop Redirection
					if let desktopRedirect = args["desktopRedirect"] as? String {
						let desktopParams = DesktopParameters.Builder()
							.setRedirectLink(desktopRedirect)
							.build()
						builder.setDesktopParameters(desktopParams)
					}

					// SDK Parameters
					if let sdkParams = args["sdkParameters"] as? [String: String] {
						builder.setSDKParameters(sdkParams)
					}

					// Attribution Parameters
					if let attrParams = args["attributionParameters"] as? [String: String] {
						builder.setAttributionParameters(
							channel: attrParams["channel"] ?? "",
							campaign: attrParams["campaign"] ?? "",
							mediaSource: attrParams["media_source"] ?? "",
							p1: attrParams["p1"] ?? "",
							p2: attrParams["p2"] ?? "",
							p3: attrParams["p3"] ?? "",
							p4: attrParams["p4"] ?? "",
							p5: attrParams["p5"] ?? ""
						)
					}

					// Social Meta Tag Parameters
					if let socialMeta = args["socialMeta"] as? [String: String] {
						let metaParams = SocialMetaTagParameters.Builder()
							.setTitle(socialMeta["title"] ?? "")
							.setDescription(socialMeta["description"] ?? "")
							.setImageLink(socialMeta["imageLink"] ?? "")
							.build()
						builder.setSocialMetaTagParameters(metaParams)
					}

					let dynamicLink = builder.build()
					// Call Trackier SDK (replace this with actual SDK logic)
					TrackierSDK.createDynamicLink(
						dynamicLink: dynamicLink,
						onSuccess: { url in
							result(url)
						},
						onFailure: { error in
							result(FlutterError(code: "ERROR", message: error, details: nil))
						}
					)

				} catch let error {
					result(FlutterError(code: "EXCEPTION", message: error.localizedDescription, details: nil))
				}
				
			} else if (call.method == "resolveDeeplinkUrl") {
				if let args = call.arguments as? [String: Any],
					let urlString = args["url"] as? String {
					TrackierSDK.resolveDeeplinkUrl(inputUrl: urlString) { sdkResult in
								switch sdkResult {
								case .success(let dlData):
									var resultMap: [String: Any] = ["url": dlData.url]

									if let sdkParams = dlData.sdkParams {
										resultMap["sdkParams"] = sdkParams
									}

									result(resultMap)

								case .failure(let error):
									result(FlutterError(code: "RESOLVE_FAILED",
														message: error.localizedDescription,
														details: nil))
								}
							}

						} else {
							result(FlutterError(code: "INVALID_ARGUMENTS",
											message: "Missing URL argument",
											details: nil))
					}
			}
			else {
			result(FlutterMethodNotImplemented)
		}
	}
	
	func setUserId(dict: String) -> Void {
		let userId = dict
		TrackierSDK.setUserID(userId: userId)
	}
	
	func setUserEmail(dict: String) -> Void {
		let userEmail = dict
		TrackierSDK.setUserEmail(userEmail: userEmail);
	}

	func setUserPhone(dict: String) -> Void {
		let userPhone = dict
		TrackierSDK.setUserPhone(userPhone: userPhone);
	}

	func setUserName(dict: String) -> Void {
		let userName = dict
		TrackierSDK.setUserName(userName: userName);
	}
	
	func setDOB(dict: String) -> Void {
		let dob = dict
		TrackierSDK.setDOB(dob: dob)
	}
	
	func setGender(dict: String) -> Void {
		let gender = dict
		switch gender {
		case "Gender.Male": TrackierSDK.setGender(gender: .MALE)
		case "Gender.Female": TrackierSDK.setGender(gender: .FEMALE)
		case "Gender.Others": TrackierSDK.setGender(gender: .OTHERS)
		default: print("No Gender found")
		}
	}
	
	func setUserAdditionalDetails(dict: Dictionary<String, Any>) -> Void {
		let userAdditionalDetails = dict
		TrackierSDK.setUserAdditionalDetails(userAdditionalDetails: userAdditionalDetails);
	}
	
	func updatePostbackConversion(dict: Int) -> Void {
		let postbackConversion = dict
		TrackierSDK.updatePostbackConversion(conversionValue: postbackConversion)
	}
	
	func updateAppleAdsToken(dict: String) -> Void {
		let appleAdsToken = dict
		TrackierSDK.updateAppleAdsToken(token: appleAdsToken)
	}
	
	func parseDeeplink(dict: String) -> Void {
		let parseDeeplinkUrl = dict
		TrackierSDK.parseDeepLink(uri: parseDeeplinkUrl)
	}
	
	func setMacAddress(dict: String) -> Void {
		//do nothing, For android omly
	}
	
	func setIMEI(dict: String) -> Void {
		//do nothing, For android omly
	}
	
	func getAd(result: FlutterResult) -> Void {
		result(TrackierSDK.getAd())
	}
	
	func getAdID(result: FlutterResult) -> Void {
		result(TrackierSDK.getAdID())
	}
	
	func getAdSet(result: FlutterResult) -> Void {
		result(TrackierSDK.getAdSet())
	}
	
	func getAdSetID(result: FlutterResult) -> Void {
		result(TrackierSDK.getAdSetID())
	}
	
	func getCampaign(result: FlutterResult) -> Void {
		result(TrackierSDK.getCampaign())
	}
	
	func getCampaignID(result: FlutterResult) -> Void {
		result(TrackierSDK.getCampaignID())
	}
	
	func getChannel(result: FlutterResult) -> Void {
		result(TrackierSDK.getChannel())
	}
	
	func getP1(result: FlutterResult) -> Void {
		result(TrackierSDK.getP1())
	}
	
	func getP2(result: FlutterResult) -> Void {
		result(TrackierSDK.getP2())
	}
	
	func getP3(result: FlutterResult) -> Void {
		result(TrackierSDK.getP3())
	}
	
	func getP4(result: FlutterResult) -> Void {
		result(TrackierSDK.getP4())
	}
	
	func getP5(result: FlutterResult) -> Void {
		result(TrackierSDK.getP5())
	}
	
	func getClickId(result: FlutterResult) -> Void {
		result(TrackierSDK.getClickId())
	}
	
	func getDlv(result: FlutterResult) -> Void {
		result(TrackierSDK.getDlv())
	}
	
	func getPid(result: FlutterResult) -> Void {
		result(TrackierSDK.getPid())
	}
	
	func getIsRetargeting(result: FlutterResult) -> Void {
		result(TrackierSDK.getIsRetargeting())
	}
	
	func getTrackierId(result: FlutterResult) -> Void {
		result(TrackierSDK.getTrackierId())
	}
	
	
	func initializeSDK(dict: Optional<Dictionary<String, Any>>) -> Void {
		let appToken = "\(dict?["appToken"] as? String ?? "")"
		let environment = "\(dict?["environment"] as? String ?? "")"
		let secretId = "\(dict?["secretId"] as? String ?? "")"
		let secretKey = "\(dict?["secretKey"] as? String ?? "")"
		let deeplinkKey = "\(dict?["deeplinkCallback"] as? String ?? "")"
		let regionString = "\(dict?["region"] as? String ?? "")".lowercased()
		let config = TrackierSDKConfig(appToken: appToken , env: environment)
		config.setAppSecret(secretId: secretId, secretKey: secretKey)
		config.setSDKVersion(sdkVersion: "1.6.74")
		if (!deeplinkKey.isEmpty) {
			config.setDeeplinkListerner(listener: self)
		}
		switch regionString {
			case "in":
				config.setRegion(.IN)
			case "global":
				config.setRegion(.GLOBAL)
			default:
				config.setRegion(.NONE)
			}
		TrackierSDK.initialize(config: config)
	}
	
	func trackEvent(dict: Optional<Dictionary<String, Any>>) -> Void {
		let eventId: String = "\(dict?["eventId"] as? String ?? "")"
		let currency: String = "\(dict?["currency"] as? String ?? "")"
		let revenue: Float64 = (dict?["revenue"] as? Float64 ?? 0.0)
		let orderId: String = "\(dict?["orderId"] as? String ?? "")"
		let discount: Float64 = (dict?["discount"] as? Float64 ?? 0.0)
		let couponCode: String = "\(dict?["couponCode"] as? String ?? "")"
		let param1: String = "\(dict?["param1"] as? String ?? "")"
		let param2: String = "\(dict?["param2"] as? String ?? "")"
		let param3: String = "\(dict?["param3"] as? String ?? "")"
		let param4: String = "\(dict?["param4"] as? String ?? "")"
		let param5: String = "\(dict?["param5"] as? String ?? "")"
		let param6: String = "\(dict?["param6"] as? String ?? "")"
		let param7: String = "\(dict?["param7"] as? String ?? "")"
		let param8: String = "\(dict?["param8"] as? String ?? "")"
		let param9: String = "\(dict?["param9"] as? String ?? "")"
		let param10: String = "\(dict?["param10"] as? String ?? "")"
		var ev:Dictionary<String,Any> = dict ?? [:]
		
		for (key, value) in ev {
			ev[key] = value
		}
		
		let event = TrackierEvent(id: eventId)
		event.setRevenue(revenue: Float64(revenue), currency: currency)
		event.orderId = orderId
		event.setCouponCode(couponCode: couponCode)
		event.setDiscount(discount: Float64(discount))
		event.param1  = param1
		event.param2  = param2
		event.param3  = param3
		event.param4  = param4
		event.param5  = param5
		event.param6  = param6
		event.param7  = param7
		event.param8  = param8
		event.param9  = param9
		event.param10 = param10
		for (key, value) in ev {
			event.addEventValue(prop: key, val: value)
		}
		TrackierSDK.trackEvent(event: event)
	}
}



