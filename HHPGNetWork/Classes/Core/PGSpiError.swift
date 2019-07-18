//
//  PGSpiError.swift
//  Alamofire
//
//  Created by ios on 2019/6/14.
//

import Foundation
/// Bat 请求过程中出现的错误
///
/// - invalidURL:   构造URL失败或生成的为无效的URL
///     - baseURL:  构造URL的基地址
///     - path:     URL请求路径
/// - parameterEncodingFalied:  参数编码过程中出现的错误
/// - responseValidationFailed: 当`validate（）`调用失败时返回
/// - responseSerializationFailed: 响应序列化程序在序列化过程中遇到错误时返回
/// - responseCodableFailed: 响应结果编码错误
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
        default:
            return nil
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
        default:
            return nil
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
        default:
            return "服务器异常，请稍后再试!"
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
    public var status: Int? {
        switch self {
        case .networkException:
            return -1001
        case .invalidURL:
            return -1002
        default:
            return -1000
        }
    }
    
    public var message: String? {
        switch self {
        case .networkException( _):
            return "网络异常，请稍后重试！"
        case .invalidURL:
            return "请求异常"
        default:
            return nil
        }
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
    public var status: Int? {
        switch self {
        case .serverException:
            return -2001
        case .notFound:
            return -2002
        case .unacceptableContentType:
            return -2003
        case .unacceptableStatusCode(let code):
            return code
        }
    }
    
    public var message: String? {
        switch self {
        case .serverException:
            return "服务器异常，请稍后重试！"
        case .notFound:
            return "请求异常"
        case .unacceptableContentType:
            return "请求异常"
        case .unacceptableStatusCode(let code):
            return "请求异常"
        }
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
    public var status: Int? {
        switch self {
        case .executeFail(let code, _):
            return code
        case .unlegal:
            return -3001
        default:
            return nil
        }
    }

    public var message: String? {
        switch self {
        case .executeFail(_, let msg):
            return msg
        default:
            return nil
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
