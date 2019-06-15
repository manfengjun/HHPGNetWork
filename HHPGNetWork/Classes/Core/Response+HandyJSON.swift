//
//  Response+HandyJSON.swift
//
//  Created by ios on 2019/6/14.
//

import UIKit
import Moya
import HandyJSON
// MARK: - JSON JSONSerialization 过滤 Code
public extension Response {
    func mapSpiJSON() throws -> Any {
        if emptyDataStatusCodes.contains(statusCode) {
            return [:]
        }
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            guard let json = jsonData as? [String:Any] else {
                throw SpiError.responseSerializationFailed(reason: .jsonIsNotADictionary)
            }
            if let status = json[SpiManager.config.result_key.code_key] as? Int, (status == SpiManager.config.result_key.success_key){
                return json
            } else {
                guard let status = json[SpiManager.config.result_key.code_key] as? Int else{
                    throw SpiError.executeFailed(reason: .unlegal)
                }
                throw SpiError.executeFailed(reason: .executeFail(code: status, msg: json[SpiManager.config.result_key.msg_key] as? String))

            }
            
        } catch {
            throw SpiError.responseSerializationFailed(reason: .jsonSerializationFailed(error))
        }
    }
}
// MARK: - Object: HandyJSON
public extension Response {
    func mapSpiObject<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil) throws -> T {
        do {
            let json = try mapSpiJSON()
            guard let value = json as? [String:Any] else {
                throw SpiError.responseSerializationFailed(reason: .jsonIsNotADictionary)
            }
            if let value = value[SpiManager.config.result_key.data_key] as? T {
                return value
            } else {
                guard let object = value[SpiManager.config.result_key.data_key] as? [String:Any] else {
                    throw SpiError.responseSerializationFailed(reason: .dataLengthIsZero)
                }
                if let path = designatedPath,path.count > 0 {
                    if let model = T.self.deserialize(from: object, designatedPath: path) {
                        return model
                    }
                }
                else {
                    if let model = T.self.deserialize(from: object) {
                        return model
                    }
                }
                throw SpiError.responseSerializationFailed(reason: .objectFailed)
                
            }
        } catch  {
            throw SpiError.responseSerializationFailed(reason: .objectFailed)
        }
    }
}

// MARK: - [Object: HandyJSON]
public extension Response {
    func mapSpiObjects<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil) throws -> [T] {
        do {
            let json = try mapSpiJSON()
            guard let value = json as? [String:Any] else {
                throw SpiError.responseSerializationFailed(reason: .jsonIsNotADictionary)
                
            }
            if let value = value[SpiManager.config.result_key.data_key] as? [T] {
                return value
            } else {
                guard let data = value[SpiManager.config.result_key.data_key] else {
                    throw SpiError.responseSerializationFailed(reason: .dataLengthIsZero)
                }
                if let path = designatedPath,path.count > 0 {
                    guard let datajson = data as? [String:Any] else {
                        throw SpiError.responseSerializationFailed(reason: .objectFailed)
                    }
                    guard let array = datajson[path] as? [[String:Any]] else {
                        throw SpiError.responseSerializationFailed(reason: .objectFailed)
                    }
                    guard let models = [T].deserialize(from: array) else {
                        throw SpiError.responseSerializationFailed(reason: .objectFailed)
                    }
                    return models as! [T]
                }
                else {
                    guard let array = data as? [[String:Any]] else {
                        throw SpiError.responseSerializationFailed(reason: .objectFailed)
                    }
                    guard let models = [T].deserialize(from: array) else {
                        throw SpiError.responseSerializationFailed(reason: .objectFailed)
                    }
                    return models as! [T]
                }
            }
        } catch {
            throw SpiError.responseSerializationFailed(reason: .objectFailed)
        }
    }
}
private let emptyDataStatusCodes: Set<Int> = [204, 205]
