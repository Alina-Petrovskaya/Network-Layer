//
//  ViewController.swift
//  Petwalk_Network_Layer
//
//  Created by Alina Petrovskaya on 30.09.2021.
//

import UIKit
import KeychainSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    var networkManager: NetworkManager<TestEndpoint>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = UIImage(systemName: "person")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Token \(KeychainSwift().get(KeyChainKeysConstant.token.rawValue))")
        getRequest()
        //        postRequest()
        //        prepareAuth()
    }
    
    func prepareAuth() {
        let assetModel = UserAssetsModel(email: "test@test.com", password: "test")
        let authData = Authorisation(assetModel: assetModel) { data in
            let model = try? data.decode(with: TokenModel.self)
            print("New Token \(model?.data.token))")
            return model?.data.token
        }
        networkManager = NetworkManager<TestEndpoint>(authService: authData)
        networkManager?.request(.auth) { data, responce, error in
        }
    }
    
    func getRequest() {
        let tokenService = AuthTokenService { data in
            let model = try? data.decode(with: TokenModel.self)
            print("New Token \(model?.data.token))")
            return model?.data.token
        }
        
        networkManager = NetworkManager<TestEndpoint>(authService: tokenService)
        networkManager?.request(.getData) { data, responce, error in
        }
    }
    
    func postRequest() {

        let tokenService = AuthTokenService { data in
            let model = try? data.decode(with: TokenModel.self)
            print("New Token \(model?.data.token))")
            return model?.data.token
        }
        
        networkManager = NetworkManager<TestEndpoint>(authService: tokenService)
        let uploadModel = UploadDataModel(name: "image",
                                          mimeType: .imageJpeg,
                                          fileName: "profileImage",
                                          fileData: (image.image?.jpegData(compressionQuality: 0.5))!)
        
        networkManager?
            .request(.postImage(userID: 1,
                                parameters: nil,
                                media: [uploadModel])) { data, response, error in
                
            }
    }
    
}





