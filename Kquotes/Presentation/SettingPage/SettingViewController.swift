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
    @IBOutlet weak var scheduleDescription: UILabel!
    
    internal var settingViewModel: SettingViewModel? {
        return viewModel as? SettingViewModel
    }
    
    private var needsToCheckNotificationPermission = false
    private var tempScheduleTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        setScheduleDescription()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func setupQuoteScheduleTime() {
        if let scheduleTime = QuoteScheduleStorageImpl.shared.scheduleTime {
            quoteScheduleTime.date = scheduleTime
        }
        quoteScheduleTime.addTarget(self, action: #selector(scheduleTimeChanged(_:)), for: .editingDidEnd)
    }
    
    private func setScheduleDescription() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        if let scheduleTime = QuoteScheduleStorageImpl.shared.scheduleTime {
            let formattedTime = dateFormatter.string(from: scheduleTime)
            scheduleDescription.text = "Schedule is set for \(formattedTime). You will receive a new quote daily!"
        } else {
            scheduleDescription.text = "Schedule time is not set. Please select a time to receive your daily quote."
        }
        
        scheduleDescription.text! += "\n\nPlease note: The actual delivery time may vary slightly due to iOS system optimizations."
    }
    
    override func viewDidLayoutSubviews() {
        self.view.layoutIfNeeded()
        
        let tagCollectionContentHeight = tagCollectionView.contentSize.height
        if (tagCollectionContentHeight != 0) {
            tagCollectionViewHeight.constant = tagCollectionContentHeight
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SettingViewController {
    @objc
    private func arrowLeftImageTouched(_ gestureRecognizer: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc 
    private func scheduleTimeChanged(_ sender: UIDatePicker) {
        tempScheduleTime = sender.date
        checkNotificationPermissionAndScheduleTask()
    }
    
    @objc 
    private func appDidBecomeActive() {
        if needsToCheckNotificationPermission {
            needsToCheckNotificationPermission = false
            checkNotificationPermissionAndScheduleTask()
        }
    }
    
    private func checkNotificationPermissionAndScheduleTask() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional:
                    QuoteScheduleStorageImpl.shared.scheduleTime = self?.tempScheduleTime
                    BackgroundTaskManager.shared.scheduleBackgroundTask()
                    self?.setScheduleDescription()
                case .denied:
                    self?.showNotificationPermissionAlert()
                case .notDetermined:
                    self?.requestNotificationPermission()
                case .ephemeral:
                    self?.requestNotificationPermission()
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func showNotificationPermissionAlert() {
        let alert = UIAlertController(
            title: "Notification Permission Required",
            message: "To receive daily quotes, please enable notifications in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            self.needsToCheckNotificationPermission = true
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            DispatchQueue.main.async {
                if granted {
                    BackgroundTaskManager.shared.scheduleBackgroundTask()
                } else {
                    self?.showNotificationPermissionAlert()
                }
            }
        }
    }
}
