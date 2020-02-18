//
//  ViewController.swift
//  Minillq.imageMatting
//
//  Created by 古智鹏 on 2020/2/17.
//  Copyright © 2020 古智鹏. All rights reserved.
//

import UIKit
import SnapKit
import TZImagePickerController
import Alamofire
import SwiftyJSON
import SDWebImage
import Toolkit

class ViewController: UIViewController {
    
    var uuid = NSUUID().uuidString
    
    lazy var selectedButton: UIButton = {
        var button = UIButton()
        button.addTarget(self, action: #selector(selectedPicture), for: .touchUpInside)
        button.setTitle("selecte photo", for: .normal)
        button.backgroundColor = UIColor.gray
        return button
    }()
    
    let imageView = UIImageView()
    
    let changeColorButton = UIButton()
    
    var defaultBody: [String: Any] {
        var body:[String: Any] = [
            "app_version":"1.0.8",
            "channel":"0",
            "device_name":UIDevice.current.name,
            "devtype":"iPhone12,1",
            "extName":"png",
            "ischarging":"0",
            "issiminstalled":"1",
            "network_type":"4G",
            "package_name":"Zuimeizhjzios.com",
            "product_type":"2001",
            "sysname":UIDevice.version(),
            "uuid":uuid,
            "uid":"",
            "package_name":"",
            "wifiname":"",
        ]
        
        return body
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(selectedButton)
        view.addSubview(changeColorButton)
        selectedButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        
        changeColorButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.top.equalTo(selectedButton.snp.bottom).offset(8)
        }
        
        changeColorButton.setTitle("修改背景色", for: .normal)
        self.changeColorButton.isHidden = true
        
        changeColorButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        
        
        self.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(changeColorButton.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
        
        imageView.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
    }


}

extension ViewController {
    
    
    @objc func changeColor() {
        self.imageView.backgroundColor = .red
    }
    
    @objc func selectedPicture() {
        
        guard let vc = TZImagePickerController(maxImagesCount: 1, delegate: nil) else { return }
        
        vc.allowPickingVideo = false
        vc.allowTakeVideo = false
        vc.allowTakePicture = false
        
        vc.didFinishPickingPhotosHandle = { [weak self] images, _, _ in
            guard let `self` = self, var image = images?.first else { return }
            
            
            
            
            
            let w: CGFloat = 500
            let h = (image.size.height / image.size.width) * w
            image = image.aspectScaled(toFill: CGSize.init(width: w, height: h))
            
            
            let vaule = self.imageToBase64(image: image)
            
            
            // todo 修改"idfa":
            var body1:[String: Any] = [
                "idfa":"20DEE9AD-B896-4809-890E-41D59E5529B8",
                "app_version":"1.0.8",
                "extName":"png",
                "uuid":self.uuid,
                "toolscimg":vaule
            ]
            
            
            Alamofire.request("http://log.minillq.com/examine.php", method: HTTPMethod.post, parameters: body1, encoding: URLEncoding.httpBody, headers: nil).responseJSON {
                (DataResponse) in
                print(DataResponse)
                
                
                self.changeColorButton.isHidden = true
                self.imageView.backgroundColor = .clear
                self.imageView.image = nil
                self.selectedButton.setTitle("processing...", for: .normal)
                
                var body:[String: Any] = [
                    "extName":"png",
                    "uuid":self.uuid,
                    "pic":vaule,
                    "app_version":"1.0.8",
                    "channel":0,
                    "device_name":"古智鹏”的 iPhon333",
                    "ischarging":0,
                    "network_type":"4G",
                    "package_name":"Zuimeizhjzios.com",
                    "platform":"iOS",
                    "product_type":"2001",
                    
                    "sysname":"iOS-13.3.1",
                    "system_version":"13.3.1",
                    "uid":"",
                    "wifiname":""
                ]
                
                 
                
                Alamofire.request("http://beautifulphoto-api.minillq.com/BeautifulPhoto/split", method: HTTPMethod.post, parameters: body, encoding: URLEncoding.httpBody, headers: nil).responseJSON {    (DataResponse) in
                    
                    print(DataResponse.error)
                    print(DataResponse)
                    if let json = try? JSON.init(data: DataResponse.data!) {
                        let url = json["data"]["result"].stringValue
                        print(url)
                        self.imageView.sd_setImage(with: URL.init(string: url)) { (_, _, _, _) in
                            self.changeColorButton.isHidden = false
                            self.selectedButton.setTitle("selecte photo", for: .normal)
                        }
                        

                    }
                }
                
            }
            
            
            
            
            
        }
        
        
        self.present(vc, animated: true)
    }
}

extension ViewController {
    
    func imageToBase64(image: UIImage) -> String {
        
        let fileData = image.pngData()
        //将图片转为base64编码
        let base64 = fileData!.base64EncodedString(options: .endLineWithLineFeed)
        
        return base64
    }
}

