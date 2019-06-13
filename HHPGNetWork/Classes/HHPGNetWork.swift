//
//  HHPGNetWork.swift
//  Alamofire
//
//  Created by ios on 2019/6/13.
//

import UIKit

public class HHPGNetWork {
    /// 网络 地址
    public static var baseUrl: [String] = [""]
    /// true 表示debug模式，打印日志
    public static var isDebug: Bool = true
    /// Response 状态 Key
    public static var statusKey: String = "status"
    /// Response 数据 Key
    public static var dataKey: String = "data"
    /// Response 成功状态码
    public static var successCode: Int = 0
}

/// 网络地址管理
public class UrlManager {
    public static var shareInstance: UrlManager {
        struct Static {
            static let instance: UrlManager = UrlManager()
        }
        return Static.instance
    }
    
    /// 重试次数
    public var repeatNum: Int = 2
    
    /// 轮询次数
    public var retryNum: Int {
        get {
            return self.repeatNum * self.urlArr.count
        }
    }
    /// 地址数组
    private var urlArr:[String] = HHPGNetWork.baseUrl
    /// 当前数组位置
    private var index:Int = 0
    /// 基础地址
    public var baseUrl:String{
        get{
            if self.urlArr.count > 0 {
                return self.urlArr[self.index%self.urlArr.count]
            }else{
                return ""
            }
        }
    }
    func getNext() {
        if self.index < self.urlArr.count * self.repeatNum {
            self.index = self.index + 1
        }else{
            self.index = 0
        }
    }
}
