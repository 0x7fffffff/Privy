//
//  SettingsViewController.swift
//  Privy
//
//  Created by Michael MacCallum on 3/30/16.
//  Copyright © 2016 Michael MacCallum. All rights reserved.
//

import UIKit
import Former

final class SettingsViewController: FormViewController {
    lazy var fonts: [UIFont] = self.generateFonts()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: Private

    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)


    private func configure() {
        tableView.contentInset.top = 40
        tableView.contentInset.bottom = 40

        // Create RowFomers
        let previewRow = CustomRowFormer<PreviewCell>(instantiateType: .Nib(nibName: "PreviewCell")) {
            print($0)
//            $0.title = "Dynamic height"
//            $0.body = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
////            $0.bodyColor = colors[0]
            }.configure {
                $0.rowHeight = UITableViewAutomaticDimension
        }

        let fontPickingRow = InlinePickerRowFormer<FormInlinePickerCell, UIFont>(instantiateType: .Class) {
            $0.titleLabel.text = "Font"
            $0.titleLabel.textColor = UIColor.privyDarkBlueColor
            $0.titleLabel.font = .boldSystemFontOfSize(16)
//            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .boldSystemFontOfSize(14)
        }.configure {
            $0.pickerItems = fonts.map { font in
                let attributes = [
                    NSFontAttributeName: font
                ]

                let attributed = NSAttributedString(
                    string: font.fontName,
                    attributes: attributes
                )

                return InlinePickerItem(
                    title: font.fontName,
                    displayTitle: attributed,
                    value: font
                )
            }

            let defaults = NSUserDefaults.standardUserDefaults()

            if let fontName = defaults.objectForKey("userFontName") as? String,
                font = UIFont(name: fontName, size: UIFont.systemFontSize()) {
                $0.selectedRow = fonts.indexOf({ $0.fontName == font.fontName }) ?? 0
                print($0.selectedRow)
            } else {
                $0.selectedRow = 0
            }

            $0.displayEditingColor = UIColor.privyDarkBlueColor
        }.onValueChanged {
            previewRow.cell.fontName = $0.value?.fontName

            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject($0.value?.fontName, forKey: "userFontName")
            defaults.synchronize()
        }

        // Create Headers
        let createHeader: (String -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }

        let previewSection = SectionFormer(
            rowFormer: previewRow
        ).set(headerViewFormer: createHeader("Preview"))

        let fontSection = SectionFormer(
            rowFormer: fontPickingRow
        ).set(headerViewFormer: createHeader("Customize Your Card"))

        former.append(sectionFormer: previewSection, fontSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func generateFonts() -> [UIFont] {
        return UIFont.familyNames().flatMap {
            UIFont.fontNamesForFamilyName($0).flatMap {
                UIFont(name: $0, size: UIFont.systemFontSize())
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction private func dismiss(button: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction private func logout(button: UIBarButtonItem) {
        RequestManager.sharedManager.logout { success in
            LocalStorage.defaultStorage.saveHistory([HistoryUser]())
            dispatch_async(dispatch_get_main_queue()) {
                LocalStorage.defaultStorage.saveUser(nil, completion: { (error) in
                    dispatch_async(dispatch_get_main_queue()) {
                        PrivyUser.currentUser.registrationInformation = nil

                        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {

                        })
                    }
                })
            }
        }
    }
}
