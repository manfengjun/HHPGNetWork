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
import RxCocoa
let disposeBag = DisposeBag()

class ViewController: UIViewController {
    @IBOutlet weak var login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化 网络库设置
        PGSpiManager.config.setConfig(baseUrls: ["http://v.juhe.cn/toutiao"],
                                    result_key: PGSpiRegKey(code: "code",
                                                          msg: "message",
                                                          data: "data",
                                                          success: 200))

        // RxSwift请求示例
        login.rx.tap.asDriver().flatMap { _ in PGSpi(Common.getAllRegion).driver()}.mapSpiObjects(to: AppInfo.self).drive(onNext: { (response) in
            switch response {
            case .success(let success):
                print(success.count)
            case .failure(let error):
                print(error.message ?? "")
            }
        }, onCompleted: {
            print("234234")
        }).disposed(by: disposeBag)
        
//        PGSpi(Common.getAllRegion).observable().mapSpiObjects(to: AppInfo.self).subscribe(onNext: { (response) in
//            switch response {
//            case .success(let success):
//                print(success.count)
//            case .failure(let error):
//                print(error.message ?? "")
//            }
//        })
        
//        mapSpiObjects(to: AppInfo.self).subscribe(onSuccess: { (value) in
//            print(value)
//        }) { (error) in
//            print(error.localizedDescription)
//        }.disposed(by: disposeBag)
        
//        // 流请求示例
//        PGSpi(Common.getAllRegion).responseSpiObjects { (response:Result<[AppInfo], PGSpiError>) in
//            switch response {
//            case .success(let value):
//                print(value.count)
//            case .failure(let error):
//                print(error.message ?? "")
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
        guard let error = self as? PGSpiError else {
            return (-1, "服务器异常，请稍后再试!")
        }
        let status = error.status ?? -1
        let message = error.message ?? "服务器异常，请稍后再试!"
        return (status, message)
    }
}
