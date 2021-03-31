//
//  AddNameVC.swift
//  RxNamer
//
//  Created by Bruce Burgess on 3/31/21.
//

import UIKit
import RxSwift
import RxCocoa

class AddNameVC: UIViewController {
    @IBOutlet weak var newNameTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    let disposeBag = DisposeBag()
    let nameSubject = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSubmitButton()
    }
    
    func bindSubmitButton() {
        submitButton.rx.tap
            .subscribe(onNext: {
                if self.newNameTextField.text != "" {
                    self.nameSubject.onNext(self.newNameTextField.text!)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
}
