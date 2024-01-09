//
//  ViewController.swift
//  UniAppDemo
//
//  Created by ybdjk on 2024/1/9.
//

import UIKit

class ViewController: UIViewController {
    
    let appid = "__UNI__11E9B73"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DCUniMPSDKEngine.setDelegate(self)
        checkUniMPResource(appid: appid)
    }
    
    func checkUniMPResource(appid: String) {
        let wgtPath = Bundle.main.path(forResource: appid, ofType: "wgt")!
        if DCUniMPSDKEngine.isExistsUniMP(appid) {
            let version = DCUniMPSDKEngine.getUniMPVersionInfo(withAppid: appid)
            let name = version?["name"]
            let code = version?["code"]
            debugPrint("小程序\(appid)资源已存在,版本信息:name:\(name) code:\(code)")
        }else {
            do{
                try DCUniMPSDKEngine.installUniMPResource(withAppid: appid, resourceFilePath: wgtPath, password: nil)
                let version = DCUniMPSDKEngine.getUniMPVersionInfo(withAppid: appid)
                let name = version?["name"]
                let code = version?["code"]
                debugPrint("小程序\(appid)资源释放成功,版本信息:name:\(name) code:\(code)")
            }catch{
                debugPrint("小程序\(appid)资源释放失败:\(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func openUniMP() {
        let configuration = DCUniMPConfiguration()
        configuration.enableBackground =  true
        DCUniMPSDKEngine.openUniMP(appid, configuration: configuration) { instance, error in
            if error == nil {
                debugPrint("小程序打开成功")
            }else{
                debugPrint("小程序打开失败:\(error?.localizedDescription)")
            }
        }
    }

}

extension ViewController: DCUniMPSDKEngineDelegate {
    func uniMP(onClose appid: String) {
        debugPrint("小程序:\(appid) 已关闭")
    }
    
    func defaultMenuItemClicked(_ appid: String, identifier: String) {
        debugPrint("小程序按钮:\(appid) 当前ID:\(identifier)")
    }
    
    func splashView(forApp appid: String) -> UIView {
        SplashView()
    }
}

