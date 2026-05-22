import Flutter
import UIKit
import EventTrackerSDK

public class EventTrackerFlutterFinalPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "event_tracker_flutter",
            binaryMessenger: registrar.messenger()
        )

       let instance = EventTrackerFlutterFinalPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
case "initialize":

    guard
        let args = call.arguments as? [String: Any],
        let eventKey = args["eventKey"] as? String
    else {

        result(
            FlutterError(
                code: "INVALID_ARGS",
                message: "Missing eventKey",
                details: nil
            )
        )

        return
    }

    let debug =
        args["debug"] as? Bool ?? false

    EventTracker.shared.initialize(
        eventKey: eventKey,
        debug: debug
    )

    result(nil)

        case "identify":
            guard
                let args = call.arguments as? [String: Any],
                let contactNumber = args["contactNumber"] as? String
            else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing contactNumber", details: nil))
                return
            }

            let traits = args["traits"] as? [String: Any?] ?? [:]

            EventTracker.shared.identify(
                contactNumber: contactNumber,
                traits: traits
            )

            result(nil)

        case "page":
            guard
                let args = call.arguments as? [String: Any],
                let pageName = args["pageName"] as? String
            else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing pageName", details: nil))
                return
            }

            let properties = args["properties"] as? [String: Any?] ?? [:]

            EventTracker.shared.page(
                pageName,
                properties: properties
            )

            result(nil)

        case "track":
            guard
                let args = call.arguments as? [String: Any],
                let eventName = args["eventName"] as? String
            else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing eventName", details: nil))
                return
            }

            let properties = args["properties"] as? [String: Any?] ?? [:]

            EventTracker.shared.track(
                eventName,
                properties: properties
            )

            result(nil)
        case "identifyAnonymous":

    guard
        let args = call.arguments as? [String: Any],
        let sessionId = args["sessionId"] as? String
    else {

        result(
            FlutterError(
                code: "INVALID_ARGS",
                message: "Missing sessionId",
                details: nil
            )
        )

        return
    }

    let traits =
        args["traits"] as? [String: Any?] ?? [:]

    var properties =
        traits

    properties["user_type"] = "guest"
    properties["session_id"] = sessionId
    properties["contact_no"] = ""
    properties["is_anonymous"] = "true"

    EventTracker.shared.track(
        "guest_session_started",
        properties: properties
    )

    result(nil)
    
        case "flush":
            EventTracker.shared.flush()
            result(nil)

            

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}