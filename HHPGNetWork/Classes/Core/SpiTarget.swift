//
//  SpiTarget.swift
//  Alamofire
//
//  Created by ios on 2019/6/13.
//

import Moya
import UIKit
/// SpiderTarget 是 Spider 发出网络请求的配置规则
public protocol SpiTarget {
    /// 发出网络请求的基础地址字符串，默认返回 Spider 中配置的静态变量
    var baseURL: String { get }
    
    /// 网络请求的路径字符串
    var path: String { get }
    
    /// 网络请求的方式，默认返回get
    var method: Moya.Method { get }
    
    /// 网络请求参数
    var parameters: [String: Any]? { get }
    
    /// 网络请求头，默认返回 nil
    var headers: [String: String]? { get }
    
    /// 网络请求超时时间，默认返回 Bat 中配置的静态变量
    var timeoutInterval: TimeInterval { get }
    
    /// 是否允许蜂窝数据网络连接，默认返回 Bat 中配置的静态变量
    var allowsCellularAccess: Bool { get }
    
}

// MARK: - extensions

extension SpiTarget {
    public var baseURL: String {
        if SpiManager.manager.baseUrl == "" {
            return self.baseURL
        }
        return SpiManager.manager.baseUrl
    }
    
    public var headers: [String: String]? {
        return SpiManager.config.httpHeaders
    }
    
    public var timeoutInterval: TimeInterval {
        return SpiManager.config.timeoutInterval ?? 60.0
    }
    
    public var allowsCellularAccess: Bool {
        return SpiManager.config.allowsCellucerAccess ?? true
    }
    
    public var startImmediately: Bool {
        return SpiManager.config.startImmediately ?? true
    }
}

extension SpiTarget {
    /// 根据当前配置生成 URL
    ///
    /// - Returns: URL:  拼接 baseURL 及 path 生成的 url
    /// - Throws: bathURL 或 path 不符合规则
    func asURL() throws -> URL {
        if path.hasPrefix("http") {
            if let url = URL(string: path) {
                return url
            } else {
                throw SpiError.invalidURL(baseURL: baseURL, path: path)
            }
        } else {
            if var url = URL(string: baseURL) {
                url.appendPathComponent(path)
                return url
            } else {
                throw SpiError.invalidURL(baseURL: baseURL, path: path)
            }
        }
    }
}
