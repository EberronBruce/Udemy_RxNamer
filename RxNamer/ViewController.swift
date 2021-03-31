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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        nameEntryTextField.rx.text
  //          .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .map {
                if $0  == "" {
                    return "Type your name below."
                } else {
                    return "Hello, \($0!)."
                }
            }
            .bind(to: helloLabel.rx.text)
            .disposed(by: disposeBag)
    }


}

