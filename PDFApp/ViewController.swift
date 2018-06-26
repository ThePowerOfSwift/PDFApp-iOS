//
//  ViewController.swift
//  PDFApp
//
//  Created by TakahashiNobuhiro on 2018/06/26.
//  Copyright © 2018 feb19. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pdfView.document = getDocument()
        
        pdfView.backgroundColor = .lightGray
//        pdfView.autoScales = true
        pdfView.displayMode = .twoUpContinuous
        pdfView.displayDirection = .horizontal
        pdfView.displaysAsBook = false
        pdfView.usePageViewController(true)
        
        createMenu()
    }
    
    func getDocument() -> PDFDocument? {
        guard let path = Bundle.main.path(forResource: "sample", ofType: "pdf") else {
            print("failed to get path.")
            return nil
        }
        let pdfURL = URL(fileURLWithPath: path)
        let document = PDFDocument(url: pdfURL)
        return document
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(highlight(_:)) {
            return true
        }
        return false
    }
    
    private func createMenu() {
        let highlightItem = UIMenuItem(title: "Highlight", action: #selector(highlight(_:)))
        UIMenuController.shared.menuItems = [highlightItem]
    }
    
    @objc private func highlight(_ sender: UIMenuController?) {
        guard let currentSelection = pdfView.currentSelection else { return }
        let selections = currentSelection.selectionsByLine()
        guard let page = selections.first?.pages.first else { return }
        
        selections.forEach { selection in
            let highlight = PDFAnnotation(bounds: selection.bounds(for: page), forType: .highlight, withProperties: nil)
            highlight.endLineStyle = .square
            page.addAnnotation(highlight)
        }
        
        pdfView.clearSelection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

