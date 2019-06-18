//
//  Api+Common.swift
//  WTDistributorVersion
//
//  Created by ios on 2018/6/28.
//  Copyright © 2018年 ios. All rights reserved.
//
import UIKit
import Moya
import HHPGNetWork
enum Commons {
    // MARK: - 获取地址三级分类数据
    case getAllRegion
    
    
}
extension Commons : TargetType {
    var path: String {
        switch self {
        case .getAllRegion: return "/satinApi"
            
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    var baseURL: URL {
        return URL(string: "https://www.apiopen.top")!
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .getAllRegion:
            return .requestParameters(parameters: ["type":1,"page":1], encoding: URLEncoding.queryString)
        }
    }
    
}
