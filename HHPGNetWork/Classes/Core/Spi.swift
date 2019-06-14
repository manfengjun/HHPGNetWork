//
//  PGNetWorkApi.swift
//  Alamofire
//
//  Created by ios on 2019/6/13.
//

import UIKit
import Moya

public class Spi: NSObject {
    public let target: SpiTarget
    var parameters: [String: Any]?
    public init(_ target: SpiTarget){
        self.target = target
        parameters = target.parameters
    }
    public func asProvider() -> MoyaProvider<Spi> {
        let requestClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<Spi>.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                request.allowsCellularAccess = self.target.allowsCellularAccess
                request.timeoutInterval = self.target.timeoutInterval
                done(.success(request))
            } catch {
                return
            }
        }
        let provider = MoyaProvider<Spi>(requestClosure: requestClosure)
        return provider

    }
    //MARK: - 网络事件操作
    
    public func send(completion: @escaping Completion) {
        let provider = asProvider()
        provider.request(self, completion: completion)
    }
}
extension Spi: TargetType {
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var baseURL: URL {
        return try! target.asURL()
    }
    
    public var path: String {
        return target.path
    }
    
    public var method: Moya.Method {
        return target.method
    }
    
    public var headers: [String : String]? {
        return target.headers
    }
    
    public var task: Task {
        guard let parameters = parameters else { return .requestPlain }
        if method == .get {
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        } else {
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
