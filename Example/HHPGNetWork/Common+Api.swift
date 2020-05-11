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
enum Common {
    // MARK: - 获取地址三级分类数据
    case getAllRegion
    
    
}
extension Common : PGSpiTarget {
    var path: String {
        switch self {
        case .getAllRegion: return "/index"
            
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getAllRegion:
            return ["type":"top","key":"8093f06289133b469be6ff7ab6af1aa9"]
            
        }
    }
    
    var headers: [String: String]? {
        return [:]
    }
    var baseURL: String {
        return "https://v.juhe.cn/toutiao"
    }
    
    
}
