//
//  ViewController.swift
//  RxNamer
//
//  Created by Bruce Burgess on 3/30/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class ViewController: UIViewController {
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var nameEntryTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var namesLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var namesArray: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    let defaultMessage = "Type your name below."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextField()
        bindSubmitButton()
    }
    
    func bindTextField() {
        nameEntryTextField.rx.text
  //          .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .map {
                if $0  == "" {
                    return self.defaultMessage
                } else {
                    return "Hello, \($0!)."
                }
            }
            .bind(to: helloLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindSubmitButton() {
        submitButton.rx.tap
            .subscribe(onNext: {
                if self.nameEntryTextField.text != "" {
                    self.namesArray.accept(self.namesArray.value + [self.nameEntryTextField.text!])
                    self.namesLabel.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                    self.nameEntryTextField.rx.text.onNext("")
                    self.helloLabel.rx.text.onNext(self.defaultMessage)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
}

