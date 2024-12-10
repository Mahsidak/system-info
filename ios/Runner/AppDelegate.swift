import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let deviceInfoChannel = FlutterMethodChannel(name: "com.system_info/device_info",
                                                     binaryMessenger: controller.binaryMessenger)

        deviceInfoChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "getDeviceInfo" {
                result(self?.getDeviceInfo())
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func getDeviceInfo() -> [String: String] {
        let device = UIDevice.current
        let processInfo = ProcessInfo.processInfo
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let deviceName = device.name
        let systemName = device.systemName
        let systemVersion = device.systemVersion
        let model = device.model
        let batteryLevel = UIDevice.current.batteryLevel
        
        let fileManager = FileManager.default
        let systemAttributes = try? fileManager.attributesOfFileSystem(forPath: NSHomeDirectory())
        let totalSpace = systemAttributes?[.systemSize] as? NSNumber
        let freeSpace = systemAttributes?[.systemFreeSize] as? NSNumber
        
        let totalSpaceGB = (totalSpace?.doubleValue ?? 0) / (1024 * 1024 * 1024)
        let freeSpaceGB = (freeSpace?.doubleValue ?? 0) / (1024 * 1024 * 1024)

        let deviceInfo: [String: String] = [
            "Device Name": deviceName,
            "System Name": systemName,
            "System Version": systemVersion,
            "Model": model,
            "CPU Details": "Unknown",
            "Battery": "\(batteryLevel * 100)%",
            "Number of Cores": "\(processInfo.processorCount)",
            "Active Cores": "\(processInfo.activeProcessorCount)",
            "Physical RAM": "\(processInfo.physicalMemory / (1024 * 1024 * 1024)) GB",
            "Total Storage": String(format: "%.2f GB", totalSpaceGB),
            "Available Storage": String(format: "%.2f GB", freeSpaceGB)
        ]

        return deviceInfo
    }
}
