//
//  SpiLogger.swift
//  Alamofire
//
//  Created by ios on 2019/6/14.
//

import UIKit
import Moya
import Result
public class SpiLogger: PluginType {
    var logEnable : Bool = false
    
    public func willSend(_ request: RequestType, target: TargetType) {
        if !SpiManager.config.logEnable && !logEnable {
            return
        }
        let netRequest = request.request
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
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if !SpiManager.config.logEnable && !logEnable {
            return
        }
        switch result {
        case .success(let response):
            let request_url = target.baseURL.appendingPathComponent(target.path)
            print("🇨🇳 \(request_url)")
            if let data = response.data.xToJson() {
                print("🇨🇳 Return Data:")
                print("🇨🇳 \(data)")
            }
            else {
                print("❌ Can not formatter data")

            }
        case .failure(let error):
            print("❌ \(error.errorDescription ?? "无错误描述")")
        }
    }
}
extension MoyaProvider {
    
    var log : MoyaProvider {
        if let plugin = plugins.first(where: {type(of: $0) == SpiLogger.self}) as? SpiLogger {
            plugin.logEnable = true
        }
        return self
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
