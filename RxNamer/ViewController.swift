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
    @IBOutlet weak var addNameButton: UIButton!
    
    let disposeBag = DisposeBag()
    var namesArray: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    let defaultMessage = "Type your name below."
    let addNameVCId = "AddNameVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextField()
        bindSubmitButton()
        bindAddNameButton()
        
        namesArray.asObservable()
            .subscribe(onNext: { names in
                self.namesLabel.text = names.joined(separator: ", ")
            })
            .disposed(by: disposeBag)
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
                    self.appendToNameArray(self.nameEntryTextField.text!)
                    self.namesLabel.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                    self.nameEntryTextField.rx.text.onNext("")
                    self.helloLabel.rx.text.onNext(self.defaultMessage)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func bindAddNameButton() {
        addNameButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                guard let addNameVC = self.storyboard?.instantiateViewController(identifier: self.addNameVCId) as? AddNameVC else {
                     fatalError("Could not creat AddNameVC") }
                addNameVC.nameSubject.subscribe(onNext: { name in
                    self.appendToNameArray(name)
                    addNameVC.dismiss(animated: true, completion: nil)
                })
                .disposed(by: self.disposeBag)
                self.present(addNameVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func appendToNameArray(_ name: String) {
        self.namesArray.accept(self.namesArray.value + [name])
    }
    
}

