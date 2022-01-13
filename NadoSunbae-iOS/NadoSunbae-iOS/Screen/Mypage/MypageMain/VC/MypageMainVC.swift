//
//  MypageMainVC.swift
//  NadoSunbae-iOS
//
//  Created by 황지은 on 2022/01/05.
//

import UIKit

class MypageMainVC: UIViewController {

    // MARK: @IBOutlet

    // MARK: Properties

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: @IBAction
    @IBAction func goMypageUser(_ sender: UIButton) {
        guard let vc = UIStoryboard.init(name: MypageUserVC.className, bundle: nil).instantiateViewController(withIdentifier: MypageUserVC.className) as? MypageUserVC else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
