//
//  SettingViewController.swift
//  Kquotes
//
//  Created by Brandon Nguyen on 06/09/2024.
//

import UIKit
import BackgroundTasks

class SettingViewController: BaseViewController {
    @IBOutlet internal weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var arrowLeftImage: UIImageView!
    @IBOutlet weak var quoteScheduleTime: UIDatePicker!
    
    internal var settingViewModel: SettingViewModel? {
        return viewModel as? SettingViewModel
    }
    
    override func viewDidLoad() {
        
        arrowLeftImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(arrowLeftImageTouched(_:))))
        arrowLeftImage.isUserInteractionEnabled = true
        
        setupCollectionView()
        
        let leftAlignedLayout = LeftAlignedCollectionViewFlowLayout()
        leftAlignedLayout.minimumInteritemSpacing = 8
        leftAlignedLayout.minimumLineSpacing = 8
        leftAlignedLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        tagCollectionView.collectionViewLayout = leftAlignedLayout
        
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        
        setupQuoteScheduleTime()
    }
    
    private func setupQuoteScheduleTime() {
        if let scheduleTime = QuoteScheduleStorageImpl.shared.scheduleTime {
            quoteScheduleTime.date = scheduleTime
        }
        quoteScheduleTime.addTarget(self, action: #selector(scheduleTimeChanged(_:)), for: .editingDidEnd)
    }
    
    override func viewDidLayoutSubviews() {
        self.view.layoutIfNeeded()
        
        let tagCollectionContentHeight = tagCollectionView.contentSize.height
        if (tagCollectionContentHeight != 0) {
            tagCollectionViewHeight.constant = tagCollectionContentHeight
        }
    }
}

extension SettingViewController {
    @objc
    private func arrowLeftImageTouched(_ gestureRecognizer: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc 
    private func scheduleTimeChanged(_ sender: UIDatePicker) {
        QuoteScheduleStorageImpl.shared.scheduleTime = sender.date
        BackgroundTaskManager.shared.scheduleBackgroundTask()
    }
}
