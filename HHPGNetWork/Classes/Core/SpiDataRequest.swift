//
//  SpiDataRequest.swift
//  Alamofire
//
//  Created by JUN on 2019/3/3.
//

import UIKit
import Alamofire
import HandyJSON
// MARK: - 解析JSON
extension DataRequest {
    public static func spiJsonSerializer(
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DataResponseSerializer<Any>
    {
        return DataResponseSerializer { _, response, data, error in
            let serializeResponse = Request.serializeCodeResponseJSON(options: options, response: response, data: data, error: error)
            switch serializeResponse {
            case .success(let value):
                guard let value = value as? [String:Any] else {
                    return .failure(SpiError.responseSerializationFailed(reason: .dataLengthIsZero))
                }
                if let data = value[SpiManager.config.result_key.data_key] {
                    return .success(data)
                }
                return .failure(SpiError.responseSerializationFailed(reason: .dataLengthIsZero))
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    /// 解析JSON
    ///
    /// - Parameters:
    ///   - queue:
    ///   - options:
    ///   - completionHandler:
    /// - Returns: 
    @discardableResult
    public func responseSpiJSON(
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<Any>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.spiJsonSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

// MARK: - 解析对象
extension DataRequest {
    public static func ObjectSerializer<T: HandyJSON>(
        options: JSONSerialization.ReadingOptions = .allowFragments,
        designatedPath: String? = nil)
        -> DataResponseSerializer<T>
    {
        return DataResponseSerializer<T>(serializeResponse: { (request, response, data, error) -> Result<T> in
            let serializeResponse = Request.serializeCodeResponseJSON(options: options, response: response, data: data, error: error)
            switch serializeResponse {
            case .success(let value):
                guard let value = value as? [String:Any] else {
                    return .failure(SpiError.responseSerializationFailed(reason: .dataLengthIsZero))
                }
                if let value = value[SpiManager.config.result_key.data_key] as? T {
                    return .success(value)
                } else {
                    guard let object = value[SpiManager.config.result_key.data_key] as? [String:Any] else {
                        return .failure(SpiError.responseSerializationFailed(reason: .dataLengthIsZero))
                    }
                    if let path = designatedPath,path.count > 0 {
                        if let model = T.self.deserialize(from: object, designatedPath: path) {
                            return .success(model)
                        }
                    }
                    else {
                        if let model = T.self.deserialize(from: object) {
                            return .success(model)
                        }
                    }
                    return .failure(SpiError.responseSerializationFailed(reason: .objectFailed))

                }
            case .failure(let error):
                return .failure(error)
            }
        })
        
    }
    
    /// 解析Object
    ///
    /// - Parameters:
    ///   - designatedPath: 解析路径
    ///   - queue:
    ///   - options:
    ///   - completionHandler:
    /// - Returns:
    @discardableResult
    public func responseSpiObject<T: HandyJSON>(designatedPath: String? = nil, queue: DispatchQueue? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(responseSerializer: DataRequest.ObjectSerializer(options: options,designatedPath: designatedPath), completionHandler: completionHandler)
    }
    
}
// MARK: - 解析对象数组
extension DataRequest {
    public static func ObjectsSerializer<T: HandyJSON>(
        designatedPath: String? = nil,
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments)
        -> DataResponseSerializer<[T]> {
        return DataResponseSerializer(serializeResponse: { (request, response, data, error) -> Result<[T]> in
            let serializeResponse = Request.serializeCodeResponseJSON(options: options, response: response, data: data, error: error)
            switch serializeResponse {
            case .success(let value):
                guard let value = value as? [String:Any] else {
                    return .failure(SpiError.responseSerializationFailed(reason: .dataLengthIsZero))
                }
                if let value = value[SpiManager.config.result_key.data_key] as? [T] {
                    return .success(value)
                } else {
                    guard let data = value[SpiManager.config.result_key.data_key] else {
                        return .failure(SpiError.responseSerializationFailed(reason: .dataLengthIsZero))
                    }
                    if let path = designatedPath,path.count > 0 {
                        guard let datajson = data as? [String:Any] else {
                            return .failure(SpiError.responseSerializationFailed(reason: .objectFailed))
                        }
                        guard let array = datajson[path] as? [[String:Any]] else {
                            return .failure(SpiError.responseSerializationFailed(reason: .objectFailed))
                        }
                        guard let models = [T].deserialize(from: array) else {
                            return .failure(SpiError.responseSerializationFailed(reason: .objectFailed))
                        }
                        return .success(models as! [T])
                    }
                    else {
                        guard let array = data as? [[String:Any]] else {
                            return .failure(SpiError.responseSerializationFailed(reason: .objectFailed))
                        }
                        guard let models = [T].deserialize(from: array) else {
                            return .failure(SpiError.responseSerializationFailed(reason: .objectFailed))
                        }
                        return .success(models as! [T])
                    }
                }
            case .failure(let error):
                return .failure(error)
            }
        })
    }
    /// 解析对象数组
    ///
    /// - Parameters:
    ///   - designatedPath:
    ///   - queue:
    ///   - options:
    ///   - completionHandler:
    /// - Returns:
    @discardableResult
    public func responseSpiObjects<T: HandyJSON>(
        designatedPath: String? = nil,
        queue: DispatchQueue? = nil,
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (DataResponse<[T]>) -> Void)
        -> Self
    {
        return response(queue: queue, responseSerializer: DataRequest.ObjectsSerializer(designatedPath: designatedPath, queue: queue, options: options), completionHandler: completionHandler)
    }
}

extension Request {
    public static func serializeCodeResponseJSON(
        options: JSONSerialization.ReadingOptions,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?)
        -> Result<Any>
    {
        guard error == nil else { return .failure(error!) }
        if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success([:]) }
        guard let validData = data, validData.count > 0 else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
        }
        do {
            let jsonData = try JSONSerialization.jsonObject(with: validData, options: options)
            guard let json = jsonData as? [String:Any] else {
                return .failure(SpiError.responseSerializationFailed(reason: .jsonIsNotADictionary))
            }
            if let status = json[SpiManager.config.result_key.code_key] as? Int, (status == SpiManager.config.result_key.success_key){
                return .success(json)
            } else {
                guard let status = json[SpiManager.config.result_key.code_key] as? Int else{
                    return .failure(SpiError.executeFailed(reason: .unlegal))
                }
                return .failure(SpiError.executeFailed(reason: .executeFail(code: status, msg: json[SpiManager.config.result_key.msg_key] as? String)))
            }
            
        } catch {
            return .failure(SpiError.responseSerializationFailed(reason: .jsonSerializationFailed(error)))
        }
    }
    
}
private let emptyDataStatusCodes: Set<Int> = [204, 205]
