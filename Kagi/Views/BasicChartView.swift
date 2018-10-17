//
//  BasicChartView.swift
//  Kagi
//
//  Created by Luke Campbell on 7/22/18.
//  Copyright © 2018 Lucas Campbell. All rights reserved.
//

import UIKit

class BasicChartView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var title: UILabel!
    
    override func draw(_ rect: CGRect) {
        NSLog("Drawing")
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.addEllipse(in: rect)
        context.setFillColor(UIColor.red.cgColor)
        context.fillPath()
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSLog("Instantiating BasicChartView with a decoder")
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLog("Instantiating BasicChartView with frame")
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "BasicChartView", bundle:nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = frame
        addSubview(contentView)
    }
    
    func setTitle(_ title: String) {
        self.title.text = title
    }

}
