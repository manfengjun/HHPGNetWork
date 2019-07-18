//
//  Response+HandyJSON.swift
//
//  Created by ios on 2019/6/14.
//

import HandyJSON
import Moya
import UIKit

// MARK: - JSON JSONSerialization 过滤 Code

public extension Response {
    func mapSpiJSON() throws -> Any {
        if emptyDataStatusCodes.contains(statusCode) {
            return [:]
        }
        let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let json = jsonData as? [String: Any] else {
            throw PGSpiError.responseSerializationException(exception: PGSpiError.ResponseSerializationException.jsonSerializationFailed(nil))
        }
        if let status = json[PGSpiManager.config.result_key.code_key] as? Int, status == PGSpiManager.config.result_key.success_key {
            return json
        } else {
            guard let status = json[PGSpiManager.config.result_key.code_key] as? Int else {
                throw PGSpiError.executeException(exception: .unlegal)
            }
            throw PGSpiError.executeException(exception: .executeFail(code: status, msg: json[PGSpiManager.config.result_key.msg_key] as? String))
        }
    }
}

// MARK: - Object: HandyJSON

public extension Response {
    func mapSpiObject<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil) throws -> T {
        let json = try mapSpiJSON()
        guard let value = json as? [String: Any] else {
            throw PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(nil))
        }
        if let value = value[PGSpiManager.config.result_key.data_key] as? T {
            return value
        } else {
            guard let object = value[PGSpiManager.config.result_key.data_key] as? [String: Any] else {
                throw PGSpiError.responseSerializationException(exception: .dataNotFound)
            }
            if let path = designatedPath, path.count > 0 {
                if let model = T.self.deserialize(from: object, designatedPath: path) {
                    return model
                }
            } else {
                if let model = T.self.deserialize(from: object) {
                    return model
                }
            }
            throw PGSpiError.responseSerializationException(exception: .objectFailed)
        }
    }
}

// MARK: - [Object: HandyJSON]

public extension Response {
    func mapSpiObjects<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil) throws -> [T] {
        let json = try mapSpiJSON()
        guard let value = json as? [String: Any] else {
            throw PGSpiError.responseSerializationException(exception: PGSpiError.ResponseSerializationException.jsonSerializationFailed(nil))
        }
        if let value = value[PGSpiManager.config.result_key.data_key] as? [T] {
            return value
        } else {
            guard let data = value[PGSpiManager.config.result_key.data_key] else {
                throw PGSpiError.responseSerializationException(exception: .dataNotFound)
            }
            if let path = designatedPath, path.count > 0 {
                guard let datajson = data as? [String: Any] else {
                    throw PGSpiError.responseSerializationException(exception: .objectFailed)
                }
                guard let array = datajson[path] as? [[String: Any]] else {
                    throw PGSpiError.responseSerializationException(exception: .objectFailed)
                }
                guard let models = [T].deserialize(from: array) else {
                    throw PGSpiError.responseSerializationException(exception: .objectFailed)
                }
                return models as! [T]
            } else {
                guard let array = data as? [[String: Any]] else {
                    throw PGSpiError.responseSerializationException(exception: .objectFailed)
                }
                guard let models = [T].deserialize(from: array) else {
                    throw PGSpiError.responseSerializationException(exception: .objectFailed)
                }
                return models as! [T]
            }
        }
    }
}

private let emptyDataStatusCodes: Set<Int> = [204, 205]
