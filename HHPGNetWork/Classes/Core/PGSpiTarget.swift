//
//  PGSpiTarget.swift
//  Alamofire
//
//  Created by ios on 2019/6/13.
//

import Moya
import UIKit
/// PGSpiderTarget 是 PGSpider 发出网络请求的配置规则
public protocol PGSpiTarget {
    /// 发出网络请求的基础地址字符串，默认返回 PGSpider 中配置的静态变量
    var baseURL: String { get }
    
    /// 网络请求的路径字符串
    var path: String { get }
    
    /// 网络请求的方式，默认返回get
    var method: Moya.Method { get }
    
    /// 网络请求参数
    var parameters: [String: Any]? { get }
    
    /// 网络请求头，默认返回 nil
    var headers: [String: String]? { get }
    
    /// 日志输出
    var logEnable: Bool { get }
}

// MARK: - extensions

extension PGSpiTarget {
    public var baseURL: String {
        if PGSpiManager.manager.baseUrl == "" {
            return self.baseURL
        }
        return PGSpiManager.manager.baseUrl
    }
    
    public var headers: [String: String]? {
        return PGSpiManager.config.httpHeaders
    }
    
    public var startImmediately: Bool {
        return PGSpiManager.config.startImmediately ?? true
    }
    
    public var logEnable: Bool {
        return PGSpiManager.config.logEnable
    }
}

extension PGSpiTarget {
    /// 根据当前配置生成 URL
    ///
    /// - Returns: URL:  baseURL 生成的 url
    /// - Throws: bathURL 或 path 不符合规则
    func asURL() throws -> URL {
        var base: String = baseURL
        if base.count <= 0 {
            base = "http://"
        }
        if let url = URL(string: base) {
            return url
        } else {
            throw PGSpiError.requestException(exception: .invalidURL(baseURL: baseURL, path: path))
        }
    }
}
