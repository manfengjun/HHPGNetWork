//
//  SpiManager.swift
//  Alamofire
//
//  Created by ios on 2019/6/13.
//

import Alamofire
import UIKit

public class SpiManager {
    public static var manager: SpiManager {
        struct Static {
            static let manager: SpiManager = SpiManager()
        }
        return Static.manager
    }
    
    // MARK: - 统一设置
    
    public struct config {
        public static var baseUrls: [String] = [""]
        public static var httpHeaders: [String: String]?
        public static var startImmediately: Bool?
        public static var allowsCellucerAccess: Bool?
        public static var timeoutInterval: TimeInterval?
        public static var result_key: SpiRegKey = SpiRegKey()
        public static var logEnable: Bool = true
        
        /// 静态方法，设置 Bat 全局配置
        public static func setConfig(baseUrls: [String] = [],
                                     httpHeaders: HTTPHeaders? = nil,
                                     startImmediately: Bool = true,
                                     allowsCellucerAccess: Bool = true,
                                     timeoutInterval: TimeInterval = 60,
                                     result_key: SpiRegKey? = nil,
                                     logEnable: Bool = true) {
            self.baseUrls = baseUrls
            self.httpHeaders = httpHeaders
            self.startImmediately = startImmediately
            self.allowsCellucerAccess = allowsCellucerAccess
            self.timeoutInterval = timeoutInterval
            self.logEnable = logEnable
            if let resultKey = result_key {
                self.result_key = resultKey
            }
        }
    }
    
    /// 重试次数
    public var repeatNum: Int = 2
    
    /// 轮询次数
    public var retryNum: Int {
        return self.repeatNum * SpiManager.config.baseUrls.count
    }
    
    /// 当前数组位置
    private var index: Int = 0
    /// 基础地址
    public var baseUrl: String {
        if SpiManager.config.baseUrls.count > 0 {
            return SpiManager.config.baseUrls[self.index % SpiManager.config.baseUrls.count]
        } else {
            return ""
        }
    }
    
    func getNext() {
        if self.index < SpiManager.config.baseUrls.count * self.repeatNum {
            self.index = self.index + 1
        } else {
            self.index = 0
        }
    }
}

/// 网络地址管理
public class UrlManager {
    public static var shareInstance: UrlManager {
        struct Static {
            static let instance: UrlManager = UrlManager()
        }
        return Static.instance
    }
}

public struct SpiRegKey {
    var code_key: String = "status"
    var msg_key: String = "msg"
    var data_key: String = "data"
    var success_key: Int = 1
    public init(code: String = "status",
                msg: String = "msg",
                data: String = "data",
                success: Int = 0) {
        self.code_key = code
        self.msg_key = msg
        self.data_key = data
        self.success_key = success
    }
    
    init() {}
}
