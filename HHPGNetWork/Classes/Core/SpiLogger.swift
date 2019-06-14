//
//  SpiLogger.swift
//  Alamofire
//
//  Created by ios on 2019/6/14.
//

import UIKit

public class SpiLogger {
    /// 输出信息
    ///
    /// - Parameters:
    ///   - userInfo:
    ///   - name:
    public static func outStream(_ userInfo: [AnyHashable: Any]?, name: NSNotification.Name?) {
        switch name {
        case Notification.Name.Task.DidResume:
            self.outRequest(userInfo: userInfo)
        case Notification.Name.Task.DidSuspend:
            self.outRequest(userInfo: userInfo)
        case Notification.Name.Task.DidCancel:
            self.outRequest(userInfo: userInfo)
        case Notification.Name.Task.DidComplete:
            self.outResponse(userInfo: userInfo)
        default:
            break
        }
    }
    
    public static func outRequest(userInfo: [AnyHashable: Any]?) {
        if let task = userInfo?[Notification.Key.Task] as? URLSessionTask {
            let netRequest = task.originalRequest?.urlRequest
            if let url = netRequest?.description {
                print("✅ " + url)
            }
            if let httpMethod = netRequest?.httpMethod {
                print("\t METHOD:\(httpMethod)")
            }
            if let body = netRequest?.httpBody, let output = String(data: body, encoding: .utf8) {
                print("\t Body:\(output)")
            }
        }
    }
    
    public static func outResponse(userInfo: [AnyHashable: Any]?) {
        var request_url = ""
        if let task = userInfo?[Notification.Key.Task] as? URLSessionTask {
            let netRequest = task.originalRequest?.urlRequest
            if let url = netRequest?.description {
                request_url = url
            }
        }
        if let response = userInfo?[Notification.Key.ResponseData] as? Data {
            if let data = response.xToJson() {
                print("🇨🇳 \(request_url)")
                print("🇨🇳 Return Data:")
                print("🇨🇳 \(data)")
            } else {
                print("❌ Can not formatter data")
            }
        }
    }
}

private extension Data {
    static func JSONString(from json: Any?) -> String? {
        guard let json = json else {
            return nil
        }
        var string: String?
        
        if let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted), let dataString = String(data: data, encoding: .utf8) {
            string = dataString
        }
        return string
    }
    
    func xToJson() -> String? {
        var string: String?
        if let json = try? JSONSerialization.jsonObject(with: self, options: []), let dataString = Data.JSONString(from: json) {
            string = dataString
        } else if let dataString = String(data: self, encoding: .utf8) {
            string = dataString
        }
        
        return string
    }
}
