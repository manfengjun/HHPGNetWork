//
//  ViewController.swift
//  YSHTTPSpider
//
//  Created by acct<blob>=<NULL> on 03/03/2019.
//  Copyright (c) 2019 acct<blob>=<NULL>. All rights reserved.
//

import UIKit
import HHPGNetWork
import Moya
import RxSwift
let disposeBag = DisposeBag()
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        let provider = MoyaProvider<Commons>()
//        provider.rx.request(Commons.getAllRegion).subscribe(onSuccess: { (response) in
//            print(response)
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        // 初始化 网络库设置
        SpiManager.config.setConfig(baseUrls: ["https://api.apiopen.top"],
                                    result_key: SpiRegKey(code: "code",
                                                          msg: "message",
                                                          data: "data",
                                                          success: 200))

        // 请求示例
        _ = Spi(Common.getAllRegion).sendRx().subscribe(onSuccess: { (response) in
            print(response)
        }, onError: { (error) in
            print(error.localizedDescription)
        })
        
//        subscribe(onSuccess: { (response) in
//            print(response.data)
//        }, onError: { (error) in
//            print(error.localizedDescription)
//        }).disposed(by: disposeBag)
        
        
        
//        mapRxSpiObjects(to: AppInfo.self).subscribe(onSuccess: { (value) in
//            print(value[0].toJSONString())
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        send { (response) in
//            switch response.result {
//            case .success(let value):
//                do {
//                    let repos = try value.mapJSON()
////                    print(repos[0].toJSONString())
//                } catch(let error) {
//                    print(error.localizedDescription)
//                }
//            case .failure(let error):
//                print(error.handle().message)
//            }
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Error {
    /// 错误信息处理
    ///
    /// - Returns:
    public func handle() -> (status: Int, message: String){
        guard let error = self as? SpiError else {
            return (-1, "服务器异常，请稍后再试!")
        }
        let status = error.status ?? -1
        let message = error.message ?? "服务器异常，请稍后再试!"
        return (status, message)
    }
}
