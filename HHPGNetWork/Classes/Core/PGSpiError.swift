//
//  PGSpiError.swift
//  Alamofire
//
//  Created by ios on 2019/6/14.
//

import Foundation

public enum PGSpiError: Error {
    /// 连接异常
    ///
    /// - networkException: 网络异常
    /// - invalidURL: 请求地址异常
    public enum RequestException {
        case networkException(Error?)
        case invalidURL(baseURL: String, path: String)
    }

    /// 响应异常
    ///
    /// - serverException: 服务器异常 500
    /// - notFound: 方法不存在 404
    /// - unacceptableContentType: ContentType 不被接受
    /// - unacceptableStatusCode: 响应状态异常
    public enum ResponseException {
        case serverException
        case notFound
        case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
        case unacceptableStatusCode(code: Int)
    }

    /// 序列化异常
    ///
    /// - dataNotFound: data缺失
    /// - jsonSerializationFailed: JSON序列化异常
    /// - objectFailed: 对象转换失败
    public enum ResponseSerializationException {
        case dataNotFound
        case jsonSerializationFailed(Error?)
        case objectFailed
    }
    
    /// 执行异常
    ///
    /// - executeFail: 执行结果异常，操作失败
    /// - unlegal: 执行结果状态吗不合理
    public enum ExecuteException {
        case executeFail(code: Int, msg: String?)
        case unlegal
    }
    case requestException(exception: RequestException)
    case responseException(exception: ResponseException)
    case responseSerializationException(exception: ResponseSerializationException)
    case executeException(exception: ExecuteException)
}

extension PGSpiError {
    public var isRequestException: Bool {
        if case .requestException = self { return true }
        return false
    }

    public var isResponseException: Bool {
        if case .responseException = self { return true }
        return false
    }
    
    public var isResponseSerializationException: Bool {
        if case .responseSerializationException = self { return true }
        return false
    }
    
    public var isExecuteException: Bool {
        if case .executeException = self { return true }
        return false
    }
}

extension PGSpiError {
    var underlyingError: Error? {
        switch self {
        case .requestException(exception: let exception):
            return exception.underlyingError
        case .responseException(exception: let exception):
            return exception.underlyingError
        case .responseSerializationException(exception: let exception):
            return exception.underlyingError
        case .executeException(exception: let exception):
            return exception.underlyingError
        }
    }
}

extension PGSpiError.RequestException {
    var underlyingError: Error? {
        switch self {
        case .networkException(let error):
            return error
        default:
            return nil
        }
    }
}

extension PGSpiError.ResponseException {
    var underlyingError: Error? {
        return nil
    }
}

extension PGSpiError.ResponseSerializationException {
    var underlyingError: Error? {
        switch self {
        case .jsonSerializationFailed(let error):
            return error
        default:
            return nil
        }
    }
}

extension PGSpiError.ExecuteException {
    var underlyingError: Error? {
        return nil
    }
}

extension PGSpiError: LocalizedError {
    public var status: Int? {
        switch self {
        case .requestException(let exception):
            return exception.status
        case .responseException(let exception):
            return exception.status
        case .executeException(let exception):
            return exception.status
        case .responseSerializationException(let exception):
            return exception.status
        }
    }

    public var message: String? {
        switch self {
        case .requestException(let exception):
            return exception.message
        case .responseException(let exception):
            return exception.message
        case .executeException(let exception):
            return exception.message
        case .responseSerializationException(let exception):
            return exception.message
        }
    }

    public var errorDescription: String? {
        switch self {
        case .requestException(let exception):
            return exception.errorDescription
        case .responseException(let exception):
            return exception.errorDescription
        case .responseSerializationException(let exception):
            return exception.errorDescription
        case .executeException(let exception):
            return exception.errorDescription
        }
    }
}

extension PGSpiError.RequestException: LocalizedError {
    public var status: Int {
        switch self {
        case .networkException:
            return 10001
        case .invalidURL:
            return 10002
        }
    }
    
    public var message: String? {
        return SpiCode[status]?.msg ?? ""
    }

    public var errorDescription: String? {
        switch self {
        case .networkException(let error):
            return "NetWork Exception:\(error?.localizedDescription ?? "")"
        case .invalidURL(let baseURL, let path):
            return "Url Exception: \(baseURL)\(path)"
        }
    }
}

extension PGSpiError.ResponseSerializationException: LocalizedError {
    public var status: Int {
        switch self {
        case .dataNotFound:
            return 10006
        case .jsonSerializationFailed:
            return 10007
        case .objectFailed:
            return 10008
        }
    }
    
    public var message: String? {
        return SpiCode[status]?.msg ?? ""
    }
    public var errorDescription: String? {
        switch self {
        case .dataNotFound:
            return "The data in response was not found"
        case .jsonSerializationFailed(let error):
            return "Response Serialization Failed: \(error?.localizedDescription ?? "")"
        case .objectFailed:
            return "The Serialization Result is not a Object"
        }
    }
}

extension PGSpiError.ResponseException: LocalizedError {
    public var status: Int {
        switch self {
        case .serverException:
            return 10003
        case .notFound:
            return 10004
        case .unacceptableContentType:
            return 10005
        case .unacceptableStatusCode(let code):
            return code
        }
    }
    
    public var message: String? {
        return SpiCode[status]?.msg ?? ""
    }
    public var localizedDescription: String {
        switch self {
        case .serverException:
            return "Server could not be access."
        case .notFound:
            return "The method could not be found."
        case .unacceptableContentType(let acceptableTypes, let responseType):
            return (
                "Response Content-Type \"\(responseType)\" does not match any acceptable types: " +
                    "\(acceptableTypes.joined(separator: ","))."
            )
        case .unacceptableStatusCode(let code):
            return "Response status code was unacceptable: \(code)."
        }
    }
}

extension PGSpiError.ExecuteException: LocalizedError {
    public var status: Int {
        switch self {
        case .executeFail(let code, _):
            return code
        case .unlegal:
            return 10009
        }
    }

    public var message: String? {
        switch self {
        case .executeFail(_, let msg):
            return msg
        case .unlegal:
            return SpiCode[status]?.msg ?? ""
        }
    }

    public var errorDescription: String? {
        switch self {
        case .executeFail(_, let msg):
            if let info = msg {
                if info.count != PGSpiManager.config.result_key.success_key {
                    return "操作异常，请稍后重试"
                }
            }
            return msg
        case .unlegal:
            return "执行结果不合法"
        }
    }
}
let SpiCode: [Int: (status: Int, msg: String)] = [
    // App级区别码10000
    10000: (status: 10000, msg: "网络异常，请稍后重试！"),
    /// 登陆注册区别码10001
    10001: (status: 10001, msg: "请求地址异常"),
    10002: (status: 10002, msg: "服务器异常，请稍后重试！"),
    10003: (status: 10003, msg: "接口未找到"),
    10004: (status: 10004, msg: "Content-Type异常"),
    10005: (status: 10005, msg: "返回状态异常"),
    10006: (status: 10006, msg: "没有data字段"),
    10007: (status: 10007, msg: "JSON序列化异常"),
    10008: (status: 10007, msg: "对象序列化异常"),
    10009: (status: 10009, msg: "执行结果不合法,没有状态字段"),
]
