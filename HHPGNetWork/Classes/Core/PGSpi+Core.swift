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
    
    /// JSON(未处理)
    ///
    /// - Parameter completion:
    func responseJSON(completion: @escaping (_ result: Result<Any, PGSpiError>) -> Void) {
        asProvider().request(self) { (response) in
            switch response.result {
            case .success(let value):
                do {
                    let json = try value.JSON()
                    completion(.success(json))
                } catch(let error) {
                    if error is PGSpiError {
                        completion(.failure(error as! PGSpiError))
                    }
                    else {
                        completion(.failure(PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(error))))
                    }
                    
                }
            case .failure(let error):
                completion(.failure(PGSpiError.requestException(exception: .networkException(error))))
            }
        }
    }
    /// JSON
    ///
    /// - Parameter completion:
    func responseSpiJSON(completion: @escaping (_ result: Result<Any, PGSpiError>) -> Void) {
        asProvider().request(self) { (response) in
            switch response.result {
            case .success(let value):
                do {
                    let json = try value.mapSpiJSON()
                    completion(.success(json))
                } catch(let error) {
                    if error is PGSpiError {
                        completion(.failure(error as! PGSpiError))
                    }
                    else {
                        completion(.failure(PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(error))))
                    }                }
            case .failure(let error):
                completion(.failure(PGSpiError.requestException(exception: .networkException(error))))
            }
        }
    }
    
    /// Object
    ///
    /// - Parameters:
    ///   - designatedPath: 解析路径
    ///   - completion:
    func responseSpiObject<T: HandyJSON>(designatedPath: String? = nil, completion: @escaping (_ result: Result<T, PGSpiError>) -> Void) -> Void {
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
                    else {
                        completion(.failure(PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(error))))
                    }
                }
            case .failure(let error):
                completion(.failure(PGSpiError.requestException(exception: .networkException(error))))
            }
        }
    }
    
    /// Objects
    ///
    /// - Parameters:
    ///   - designatedPath: 解析路径
    ///   - completion:
    func responseSpiObjects<T: HandyJSON>(designatedPath: String? = nil, completion: @escaping (_ result: Result<[T], PGSpiError>) -> Void) -> Void {
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
                    else {
                        completion(.failure(PGSpiError.responseSerializationException(exception: .jsonSerializationFailed(error))))
                    }
                    
                }
            case .failure(let error):
                completion(.failure(PGSpiError.requestException(exception: .networkException(error))))
            }
        }
    }
}
