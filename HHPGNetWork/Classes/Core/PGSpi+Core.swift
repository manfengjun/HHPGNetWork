//
//  PGSpi+Core.swift
//  Alamofire
//
//  Created by ios on 2019/7/29.
//

import Moya
import UIKit
import HandyJSON

public extension PGSpi {
    
    /// JSON
    ///
    /// - Parameter completion:
    public func responseSpiJSON(completion: @escaping (_ result: Result<Any, PGSpiError>) -> Void) {
        asProvider().request(self) { (response) in
            switch response.result {
            case .success(let value):
                do {
                    let json = try value.mapJSON()
                    completion(.success(json))
                } catch(let error) {
                    if error is PGSpiError {
                        completion(.failure(error as! PGSpiError))
                    }
                    completion(.failure(PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(error))))
                }
            case .failure(let error):
                if error is PGSpiError {
                    completion(.failure(error as! PGSpiError))
                }
                completion(.failure(PGSpiError.requestException(exception: .networkException(nil))))
            }
        }
    }
    
    /// Object
    ///
    /// - Parameters:
    ///   - designatedPath: 解析路径
    ///   - completion:
    public func responseSpiObject<T: HandyJSON>(designatedPath: String? = nil, completion: @escaping (_ result: Result<T, PGSpiError>) -> Void) -> Void {
        asProvider().request(self) { (response) in
            switch response.result {
            case .success(let value):
                do {
                    let json = try value.mapSpiObject(T.self, designatedPath: designatedPath)
                    completion(.success(json))
                } catch(let error) {
                    if error is PGSpiError {
                        completion(.failure(error as! PGSpiError))
                    }
                    completion(.failure(PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(error))))
                }
            case .failure(let error):
                if error is PGSpiError {
                    completion(.failure(error as! PGSpiError))
                }
                completion(.failure(PGSpiError.requestException(exception: .networkException(nil))))
            }
        }
    }
    
    /// Objects
    ///
    /// - Parameters:
    ///   - designatedPath: 解析路径
    ///   - completion:
    public func responseSpiObjects<T: HandyJSON>(designatedPath: String? = nil, completion: @escaping (_ result: Result<[T], PGSpiError>) -> Void) -> Void {
        asProvider().request(self) { (response) in
            switch response.result {
            case .success(let value):
                do {
                    let json = try value.mapSpiObjects(T.self, designatedPath: designatedPath)
                    completion(.success(json))
                } catch(let error) {
                    if error is PGSpiError {
                        completion(.failure(error as! PGSpiError))
                    }
                    completion(.failure(PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(error))))
                }
            case .failure(let error):
                if error is PGSpiError {
                    completion(.failure(error as! PGSpiError))
                }
                completion(.failure(PGSpiError.requestException(exception: .networkException(nil))))
            }
        }
    }
}
