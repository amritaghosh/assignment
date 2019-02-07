//
//  SystemManager.swift
//  ETW
//
//  Created by Afshan Momin on 08/02/17.
//  Copyright © 2017 NessDigitalEngineering. All rights reserved.
//


import UIKit
import JWTDecode
import Firebase
import UserNotifications

let kAlertBarHeightSpacing: CGFloat                 =  0.0
let kStatusBarHeight: CGFloat                       =  20.0
let maximumCompletedListCount: Int                  =  20

typealias AlertBarDissmissCompletion = (Any?, NSError?) -> Swift.Void
class SystemManager: NSObject {
    
    static let sharedManager = SystemManager()
    
    var loadingView : UIView?
    var alertBar : UIView?
    
    var menuViewController: HamburgerMenuController?
    var addNoteViewController: AddNoteController?
    var addMessageViewController: AddMessageController?
    
    var channelIDArray:[String] = []
    
    var newActionItem: Int  =  0
    var pastDueDate:   Int  =  0
    var todayDueDate:  Int  =  0

    
    static var coreDataOpeartionQueue: OperationQueue = {
        let queue = OperationQueue()
        
        queue.name = "CoreData Opeartion Queue"
        
        return queue
    }()
    
    //operation queue for download the avatar image
    static var avatarOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "Avatar Operation Queue"
        
        return queue
    }()
    
    private override init() {
        super.init()
    } //This prevents others from using the default '()' initializer for this class.
    
    
    func isTouchIDEnabled() -> Bool {
        let touchIDEnabled = KeychainManager.sharedManager.readPassword().count > 0 ? true : false
        return touchIDEnabled
    }
    
    func isUserLoggedIn() -> Bool {
        guard let userLoggedIn = UserDefaults.standard.value(forKey: UserDefaultKeys.userLoggedIn) as? Bool else { return false }
        return userLoggedIn
    }
    
    func isTouchIDIntentEnabled() -> Bool {
        guard let isTouchIDIntentEnabled = UserDefaults.standard.value(forKey: UserDefaultKeys.touchIDIntentEnabled) as? Bool else { return false }
        return isTouchIDIntentEnabled
    }
    
    func isLaunchedBefore() -> Bool {
        guard let isLaunchedBefore = UserDefaults.standard.value(forKey: UserDefaultKeys.isLaunchedBefore) as? Bool else { return false }
        return isLaunchedBefore
    }
    
    func setUserIsLoggedIn(_ isLoggedIn: Bool) {
        UserDefaults.standard.set(isLoggedIn, forKey: UserDefaultKeys.userLoggedIn)
    }
    
    func setTouchIDIntentEnabled(_ isTouchIDIntentEnabled: Bool) {
        UserDefaults.standard.set(isTouchIDIntentEnabled, forKey: UserDefaultKeys.touchIDIntentEnabled)
    }
    
    func setUserFirstLaunch(_ isFirstLaunch: Bool) {
        UserDefaults.standard.set(isFirstLaunch, forKey: UserDefaultKeys.isLaunchedBefore)
    }

    func setPeopleSelectedFromHome(_ isSelected: Bool) {
        UserDefaults.standard.set(isSelected, forKey: UserDefaultKeys.peopleSelectedFromHome )
    }
    
    func isPeopleSelectedFromHome() -> Bool {
        guard let peopleProfileSelected = UserDefaults.standard.value(forKey: UserDefaultKeys.peopleSelectedFromHome) as? Bool else { return false }
        return peopleProfileSelected
    }
  
    func setPeopleProfileSelected(_ isSelected: Bool) {
        UserDefaults.standard.set(isSelected, forKey: UserDefaultKeys.peopleProfileSelected)
    }
   
    func isPeopleProfileSelected() -> Bool {
        guard let peopleProfileSelected = UserDefaults.standard.value(forKey: UserDefaultKeys.peopleProfileSelected) as? Bool else { return false }
        return peopleProfileSelected
    }

    func setPeopleProfileFullName(_ name: String) {
        UserDefaults.standard.set(name, forKey: UserDefaultKeys.peopleProfileFullName)
    }
    
    func getPeopleProfileFullName() -> String? {
        guard let peopleFullName = UserDefaults.standard.value(forKey: UserDefaultKeys.peopleProfileFullName) as? String else { return nil }
        return peopleFullName
    }
    
    func setPeopleProfileTitle(_ title: String) {
        UserDefaults.standard.set(title, forKey: UserDefaultKeys.peopleProfileTitle)
    }
    
    func getPeopleProfileTitle() -> String? {
        guard let PeopleProfileTitle = UserDefaults.standard.value(forKey: UserDefaultKeys.peopleProfileTitle) as? String else { return nil }
        return PeopleProfileTitle
    }

    func setPeopleProfileImage(_ profileImage: UIImage)  {
        UserDefaults.standard.set(UIImagePNGRepresentation(profileImage), forKey: UserDefaultKeys.peopleProfileImage)
    }

    func getPeopleProfileImage()  -> UIImage? {
        guard let peopleProfileImageData = UserDefaults.standard.value(forKey: UserDefaultKeys.peopleProfileImage) as? Data else { return nil }
        return UIImage(data: peopleProfileImageData)
    }

    
    func setSelectedPeopleID(_ peopleId: Int) {
        UserDefaults.standard.set(peopleId, forKey: UserDefaultKeys.selectedPeopleID)
    }
   
    func getSelectedPeopleID() -> Int? {
        guard let peopleId = UserDefaults.standard.value(forKey: UserDefaultKeys.selectedPeopleID) as? Int else { return nil }
        return peopleId
    }
    
   // MARK: - Return ID of the User
    func checkUserID() -> Int {
        var userID: Int = 0
        if SystemManager.sharedManager.isPeopleProfileSelected() {
            userID = SystemManager.sharedManager.getSelectedPeopleID()!
        } else {
            userID = KeychainManager.sharedManager.readUserID()
        }
        return userID
    }
    
    func checkUserPlanID(_ isFromPeopleProfile: Bool) -> Int {
        var userID: Int = 0
        if isFromPeopleProfile {
            userID = SystemManager.sharedManager.getSelectedPeopleID()!
        } else {
            userID = KeychainManager.sharedManager.readUserID()
        }
        return userID
    }
    
    
    func cleanupAndGoToLogin() {
        PushNotificationManager.sharedManager.tearDownPushNotifications()
        BadgeCountManager.sharedManager.clearBadgeCount()
        BadgeCountManager.sharedManager.clearBadgeCountMessage()
        BadgeCountManager.sharedManager.clearBadgeCountActionItem()
        self.clearActionItemBadgeValue()
        self.removeSelectedPeopleData()
        SystemManager.sharedManager.setPeopleProfileSelected(false)
        SystemManager.sharedManager.setPeopleSelectedFromHome(false)
        SystemManager.sharedManager.setUserIsLoggedIn(false)
        SystemManager.sharedManager.setInProgressAddReplyNote(false)
        SystemManager.sharedManager.setInProgressAddMessage(false)
        SystemManager.sharedManager.setIsPushNotificationReceived(false)
        SystemManager.sharedManager.setPublishedDateNotification("")
        SystemManager.sharedManager.setPushNotificationMessage(false)
        SystemManager.sharedManager.setPlanEnable(false)
        SystemManager.sharedManager.cleanup()
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.clearNotification()
        self.removePreferencePushNotificationMessgaeDictionary()
        AppDelegate.shared.gotoLoginScreen()
    }
    
    func clearNotification()  {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
        }
    }
    
    func removePreference() {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey:UserDefaultKeys.onlinePresenceChannels)
    }
    
    func removePreferencePushNotificationMessgaeDictionary() {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey:UserDefaultKeys.pushNotificationMessgaeDictionary)
    }
    
    func removePreferencePushNotificationActionItemDictionary() {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey:UserDefaultKeys.pushNotificationActionItemDictionary)
    }

    
    func removePushNotificationMessgaeDictionary() {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey:UserDefaultKeys.pushNotificationMessgaeDictionary)
    }
    
    func removeSelectedPeopleData() {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey:UserDefaultKeys.peopleProfileFullName)
        prefs.removeObject(forKey:UserDefaultKeys.peopleProfileImage)
        prefs.removeObject(forKey:UserDefaultKeys.selectedPeopleID)
    }

    
    func cleanActionItemDataBase() {
        DataUtilities.sharedManager.deleteActionItemLists()
        DataUtilities.sharedManager.deleteCompletedActionItemList()
        DataUtilities.sharedManager.deleteGoalActionItemLists()
        DataUtilities.sharedManager.deleteGoalCompletedActionItemList()
        DataUtilities.sharedManager.deleteActionItemDetails()
        DataUtilities.sharedManager.deleteGoalActionItemProfileImage()
        DataUtilities.sharedManager.deleteGoals()
        
        DataUtilities.sharedManager.deletePinnedPlans()
        DataUtilities.sharedManager.deleteKPIPinnedPlans()
        DataUtilities.sharedManager.deleteDataSeriesPinnedPlans()
    }
    
    // User Profile
    
    func setActiveUserAccountName(_ accountName: String?) {
        if let accountNameString = accountName {
            UserDefaults.standard.set(accountNameString, forKey: UserDefaultKeys.userAccountName)
        } else {
            UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userAccountName)
        }
    }
    
    func setUserAlias(_ alias: String) {
        UserDefaults.standard.set(alias, forKey: UserDefaultKeys.userAlias)
    }
    
    func setUserFirstName(_ firstName: String) {
        UserDefaults.standard.set(firstName, forKey: UserDefaultKeys.userFirstName)
    }
    
    func setUserLastName(_ lastName: String) {
        UserDefaults.standard.set(lastName, forKey: UserDefaultKeys.userLastName)
    }
    
    func setUserTitle(_ title: String)  {
        UserDefaults.standard.set(title, forKey: UserDefaultKeys.userTitle)
    }
    
    func setMaxKPI(_ maxKPIValue: String) {
        UserDefaults.standard.set(maxKPIValue, forKey: UserDefaultKeys.maxKPI)
    }
    
    func setUserInfoFetched(_ isUserInfoFetch: Bool) {
        UserDefaults.standard.set(isUserInfoFetch, forKey: UserDefaultKeys.isUserInfoFetched)
    }
    
    func setIsFetchingImage(_ isUserImageFetch: Bool) {
        UserDefaults.standard.set(isUserImageFetch, forKey: UserDefaultKeys.isFetchingUserImage)
    }
    
    func setIsUserImageFetched(_ isUserImageFetched: Bool) {
        UserDefaults.standard.set(isUserImageFetched, forKey: UserDefaultKeys.isUserImageFetched)
    }
    
    func setUserProfileImage(_ profileImage: UIImage)  {
        UserDefaults.standard.set(UIImagePNGRepresentation(profileImage), forKey: UserDefaultKeys.userProfileImage)
    }
    
    func setNotificationChannels(_ notificationChannels: [String]) {
        UserDefaults.standard.set(notificationChannels, forKey: UserDefaultKeys.notificationChannels)
    }
    
    func setOnlinePresenceChannels(_ onlinePresenceChannels: [String]) {
        UserDefaults.standard.set(onlinePresenceChannels, forKey: UserDefaultKeys.onlinePresenceChannels)
    }
    
    func setMembershipChannels(_ membershipChannels: [String]) {
        UserDefaults.standard.set(membershipChannels, forKey: UserDefaultKeys.membershipChannels)
    }
    
    
    func setAddReplyNoteDictionary(_ addReplyNoteDictionary: Dictionary<String, Any>) {
        UserDefaults.standard.set(addReplyNoteDictionary, forKey: UserDefaultKeys.addReplyNote)
    }
    
    func setAddMessageDictionary(_ addMessageDictionary: Dictionary<String, Any>) {
        UserDefaults.standard.set(addMessageDictionary, forKey: UserDefaultKeys.addMessageDictionary)
    }
    
    func setPushNotificationMessgaeDictionary(_ pushNotificationMessageDictionary: Dictionary<String, Any>) {
        UserDefaults.standard.set(pushNotificationMessageDictionary, forKey: UserDefaultKeys.pushNotificationMessgaeDictionary)
    }
    
    func setPushNotificationActionItemDictionary(_ pushNotificationActionItemDictionary: Dictionary<String, Any>) {
        UserDefaults.standard.set(pushNotificationActionItemDictionary, forKey: UserDefaultKeys.pushNotificationActionItemDictionary)
    }

    
    func setPushNotificationMessgaeDictionaryArray(_ pushNotificationMessageDictionaryArray: [Dictionary<String, Any>]) {
        UserDefaults.standard.set(pushNotificationMessageDictionaryArray, forKey: UserDefaultKeys.pushNotificationMessgaeDictionaryArray)
    }
    
    func setPushNotificationActionItemDictionaryArray(_ pushNotificationActionItemDictionaryArray: [Dictionary<String, Any>]) {
        UserDefaults.standard.set(pushNotificationActionItemDictionaryArray, forKey: UserDefaultKeys.pushNotificationActionItemDictionaryArray)
    }

    
    func setLoginDictionaryArray(_ loginDictionaryArray: [Dictionary<String, Any>]) {
        UserDefaults.standard.set(loginDictionaryArray, forKey: UserDefaultKeys.loginDictionaryArray)
    }
    
    func getPushNotificationMessgaeDictionaryArray()  -> [Dictionary<String, Any>]? {
        guard let messageDictionaryArray = UserDefaults.standard.value(forKey: UserDefaultKeys.pushNotificationMessgaeDictionaryArray) as? [Dictionary<String, Any>] else { return nil }
        return messageDictionaryArray
    }
    
    func getPushNotificationActionItemDictionaryArray()  -> [Dictionary<String, Any>]? {
        guard let actionItemDictionaryArray = UserDefaults.standard.value(forKey: UserDefaultKeys.pushNotificationActionItemDictionaryArray) as? [Dictionary<String, Any>] else { return nil }
        return actionItemDictionaryArray
    }

    
    func getLoginDictionaryArray()  -> [Dictionary<String, Any>]? {
        guard let loginDictionaryArray = UserDefaults.standard.value(forKey: UserDefaultKeys.loginDictionaryArray) as? [Dictionary<String, Any>] else { return nil }
        return loginDictionaryArray
    }
    
    func setInProgressAddReplyNote(_ inProgressAddReplyNote: Bool) {
        UserDefaults.standard.set(inProgressAddReplyNote, forKey: UserDefaultKeys.inProgressAddReplyNote)
    }
    
    func setInProgressAddMessage(_ inProgressAddMessage: Bool) {
        UserDefaults.standard.set(inProgressAddMessage, forKey: UserDefaultKeys.inProgressAddMessage)
    }
    
    func setIsInDirectRoom(_ isInDirectRoom: Bool) {
        UserDefaults.standard.set(isInDirectRoom, forKey: UserDefaultKeys.isInDirectRoom)
    }
    
    func setUserID(_ userIDs: [Int32]) {
        UserDefaults.standard.set(userIDs, forKey: UserDefaultKeys.setUserId)
    }
    
    
    
    func setAddNoteInAccessoryView(_ isAddNoteInAccessoryView: Bool) {
        UserDefaults.standard.set(isAddNoteInAccessoryView, forKey: UserDefaultKeys.addNoteInAccessoryView)
    }
    
    func setReplyNoteInAccessoryView(_ isReplyNoteInAccessoryView: Bool) {
        UserDefaults.standard.set(isReplyNoteInAccessoryView, forKey: UserDefaultKeys.replyNoteInAccessoryView)
    }
    
    func setAddMessageInAccessoryView(_ isAddMessageInAccessoryView: Bool) {
        UserDefaults.standard.set(isAddMessageInAccessoryView, forKey: UserDefaultKeys.addMessageInAccessoryView)
    }
    
    
    func setGoalNoteInDB(_ isGoalNoteAvailableInDB: Bool) {
        UserDefaults.standard.set(isGoalNoteAvailableInDB, forKey: UserDefaultKeys.goalNoteAvailableInDB)
    }
    
    func setIsPushNotificationReceived(_ isPushNotificationReceived: Bool) {
        UserDefaults.standard.set(isPushNotificationReceived, forKey: UserDefaultKeys.isPushNotificationReceived)
    }
    
    func setBudgeCountMessage(_ budgeCountMessage: Int32) {
        UserDefaults.standard.set(budgeCountMessage, forKey: UserDefaultKeys.budgeCountMessage)
    }
    
    func setBudgeCountActionItem(_ budgeCountActionItem: Int32) {
        UserDefaults.standard.set(budgeCountActionItem, forKey: UserDefaultKeys.budgeCountActionItem)
    }

    
    func setPublishedDateNotification(_ publishedDate: String) {
        UserDefaults.standard.set(publishedDate, forKey: UserDefaultKeys.publishedDateNotification)
    }
    
    func setPubNubNewChannel(_ newChannel: String) {
        UserDefaults.standard.set(newChannel, forKey: UserDefaultKeys.pubNubNewChannelNotification)
    }
    
    func setOnlineCheck(_ onlinePresenceChannels: [String]) {
        UserDefaults.standard.set(onlinePresenceChannels, forKey: UserDefaultKeys.onlineCheck)
    }
    
    func setPushNotificationMessage(_ isPushNotificationReceivedMessage: Bool) {
        UserDefaults.standard.set(isPushNotificationReceivedMessage, forKey: UserDefaultKeys.pushNotificationMessage)
    }
    
    func setPushNotificationActionItem(_ isPushNotificationReceivedActionItem: Bool) {
        UserDefaults.standard.set(isPushNotificationReceivedActionItem, forKey: UserDefaultKeys.pushNotificationActionItem)
    }

    
    func setRefreshTokenExpTime(_ expTime: Date) {
        UserDefaults.standard.set(expTime, forKey: UserDefaultKeys.refreshTokenExpTime)
    }
    
    func getRefreshTokenExpTime() -> Date? {
        guard let expTime = UserDefaults.standard.value(forKey: UserDefaultKeys.refreshTokenExpTime) as? Date else { return nil }
        return expTime
    }
    
    
    func setPushNotificationReceiveFromMessage(_ isPushNotificationReceivedFromMessage: Bool) {
        UserDefaults.standard.set(isPushNotificationReceivedFromMessage, forKey: UserDefaultKeys.pushNotificationReceiveFromMessage)
    }
  
    func setPushNotificationReceiveFromActionItem(_ isPushNotificationReceivedFromActionItem: Bool) {
        UserDefaults.standard.set(isPushNotificationReceivedFromActionItem, forKey: UserDefaultKeys.pushNotificationReceiveFromActionItem)
    }

    
    func setPlanEnable(_ isPlanEnable: Bool) {
        UserDefaults.standard.set(isPlanEnable, forKey: UserDefaultKeys.planEnable)
    }
    
    func getOnlineCheck()  -> [String]? {
        guard let onlinePresenceChannels = UserDefaults.standard.value(forKey: UserDefaultKeys.onlineCheck) as? [String] else { return nil }
        return onlinePresenceChannels
    }
    
    
    func getPubNubNewChannel() -> String? {
        guard let newChannel = UserDefaults.standard.value(forKey: UserDefaultKeys.pubNubNewChannelNotification) as? String else { return nil }
        return newChannel
    }
    
    
    func getPublishedDateNotification() -> String? {
        guard let userPublishedDateNotification = UserDefaults.standard.value(forKey: UserDefaultKeys.publishedDateNotification) as? String else { return nil }
        return userPublishedDateNotification
    }
    
    func getBudgeCountMessage() -> Int32? {
        guard let budgeCount = UserDefaults.standard.value(forKey: UserDefaultKeys.budgeCountMessage) as? Int32 else { return nil }
        return budgeCount
    }
    
    func getBudgeCountActionItem() -> Int32? {
        guard let budgeCount = UserDefaults.standard.value(forKey: UserDefaultKeys.budgeCountActionItem) as? Int32 else { return nil }
        return budgeCount
    }
    
    func getUserID() -> [Int32]? {
        guard let userID = UserDefaults.standard.value(forKey: UserDefaultKeys.setUserId) as? [Int32] else { return nil }
        return userID
    }
    
    func getUserAlias() -> String? {
        guard let userAlias = UserDefaults.standard.value(forKey: UserDefaultKeys.userAlias) as? String else { return nil }
        return userAlias
    }
    
    func getUserFirstName() -> String? {
        guard let userFirstName = UserDefaults.standard.value(forKey: UserDefaultKeys.userFirstName) as? String else { return nil }
        return userFirstName
    }
    
    func getActiveUserAccountName() -> String? {
        guard let userAccountName = UserDefaults.standard.value(forKey: UserDefaultKeys.userAccountName) as? String else { return nil }
        return userAccountName
    }
    
    func getUserLastName() -> String? {
        guard let userLastName = UserDefaults.standard.value(forKey: UserDefaultKeys.userLastName) as? String else { return nil }
        return userLastName
    }
    
    func getUserTitle()  -> String? {
        guard let userTitle = UserDefaults.standard.value(forKey: UserDefaultKeys.userTitle) as? String else { return nil }
        return userTitle
    }
    
    func getMaxKPI()  -> String? {
        guard let maxKPIValue = UserDefaults.standard.value(forKey: UserDefaultKeys.maxKPI) as? String else { return nil }
        return maxKPIValue
    }
    
    func getUserProfileImage()  -> UIImage? {
        guard let userProfileImageData = UserDefaults.standard.value(forKey: UserDefaultKeys.userProfileImage) as? Data else { return nil }
        return UIImage(data: userProfileImageData)
    }
    
    func isUserInfoFetched() -> Bool {
        guard let userInfoFetched = UserDefaults.standard.value(forKey: UserDefaultKeys.isUserInfoFetched) as? Bool else { return false }
        return userInfoFetched
    }
    
    func isFetchingImage() -> Bool {
        guard let fetchingUserImage = UserDefaults.standard.value(forKey: UserDefaultKeys.isFetchingUserImage) as? Bool else { return false }
        return fetchingUserImage
    }
    
    func isUserImageFetched() -> Bool {
        guard let userImageFetched = UserDefaults.standard.value(forKey: UserDefaultKeys.isUserImageFetched) as? Bool else { return false }
        return userImageFetched
    }
    
    func getNotificationChannels()  -> [String]? {
        guard let notificationChannels = UserDefaults.standard.value(forKey: UserDefaultKeys.notificationChannels) as? [String] else { return nil }
        return notificationChannels
    }
    
    func getMembershipChannels()  -> [String]? {
        guard let membershipChannels = UserDefaults.standard.value(forKey: UserDefaultKeys.membershipChannels) as? [String] else { return nil }
        return membershipChannels
    }
    
    func getOnlinePresenceChannels()  -> [String]? {
        guard let onlinePresenceChannels = UserDefaults.standard.value(forKey: UserDefaultKeys.onlinePresenceChannels) as? [String] else { return nil }
        return onlinePresenceChannels
    }
    
    
    func getAddReplyNoteDictionary()  -> Dictionary<String, Any>?  {
        guard let noteDictionary = UserDefaults.standard.value(forKey: UserDefaultKeys.addReplyNote) as? Dictionary<String, Any> else { return nil }
        return noteDictionary
        
    }
    
    func getAddMessageDictionary()  -> Dictionary<String, Any>?  {
        guard let messageDictionary = UserDefaults.standard.value(forKey: UserDefaultKeys.addMessageDictionary) as? Dictionary<String, Any> else { return nil }
        return messageDictionary
    }
    
    func getPushNotificationMessgaeDictionary()  -> Dictionary<String, Any>? {
        guard let messageDictionary = UserDefaults.standard.value(forKey: UserDefaultKeys.pushNotificationMessgaeDictionary) as? Dictionary<String, Any> else { return nil }
        return messageDictionary
    }
    
    func getPushNotificationActionItemDictionary()  -> Dictionary<String, Any>? {
        guard let actionItemDictionary = UserDefaults.standard.value(forKey: UserDefaultKeys.pushNotificationActionItemDictionary) as? Dictionary<String, Any> else { return nil }
        return actionItemDictionary
    }

    
    
    
    func inProgressAddReplyNote() -> Bool {
        guard let progressAddReplyNote = UserDefaults.standard.value(forKey: UserDefaultKeys.inProgressAddReplyNote) as? Bool else { return false }
        return progressAddReplyNote
    }
    
    func inProgressAddMessage() -> Bool {
        guard let progressAddMessage = UserDefaults.standard.value(forKey: UserDefaultKeys.inProgressAddMessage) as? Bool else { return false }
        return progressAddMessage
    }
    
    func isAddNoteInAccessoryView() -> Bool {
        guard let addNoteInAccessoryView = UserDefaults.standard.value(forKey: UserDefaultKeys.addNoteInAccessoryView) as? Bool else { return false }
        return addNoteInAccessoryView
    }
    
    func isReplyNoteInAccessoryView() -> Bool {
        guard let replyNoteInAccessoryView = UserDefaults.standard.value(forKey: UserDefaultKeys.replyNoteInAccessoryView) as? Bool else { return false }
        return replyNoteInAccessoryView
    }
    
    func isAddMessageInAccessoryView() -> Bool {
        guard let addMessageInAccessoryView = UserDefaults.standard.value(forKey: UserDefaultKeys.addMessageInAccessoryView) as? Bool else { return false }
        return addMessageInAccessoryView
    }
    
    
    func isGoalNoteAvailableInDB() -> Bool {
        guard let goalNoteAvailableInDB = UserDefaults.standard.value(forKey: UserDefaultKeys.goalNoteAvailableInDB) as? Bool else { return false }
        return goalNoteAvailableInDB
    }
    
    func isPushNotificationReceived() -> Bool {
        guard let isReceivedPushNotification = UserDefaults.standard.value(forKey: UserDefaultKeys.isPushNotificationReceived) as? Bool else { return false }
        return isReceivedPushNotification
    }
    
    func isPushNotificationReceivedMessage() -> Bool {
        guard let isReceivedPushNotificationMessage = UserDefaults.standard.value(forKey: UserDefaultKeys.pushNotificationMessage) as? Bool else { return false }
        return isReceivedPushNotificationMessage
    }
    
    func isPushNotificationReceivedActionItem() -> Bool {
        guard let isReceivedPushNotificationActionItem = UserDefaults.standard.value(forKey: UserDefaultKeys.pushNotificationActionItem) as? Bool else { return false }
        return isReceivedPushNotificationActionItem
    }

    
    func isPushNotificationReceiveFromMessage() -> Bool {
        guard let isPushNotificationReceivedFromMessage = UserDefaults.standard.value(forKey: UserDefaultKeys.pushNotificationReceiveFromMessage) as? Bool else { return false }
        return isPushNotificationReceivedFromMessage
    }
    
    func isPushNotificationReceiveFromActionItem() -> Bool {
        guard let isPushNotificationReceivedFromActionItem = UserDefaults.standard.value(forKey: UserDefaultKeys.pushNotificationReceiveFromActionItem) as? Bool else { return false }
        return isPushNotificationReceivedFromActionItem
    }

    
    func isInDirectRoom() -> Bool {
        guard let isInDirectRoom = UserDefaults.standard.value(forKey: UserDefaultKeys.isInDirectRoom) as? Bool else { return false }
        return isInDirectRoom
    }
    
    func isPlanEnable() -> Bool {
        guard let isPlanEnable = UserDefaults.standard.value(forKey: UserDefaultKeys.planEnable) as? Bool else { return false }
        return isPlanEnable
    }
    
    func removeUserInfo() {
        SystemManager.sharedManager.setUserInfoFetched(false)
        DataImporter.sharedManager.setDefaultUserAccountInfo()
    }
    
    func userAccountName(companyId: String, username: String) -> String {
        return companyId + "-" + username
    }
    
    // MARK: Reachability
    
    var etwReachability: Reachability?
    var internetReachability: Reachability?
    
    func setupReachability() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        self.internetReachability = Reachability.networkReachabilityForInternetConnection()
        _ = self.internetReachability?.startNotifier()
        
        //        self.etwReachability = Reachability(hostName: "www.etw.com")
        //        _ = self.etwReachability?.startNotifier()
    }
    
    func triggerReachabilityNotification() {
        self.internetReachability?.postStatusNotification()
    }
    
    
    func tearDownReachability() {
        NotificationCenter.default.removeObserver(self)
        self.internetReachability?.stopNotifier()
        self.etwReachability?.stopNotifier()
    }
    
    func reachabilityDidChange(_ notification: Notification) {
        if let networkReachability = notification.object as? Reachability {
            switch networkReachability.currentReachabilityStatus {
            case .notReachable:
                if networkReachability.isHost {
                    AlertsManager.sharedManager.enqueueAlert(Alerts.serverAccess)
                } else {
                    AlertsManager.sharedManager.enqueueAlert(Alerts.noInternet)
                }
            case .reachableViaWiFi, .reachableViaWWAN:
                AlertsManager.sharedManager.dequeueAlert(Alerts.noInternet)
            }
        }
    }
    
    func signOutUser() {
        SystemManager.sharedManager.showLoadingIndicatorScreen()
        
        DownSyncManager.sharedManager.signOut(completion: {(responseObject,logoutError) in
            
            DispatchQueue.main.async(execute: {
                //log analytics for signout user
                SystemManager.sharedManager.dismissLoadingIndicatorScreen()
                if (logoutError != nil) {
                    AlertsManager.sharedManager.enqueueAlert(ErrorHandlingManager.sharedManager.errorMessage(logoutError!))
                    return
                }
                AnalyticsManager.sharedManager.userLogEventTrack(GoogleAnalytics.Events.Setting.signOutSelected, screenName: GoogleAnalytics.Screens.Setting.settingsScreen)
                if (SystemManager.sharedManager.getOnlinePresenceChannels()?.count) != nil ||  (SystemManager.sharedManager.getOnlinePresenceChannels()?.count) == 0 {
                    PubNubManager.sharedManager.unSubscribeToChannelsPubNub(self.getOnlinePresenceChannels()!)
                }
                SystemManager.sharedManager.cleanupAndGoToLogin()
            })
        })
    }
    
    func readMessages (_ channelID: Int32) {
        self.regfreshTokenAPI(){
            (success) in
            DownSyncManager.sharedManager.fetchReadMessages(channelID){
                (responseObjectReadMessages, userInfoError) in
                DispatchQueue.main.async {
                    // self.badgeCountMessageList = 0
                }
            }
        }
    }

    
    
    func checkProgressAddReplyNote()  {
        if SystemManager.sharedManager.inProgressAddReplyNote() ||  SystemManager.sharedManager.inProgressAddReplyNote(){
            var logoutMessage : String = ""
            if SystemManager.sharedManager.inProgressAddReplyNote(){
                logoutMessage = AlertMessages.logout.confirmation
            } else {
                logoutMessage = AlertMessages.logout.confirmationMessage
            }
            let actionSheet = ETWAlertController.init(logout: logoutMessage, body: "", discardHandler: { (accepted) in
                self.signOutUser()
            }, cancelHandler: { (accepted) in
                SystemManager.sharedManager.setUserIsLoggedIn(true)
            })
            actionSheet.show(true, completion: nil)
            return
        }
        self.signOutUser()
    }
    
    
    // MARK: Current User
    func readUserID() throws -> Int { //TODO: handle error
        do{
            let jwt = try decode(jwt: KeychainManager.sharedManager.readAccessToken())
            if let userID = jwt.body[JwtKeys.userID] as? Int {
                return userID
            }
            return 0 // ???
        }
        catch {
            throw error //Error in Retriving UserID
        }
    }
    
    func isPlanAdmin() throws -> Bool? {
        do{
            let jwt = try decode(jwt: KeychainManager.sharedManager.readAccessToken())
            if let authorities = jwt.body["authorities"] as? Array<String> {
                let isAdmin = (authorities.filter {$0 == "ADMIN_PLANS"}.count > 0)
                return isAdmin
            }
            return nil
        }
        catch {
            throw error //Error in Retriving plan admin
        }
    }
    
    // MARK: Members ID
    func getMemberIDs(_ id: Int32) -> String {
        var idString :String = ""
        idString  = String(format: "userAccountIds=%@&userAccountIds=%@",  String(KeychainManager.sharedManager.readUserID()), String(id))
        return idString
    }
    
    // MARK: User ID check for PushNotification
    func isPushNotificationAvailable() -> Bool {
        if let messageListDictionary = SystemManager.sharedManager.getPushNotificationMessgaeDictionary() {
            if let jsonString = messageListDictionary[JsonKeys.PubNub.messageBody] as? String {
                if let data = jsonString.data(using: .utf8) {
                    do {
                        var messageDictionary =  try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,Any>
                        let userID =  Int32((messageDictionary?[JsonKeys.ChannelMemberships.userId] as? String)!)
                        if userID == Int32(KeychainManager.sharedManager.readUserID()) {
                            return true
                        } else {
                            return false
                        }
                    } catch {
                        print(error.localizedDescription)
                        //TODO: handle , move above code from here to notes data
                    }
                }
            }
        }
        return false
    }
    
    
    // MARK: CommunicationModule
    
    func isCommunicationModuleEnable() -> Bool {
        do{
            let jwt = try decode(jwt: KeychainManager.sharedManager.readAccessToken())
            if let authorities = jwt.body[MessagesStrings.modules] as? [Dictionary <String, Any>] {
                for communicationModule:Dictionary<String, Any> in authorities {
                    if let channel = communicationModule[MessagesStrings.feature] as? String {
                        if channel == MessagesStrings.communication {
                            if let isChannelEnabled = communicationModule[MessagesStrings.enabled] as? Int {
                                if isChannelEnabled == 1 {
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            // throw error //Error in Retriving plan admin
        }
        return false
    }
    
    // MARK: ActionItems Module
    
    func isActionItemsModuleEnable() -> Bool {
        do{
            let jwt = try decode(jwt: KeychainManager.sharedManager.readAccessToken())
            if let authorities = jwt.body[MessagesStrings.modules] as? [Dictionary <String, Any>] {
                for actionItemsModule:Dictionary<String, Any> in authorities {
                    if let channel = actionItemsModule[MessagesStrings.feature] as? String {
                        if channel == MessagesStrings.actionItems {
                            if let isActionItemsEnabled = actionItemsModule[MessagesStrings.enabled] as? Int {
                                if isActionItemsEnabled == 1 {
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            // throw error //Error in Retriving plan admin
        }
        return false
    }
    
  
    // MARK: Meetings Module
    
    func isMeetingsModuleEnable() -> Bool {
        do{
            let jwt = try decode(jwt: KeychainManager.sharedManager.readAccessToken())
            if let authorities = jwt.body[MessagesStrings.modules] as? [Dictionary <String, Any>] {
                for actionItemsModule:Dictionary<String, Any> in authorities {
                    if let channel = actionItemsModule[MessagesStrings.feature] as? String {
                        if channel == MessagesStrings.meetings {
                            if let isActionItemsEnabled = actionItemsModule[MessagesStrings.enabled] as? Int {
                                if isActionItemsEnabled == 1 {
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            // throw error //Error in Retriving plan admin
        }
        return false
    }


    // MARK: Plan Module
    func isPlansModuleEnable() -> Bool {
        do{
            let jwt = try decode(jwt: KeychainManager.sharedManager.readAccessToken())
            if let authorities = jwt.body[MessagesStrings.modules] as? [Dictionary <String, Any>] {
                for communicationModule:Dictionary<String, Any> in authorities {
                    if let channel = communicationModule[MessagesStrings.feature] as? String {
                        if channel == MessagesStrings.plan {
                            if let isChannelEnabled = communicationModule[MessagesStrings.enabled] as? Int {
                                if isChannelEnabled == 1 {
                                    if let authoritiesArray = jwt.body[MessagesStrings.authorities] as? [String] {
                                        if authoritiesArray.contains(MessagesStrings.viewPlan) {
                                            if SystemManager.sharedManager.isPlanEnable() {
                                                return true
                                            } else {
                                                return false
                                            }
                                        } else {
                                            return false
                                        }
                                    }
                                } else {
                                    return false
                                }
                            }
                        }
                    }
                }
            }
        }
        catch {
            // throw error //Error in Retriving plan admin
        }
        return false
    }
  
    // MARK: People Module

    func isPeopleModuleEnable() -> Bool {
        do{
            let jwt = try decode(jwt: KeychainManager.sharedManager.readAccessToken())
            if let authoritiesArray = jwt.body[MessagesStrings.authorities] as? [String] {
                if authoritiesArray.contains(MessagesStrings.people) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        catch {
            // throw error //Error in Retriving plan admin
        }
        return false
    }
    
    
    // MARK: Managerial Authority
    
    func isManagerialAuthorityEnable() -> Bool {  // DELEGATE_MANAGERIAL_AUTHORITY
        do{
            let jwt = try decode(jwt: KeychainManager.sharedManager.readAccessToken())
            if let authoritiesArray = jwt.body[MessagesStrings.authorities] as? [String] {
                if authoritiesArray.contains(MessagesStrings.managerialAuthority) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        }
        catch {
            // throw error //Error in Retriving plan admin
        }
        return false
    }

    
    
    
    func dateUpdate(_ date: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.dateOnlyFormat
        let date  = formatter.string(from: date as Date)
        return date
    }
    
    // MARK: - Settings API call
    
    func fetchSettins() {
        SystemManager.sharedManager.regfreshTokenAPI(){
            (success) in
            DownSyncManager.sharedManager.fetchSettings() {
                (responseObject, settingsError) in
                DispatchQueue.main.async(execute: {
                    if settingsError == nil {
                        if let settingsDictionary = responseObject as? Dictionary<String, Any> {
                            if let enablePlans = settingsDictionary["enablePlans"] as? Bool {
                                if enablePlans {
                                    SystemManager.sharedManager.setPlanEnable(true)
                                } else {
                                    SystemManager.sharedManager.setPlanEnable(false)
                                }
                            }
                        }
                    }
                })
                
            }
        }
    }
    
    
    // MARK: - loginDictionary
    
    func loginDictionary(_ userName: String) {
        if let loginDict = SystemManager.sharedManager.getLoginDictionaryArray() {
            for index in 0...(loginDict.count)-1 {
                if userName == loginDict[index]["userName"] as? String {
                    SystemManager.sharedManager.setMaxKPI((loginDict[index]["maxKPI"] as? String)!)
                    return
                }
            }
            var arrayDict =  SystemManager.sharedManager.getLoginDictionaryArray()
            let addDirectChannelPayload = ["userName": userName,  "maxKPI":  "All"] as [String : Any]
            SystemManager.sharedManager.setMaxKPI("All")
            arrayDict?.append(addDirectChannelPayload)
            SystemManager.sharedManager.setLoginDictionaryArray(arrayDict!)
        } else {
            let addDirectChannelPayload = ["userName": userName,  "maxKPI":  "All"] as [String : Any]
            SystemManager.sharedManager.setMaxKPI("All")
            SystemManager.sharedManager.setLoginDictionaryArray([addDirectChannelPayload])
        }
    }
    
    
    // MARK: - Exp time RefreshToken
    
    func expTimeRefreshToken() {
        do{
            let jwt = try decode(jwt: KeychainManager.sharedManager.readAccessToken())
            if let timeInterval = jwt.body[MessagesStrings.exp] as? Double {
                //Convert to Date
                let date = NSDate(timeIntervalSince1970: timeInterval)
                //Date formatting
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateFormat.refreshTokenTimeFormat
                dateFormatter.timeZone = TimeZone.current
                self.setRefreshTokenExpTime(date as Date)
                let _ = self.isTokenExpire()
            }
        }
        catch {
            // throw error //Error in Retriving plan admin
        }
    }
    
    
    func isTokenExpire() -> Bool {
        let todaysDate:NSDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.refreshTokenTimeFormat
        dateFormatter.timeZone = TimeZone.current
        if self.getRefreshTokenExpTime() == nil {
            return true
        }
        if todaysDate as Date >  self.getRefreshTokenExpTime()! {
            return true
        }
        return false
    }
    
    func regfreshTokenAPI(completion: @escaping RefreshToken)  {
        if self.isTokenExpire() {
            DownSyncManager.sharedManager.refreshToken(completion: {
                (responseObject, fetchError) in
                if fetchError == nil {
                     DispatchQueue.main.async {
                        self.expTimeRefreshToken()
                    }
                    completion(true)
                    return
                }
                completion(false)
                return
            })
        } else {
            completion(true)
            return
        }
    }
    
    // MARK: - Budge Count Update Message
    
    func budgeCountUpdate() {
        let unreadCount = DataUtilities.sharedManager.getTotalUnreadCountMessage()
        BadgeCountManager.sharedManager.badgeCountMessage = 0
        BadgeCountManager.sharedManager.badgeCountMessage = unreadCount
        BadgeCountManager.sharedManager.updateBadgeCountMessage()
    }
    
    func compressImage(image:UIImage) -> Data? {
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 1136.0
        let maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        var compressionQuality : CGFloat = 1
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else{
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let imageData = UIImageJPEGRepresentation(img, compressionQuality)else{
            return nil
        }
        return imageData
    }
    
    
    // MARK: - Authentication Validations
    
    func isTextFieldEmpty(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return true
        }
        return false
    }
    
    func textFieldCharacterCount(_ textField: UITextField) -> Int {
        guard let text = textField.text, !text.isEmpty else {
            return 0
        }
        return text.count
    }
    
    func isTextFieldTrimmedTextEmpty(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else {
            return true
        }
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedText.count == 0
    }
    
    func textFieldTrimmedText(_ textField: UITextField) -> String {
        guard let text = textField.text, !text.isEmpty else {
            return ""
        }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: Email validation
    func isValidEmail(_ emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    
    func uniqueString() -> String {
        var uuid = NSUUID().uuidString
        uuid = uuid.substring(to: uuid.index(uuid.startIndex, offsetBy: 4))
        return uuid
    }
    
   
    
    func randomNumber() -> UInt32 {
        var previousNumber: UInt32? // used in randomNumber()
        var randomNumber = arc4random_uniform(10)
        while previousNumber == randomNumber {
            randomNumber = arc4random_uniform(10)
        }
        previousNumber = randomNumber
        return randomNumber
    }
    
    // MARK: Loading Screens
    
    func showLoadingIndicatorScreen() {
        let storyboard: UIStoryboard = UIStoryboard.init(name: StoryboardName.authentication, bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.loadingViewController)
        self.loadingView = loadingViewController.view
        AppDelegate.shared.window?.addSubview(self.loadingView!)
    }
    
    func dismissLoadingIndicatorScreen() {
        if let view = self.loadingView {
            view.removeFromSuperview()
            self.loadingView = nil
        }
    }
    
    // MARK : UITableView Separator Inset
    
    func setupTableViewCell(_ cell: UITableViewCell) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    
    // MARK: HTML Formatting
    
    func getFormattedText(_ parameters : String) -> String {
        var removeHTMLString =  parameters.replacingOccurrences(of: "€", with: "&euro;")
        removeHTMLString     = removeHTMLString.replacingOccurrences(of: "£", with: "&pound;")
        removeHTMLString     = removeHTMLString.replacingOccurrences(of: "•", with: "&bull;")
        removeHTMLString     = removeHTMLString.replacingOccurrences(of: "₹", with: "&rupee;")
        removeHTMLString     = removeHTMLString.replacingOccurrences(of: "¥", with: "&yen;")
        return removeHTMLString
    }
    
    func getFormattedTextFromServer(_ parameters : String) -> String? { // TODO : Need to find out better implementation
        var removeHTMLString =    parameters.replacingOccurrences(of: "&rupee;", with: "£")
        removeHTMLString =  removeHTMLString.replacingOccurrences(of: "&pound;", with: "₹")
        removeHTMLString =  removeHTMLString.replacingOccurrences(of: "&bull;",  with: "•")
        removeHTMLString =  removeHTMLString.replacingOccurrences(of: "&yen;",   with: "¥")
        removeHTMLString =  removeHTMLString.replacingOccurrences(of: "&euro;",  with: "€")
        
        return removeHTMLString
    }
    
    func resizeImageFromOriginalImage(_ text: NSMutableAttributedString) -> NSMutableAttributedString {
        text.enumerateAttribute(NSAttachmentAttributeName, in: NSMakeRange(0, text.length), options: .init(rawValue: 0), using: { (value, range, stop) in
            if let attachement = value as? NSTextAttachment {
                let image = attachement.image(forBounds: attachement.bounds, textContainer: NSTextContainer(), characterIndex: range.location)!
                let screenSize: CGRect = UIScreen.main.bounds
                if image.size.width > screenSize.width-20 {
                    let newSize = CGSize(width: 300.0, height: 300.0)
                    let newImage = resizeImage(newSize, selectedImage: image)
                   // let newImage = image.resizeImage(scale: (screenSize.width-2)/image.size.width)
                    let newAttribut = NSTextAttachment()
                    newAttribut.image = newImage
                    text.addAttribute(NSAttachmentAttributeName, value: newAttribut, range: range)
               }
            }
        })
        print("text selectedImage =======", text)
        return text
    }
    
    func resizeImage(_ newSize: CGSize, selectedImage: UIImage) -> UIImage {
        print("selectedImageselectedImage ===", selectedImage.size)
        var actualHeight: CGFloat = selectedImage.size.height
        var actualWidth: CGFloat = selectedImage.size.width
        let maxWidth: CGFloat = newSize.width
        let maxHeight: CGFloat = newSize.height
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        let compressionQuality = 1
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if(imgRatio < maxRatio) {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if(imgRatio > maxRatio) {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 250, height: 250)
        UIGraphicsBeginImageContext(rect.size)
        selectedImage.draw(in: rect)
        let image: UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData = UIImageJPEGRepresentation(image, CGFloat(compressionQuality))
        let imageSize: Int = imageData!.count
        print("size of image in KB: %f ", Double(imageSize) / 1024.0)
        UIGraphicsEndImageContext()
        let resizedImage = UIImage(data: imageData!)
        print("resizedImage ============", resizedImage)
        print("resizedImage width ============", resizedImage?.size.width)
        print("resizedImage height ============", resizedImage?.size.height)

        return resizedImage!
        
    }
    
    // Formatted Text for Notes Message
    func formattedTextForNotesMessage(_ notesMessage: String) -> NSMutableAttributedString {
        
        let modifiedSystemFont = NSString(format:"<span style=\"font-family: '-apple-system', 'Roboto';color:\(NotesMessageFont.color); font-size: \(NotesMessageFont.size)\">%@</span>" as NSString, notesMessage) as String
        
        //process collection values
        let htmlAttrStr = try! NSMutableAttributedString(data: modifiedSystemFont.data(using: .unicode, allowLossyConversion: true)!,
                                                  options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSDefaultAttributesDocumentAttribute: String.Encoding.utf8.rawValue],
                                                  documentAttributes: nil)
        return htmlAttrStr as! NSMutableAttributedString
    }
    
    func stringToHTML (_ string: String) -> String? {
        let attrStr = NSAttributedString(string: string)
        
        //   let modifiedSystemFont = NSString(format:"<span style=\"font-family: '-apple-system', 'Roboto'; font-size: \(12)\">%@</span>" as NSString, string) as String
        
        //let documentAttributes = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        do {
            let htmlData = try attrStr.data(from: NSMakeRange(0, attrStr.length),
                                            documentAttributes: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSDefaultAttributesDocumentAttribute: String.Encoding.utf8.rawValue] )
            
            if let htmlString = String(data:htmlData,
                                       encoding:String.Encoding.utf8) {
                
                // print(htmlString)
                return htmlString
            }
        }
        catch {
            print("error creating HTML from Attributed String")
        }
        return nil
    }
    
    
    // MARK: Status Color for Notes
    
    func statusColor (_ status: Int32) -> UIColor {
        
        var statusColor: UIColor?
        let statusNumber: NoteStatus = NoteStatus(rawValue: Int(status))!
        
        switch statusNumber {
        case .noStatus:
            statusColor = NoteStatusColor.noStatus
        case .atRisk:
            statusColor = NoteStatusColor.atRisk
        case .fallingBehind:
            statusColor = NoteStatusColor.fallingBehind
        case .onTrack:
            statusColor = NoteStatusColor.onTrack
        case .draftStatus:
            statusColor = NoteStatusColor.draft
        case .draft:
            statusColor = NoteStatusColor.draftGoal
        case .suspended:
            statusColor = NoteStatusColor.suspended
        case .completed:
            statusColor = NoteStatusColor.completed
            
        default:
            statusColor =  NoteStatusColor.defaultColor
        }
        return statusColor!
    }
    
    func stateColorPinnedPlan (_ state: Int32) -> UIColor {
        var stateColor: UIColor?
        if state != 0 {
            let stateNumber: PinnedPlanStateStatus = PinnedPlanStateStatus(rawValue: Int(state))!
            switch stateNumber {
            case .draft:
                stateColor = NoteStatusColor.draftGoal
            case .suspended:
                stateColor = NoteStatusColor.draftGoal
            case .completed:
                stateColor = NoteStatusColor.completed
            }
            return stateColor!
        }
          return  NoteStatusColor.active
    }
    
    
    // MARK: Status Color for GoalsPlan
    
    func statusColorGoalsNote (_ status: Int32) -> UIColor {
        var statusColor: UIColor?
        let statusNumber: GoalsPlanStatus = GoalsPlanStatus(rawValue: Int(status))!
        
        switch statusNumber {
        case .noStatus:
            statusColor = NoteStatusColor.noStatus
        case .atRisk:
            statusColor = NoteStatusColor.atRisk
        case .fallingBehind:
            statusColor = NoteStatusColor.fallingBehind
        case .onTrack:
            statusColor = NoteStatusColor.onTrack
        case .draft:
            statusColor = NoteStatusColor.draftGoal
        }
        return statusColor!
    }
    
    
    
    // MARK: Status Text for Notes
    
    
    func statusText (_ status: Int32) -> String {
        
        var statusText: String?
        let statusNumber: NoteStatus = NoteStatus(rawValue: Int(status))!
        
        switch statusNumber {
        case .noStatus:
            statusText = NotesStatusText.NoStatus
        case .atRisk:
            statusText = NotesStatusText.AtRisk
        case .fallingBehind:
            statusText = NotesStatusText.FallingBehind
        case .onTrack:
            statusText = NotesStatusText.OnTrack
        case .draftStatus:
            statusText = NotesStatusText.Draft
        case .draft:
            statusText = NotesStatusText.Draft
        case .suspended:
            statusText = NotesStatusText.Suspended
        case .completed:
            statusText = NotesStatusText.Completed
        default:
            statusText = NotesStatusText.DefaultStatus
            
        }
        return statusText!
    }
    
    func statusTextGoalsPlan (_ status: Int32) -> String {
        
        var statusText: String?
        let statusNumber: GoalsPlanStatus = GoalsPlanStatus(rawValue: Int(status))!
        switch statusNumber {
        case .noStatus:
            statusText = NotesStatusText.NoStatus
        case .atRisk:
            statusText = NotesStatusText.AtRisk
        case .fallingBehind:
            statusText = NotesStatusText.FallingBehind
        case .onTrack:
            statusText = NotesStatusText.OnTrack
        case .draft:
            statusText = NotesStatusText.Draft
        }
        return statusText!
    }
    
    
    func stausPinnedPlan(_ status: Int32) -> String {
        var statusText: String?
        let statusNumber: PinnedPlanStatus = PinnedPlanStatus(rawValue: Int(status))!
        switch statusNumber {
        case .noStatus:
            statusText = PinnedPlanStatusText.NoStatus
        case .atRisk:
            statusText = PinnedPlanStatusText.AtRisk
        case .fallingBehind:
            statusText = PinnedPlanStatusText.FallingBehind
        case .onTrack:
            statusText = PinnedPlanStatusText.OnTrack
        case .almostOnTrack:
            statusText = PinnedPlanStatusText.AlmostOnTrack
        case .almostFallingBehind:
            statusText = PinnedPlanStatusText.AlmostFallingBehind
        }
        return statusText!
    }
    
    
    func roomDirectMessageImage (_ imageName: String, isOnline: Bool) -> UIImage {
        switch imageName {
        case MessagesListGroup.planGroup:
            return #imageLiteral(resourceName: "PlanGroup")
        case MessagesListGroup.teamGroup:
            return #imageLiteral(resourceName: "TeamGroup")
        case MessagesListGroup.privateGroup:
            return #imageLiteral(resourceName: "PrivateGroup")
        case MessagesListGroup.publicGroup:
            return #imageLiteral(resourceName: "PublicGroup")
        case MessagesListGroup.directYou:
            if self.connectivityCheck() {
                return #imageLiteral(resourceName: "ActivePerson")
            }
            return #imageLiteral(resourceName: "Person")
        default:
            return #imageLiteral(resourceName: "PlanGroup")
        }
    }
    
    func connectivityCheck() -> Bool {
        if let internetReachability = SystemManager.sharedManager.internetReachability {
            if internetReachability.isReachable {
                return true
            }
            return false
        }
        return false
    }
    
    func checkForOnlinePresence(_ userID: Int32, uuidNo: String) -> Bool {
        let onlineUser = DataUtilities.sharedManager.findOnlineUser(uuidNo)
        if onlineUser != nil {
            let userIdFilter = onlineUser?.filter {$0 == userID}
            let isOnline = (userIdFilter?.count)! > 0 ? true : false
            return isOnline
        }
        return false
    }
    
    
    func goalTypeModifyForDisplay(_ goalType : String?) -> String{
        
        var goalTypeText = goalType
        if(goalTypeText == JsonValues.GoalType.managerAssigned){
            goalTypeText = LabelStrings.managerAssignGoalType //handle server response
        }
        return goalTypeText!
    }
    
    func goalTypeModifyForServer(_ goalType : String?) -> String{
        
        var goalTypeText = goalType
        if(goalTypeText == LabelStrings.managerAssignGoalType){
            goalTypeText = JsonValues.GoalType.managerAssigned //handle server response
        }
        return goalTypeText!
    }
    
    func appInitializers(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        if !SystemManager.sharedManager.isLaunchedBefore() {
            UIApplication.shared.applicationIconBadgeNumber = 0
            SystemManager.sharedManager.clearNotification()
            SystemManager.sharedManager.setMaxKPI("All")
            KeychainManager.sharedManager.removeAllUserAccounts()
            KeychainManager.sharedManager.removeAccessTokens()
            SystemManager.sharedManager.setUserFirstLaunch(true)
        }
        SystemManager.sharedManager.setUserID([0])
        self.setupFireBase()
        CoreDataStackManager.sharedManager.deleteCoreDataDbFiles()
        SystemManager.sharedManager.removeUserInfo()
        SystemManager.sharedManager.setupReachability()
        self.removeSelectedPeopleData()
        SystemManager.sharedManager.setPeopleProfileSelected(false)
        SystemManager.sharedManager.setPeopleSelectedFromHome(false)
        SystemManager.sharedManager.setInProgressAddReplyNote(false)
        SystemManager.sharedManager.setAddNoteInAccessoryView(false)
        SystemManager.sharedManager.setReplyNoteInAccessoryView(false)
        SystemManager.sharedManager.setInProgressAddMessage(false)
        SystemManager.sharedManager.setAddMessageInAccessoryView(false)
        if SystemManager.sharedManager.isUserLoggedIn() {
            PubNubManager.sharedManager.badgeCountMessageList = 0
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
            SystemManager.sharedManager.clearNotification()
        }
    }
    
    // FireBase configure only for production.
    func setupFireBase() {
        switch currentEnvironment {
        case .Production :
            FirebaseApp.configure()
            return
        case .Development:
          //  FirebaseApp.configure()
            return
        case .Staging:
            return
        }
    }
    
    func channelAPICall (){
        self.regfreshTokenAPI(){
            (success) in
            DownSyncManager.sharedManager.channelGroups(KeychainManager.sharedManager.readUserID()){
                (responseObject, userInfoError) in
                DispatchQueue.main.async(execute: {
                    BadgeCountManager.sharedManager.updateBadgeCountMessage()
                })
            }
        }
    }
    
    func actionItemListAPICall() {
        self.regfreshTokenAPI(){
            (success) in
            DownSyncManager.sharedManager.fetchHomeActionItemsList(false, userID: KeychainManager.sharedManager.readUserID()){
                (responseObject, userInfoError) in
                DispatchQueue.main.async(execute: {
                    if userInfoError == nil {
                        self.badgeCountUpdateActionItem()
                        BadgeCountManager.sharedManager.updateBadgeCountActionItem()
                    }
                })
            }
        }
    }
    
    func extractActionItemsListForBudgeCount(_ parameters : Any)  {
        let response = parameters as? Dictionary <String, Any>
        if let actionItemsListArray = response![JsonKeys.ActionItems.records] as? [Dictionary<String, Any>]{
            if actionItemsListArray.count > 0 {
                for actionItemDictionary:Dictionary<String,Any> in actionItemsListArray {
                    if let type = actionItemDictionary[JsonKeys.ActionItems.type] as? String {
                        if type != JsonValues.GoalType.personal {
                            if let viewedByUser = actionItemDictionary[JsonKeys.ActionItems.viewedByUser] as? Bool  {
                                if !viewedByUser {
                                    newActionItem += 1
                                }
                                if let dueDate = actionItemDictionary[JsonKeys.ActionItems.dueDate] as? String {
                                    let date = self.dateConfigure(dueDate)
                                    if date == 1 {
                                        todayDueDate += 1
                                    } else if date == 2 {
                                        pastDueDate += 1
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func badgeCountUpdateActionItem(){
        if self.newActionItem > 0 {
            BadgeCountManager.sharedManager.badgeCountActionItem = Int32(self.newActionItem)
            return
        } else if self.pastDueDate > 0 {
            BadgeCountManager.sharedManager.badgeCountActionItem = Int32(self.pastDueDate)
             return
        } else if self.todayDueDate > 0 {
            BadgeCountManager.sharedManager.badgeCountActionItem = Int32(self.todayDueDate)
            return
        }
    }
    
     func badgeUpdateActionItem() -> UIColor {
        if self.newActionItem > 0 {
            BadgeCountManager.sharedManager.badgeCountActionItem = Int32(self.newActionItem)
            return #colorLiteral(red: 0.3176470588, green: 0.7490196078, blue: 0.8862745098, alpha: 1)
        } else if self.pastDueDate > 0 {
            BadgeCountManager.sharedManager.badgeCountActionItem = Int32(self.pastDueDate)
            return #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        } else if self.todayDueDate > 0 {
            BadgeCountManager.sharedManager.badgeCountActionItem = Int32(self.todayDueDate)
            return #colorLiteral(red: 1, green: 0.5960784314, blue: 0, alpha: 1)
        }
        return #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
    }
    
    func decreaseBadgeValueActionItem(_ actionItemList: ActionItemList) {
        if actionItemList.type != JsonValues.GoalType.personal{
            if !actionItemList.viewedByUser {
                newActionItem -= 1
                if newActionItem == 0 {
                    if pastDueDate > 0 {
                        self.updateCountActionItemBadge(Int32(pastDueDate))
                        return
                    }
                    else if todayDueDate > 0 {
                        self.updateCountActionItemBadge(Int32(todayDueDate))
                        return
                    }
                }
                
            } else if actionItemList.createSection == 1 {
                pastDueDate -= 1
                self.updateCountActionItemBadge(Int32(pastDueDate))
                return
            } else if actionItemList.isTodaysDueDate {
                todayDueDate -= 1
                self.updateCountActionItemBadge(Int32(todayDueDate))
                return
            }
        }
    }
    
    func updateCountActionItemBadge(_ count: Int32) {
        BadgeCountManager.sharedManager.badgeCountActionItem = count
        BadgeCountManager.sharedManager.updateBadgeCountActionItem()
    }
    
    func clearActionItemBadgeValue() {
        self.newActionItem = 0
        self.pastDueDate = 0
        self.todayDueDate = 0
    }
    
    func dateConfigure(_ date: String) -> Int {
        let dateDueDate = DateFormatter.isoMessagesDate(from: date)
        let todaysDate:NSDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateOnlyFormatFromServer
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let todayDateString =  dateFormatter.string(from: todaysDate as Date)
        let dueDateString   =  dateFormatter.string(from: (self.getCurrentLocalDate(dateDueDate! as Date)))
        
        let convertedDueDate = (self.getCurrentLocalDate(dateDueDate! as Date))
        if todayDateString == dueDateString {
            return 1
        } else {
            if todaysDate as Date > convertedDueDate  {
                return 2
            }
            return 3
        }
    }
    
    
    func pubNubSubscribe() {
        PubNubManager.sharedManager.configurePubNubSetting()
        DataUtilities.sharedManager.deleteOnlinePresenceMessage()
        DispatchQueue.main.async {
            PubNubManager.sharedManager.subscribeToChannelsPubNub(channelIDs: SystemManager.sharedManager.getOnlinePresenceChannels()!)
            for channel: String in SystemManager.sharedManager.getOnlinePresenceChannels()! {
                PubNubManager.sharedManager.OnlinePresence(channel)
            }
        }
    }
    
    func cleanup() {
        CoreDataStackManager.sharedManager.reinitialize()
        SystemManager.sharedManager.removeUserInfo()
        KeychainManager.sharedManager.removeAccessTokens()
        //        SystemManager.sharedManager.tearDownReachability()
    }
    
    
    func isUserIdAvailable() -> Bool {
        var  userIDPushNotification: Int32 = 0
        if let messageListDictionary = SystemManager.sharedManager.getPushNotificationMessgaeDictionary() {
            if let jsonString = messageListDictionary[JsonKeys.PubNub.messageBody] as? String  {
                if let data = jsonString.data(using: .utf8) {
                    do {
                        var messageDictionary =  try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,Any>
                        userIDPushNotification  =   Int32((messageDictionary?[JsonKeys.ChannelMemberships.userId] as? String)!)!
                    } catch {
                        print(error.localizedDescription)
                        //TODO: handle , move above code from here to notes data
                    }
                }
            }
        }
        if let userID = SystemManager.sharedManager.getUserID() {
            let userIdFilter = userID.filter {$0 == userIDPushNotification}
            let isAvailable = (userIdFilter.count) > 0 ? true : false
            return isAvailable
        }
        return true
    }
    
    func getPlanKPILimit() -> Int {
        var limit: Int = 0
        if let selectedLimit = self.getMaxKPI() {
            switch selectedLimit {
            case "None":
                limit = 0
            case "1 KPI":
                limit = 1
            case "2 KPI":
                limit = 2
            case "3 KPI":
                limit = 3
            case "4 KPI":
                limit = 4
            case "5 KPI":
                limit = 5
            case "10 KPI":
                limit = 10
            case "All":
                limit = -1
            default:
                limit = 0
            }
        }
        return limit
    }
    
    
    func formatPoints(num: Double) ->String{
        let thousandNum = num/1000
        let millionNum = num/1000000
        let billionNum = num/1000000000
        let tillionNum = num/1000000000000
        if num > 0 {
            if num >= 1000 && num < 10000 {
                if(floor(thousandNum) == thousandNum){
                    return String(format: "%.2f%@",thousandNum,"k")
                }
                return String(format: "%.2f%@",(round1(thousandNum, toNearest: 0.01)),"k")
            }
            if num >= 10000 && num < 100000 {
                return String(format: "%.2f%@",(round1(thousandNum, toNearest: 0.01)),"k")
            }
            
            if num >= 100000 && num < 1000000{
                if(floor(millionNum) == millionNum){
                    return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
                }
                return String(format: "%.2f%@",thousandNum,"k")
            }
            if num >= 1000000 && num < 10000000{
                if(floor(millionNum) == millionNum){
                    return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
                }
                return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
            }
            
            if num >= 10000000 && num < 100000000{
                if(floor(millionNum) == millionNum){
                    return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
                }
                return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
            }
            
            if num >= 100000000 && num < 1000000000{
                if(floor(millionNum) == millionNum){
                    return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
                }
                return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
            }
            if num >= 1000000000 && num < 10000000000{
                if(floor(millionNum) == millionNum){
                    return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
                }
                return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
            }
            
            if num >= 10000000000 && num < 100000000000{
                if(floor(millionNum) == millionNum){
                    return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
                }
                return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
            }
                
          
            
            
            
            if num >= 100000000000 && num < 1000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",tillionNum,"t")
            }
            if num >= 1000000000000 && num < 10000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }
            
            if num >= 10000000000000 && num < 100000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }
            
            if num >= 100000000000000 && num < 1000000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }
            if num >= 1000000000000000 && num < 10000000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }
            
            if num >= 10000000000000000 && num < 100000000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }

                
                
            else if num == 1000000
            {
                return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
            }
            else{
                if(floor(num) == num){
                    return String(format: "%.2f",num)
                }
                return String(format: "%.2f",(round1(num, toNearest: 0.01)))
            }
        }
        else {
            if num <= -1000 && num > -10000 {
                if(floor(thousandNum) == thousandNum){
                    return String(format: "%.2f%@",thousandNum,"k")
                }
                return String(format: "%.2f%@",(round1(thousandNum, toNearest: 0.01)),"k")
            }
            
            if num <= -10000 && num > -100000 {
                return String(format: "%.2f%@",(round1(thousandNum, toNearest: 0.01)),"k")
            }
            
            if num <= -100000 && num > -1000000 {
                return String(format: "%.2f%@",(round1(thousandNum, toNearest: 0.01)),"k")
            }
            
            
            if num <= -1000000 && num > -10000000{
                if(floor(millionNum) == millionNum){
                    return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
                }
                return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
                
                //  return String(format: "%.2f%@",thousandNum,"k")
            }
            
            if num <= -10000000 && num > -10000000000{
                if(floor(millionNum) == millionNum){
                    return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
                }
                return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
            }
            if num <= -10000000 && num > -100000000000{
                if(floor(millionNum) == millionNum){
                    return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
                }
                return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
            }
                
            if num <= -100000000000 && num > -1000000000000{
                if(floor(billionNum) == billionNum){
                    return String(format: "%.2f%@",(round1(billionNum, toNearest: 0.01)),"b")
                }
                return String(format: "%.2f%@",(round1(billionNum, toNearest: 0.01)),"b")
            }

                
            else if num == -1000000 {
                return String(format: "%.2f%@",(round1(millionNum, toNearest: 0.01)),"m")
            }
                
              
                
                
            if num <= -100000000000 && num > -1000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }
            
            else if num <= -1000000000000 && num > -10000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }
                
            else if num <= -10000000000000 && num > -100000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }
     
            else if num <= -100000000000000 && num > -1000000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }
            else if num <= -1000000000000000 && num > -10000000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }
            else if num <= -10000000000000000 && num > -10000000000000000000000000000{
                if(floor(tillionNum) == tillionNum){
                    return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
                }
                return String(format: "%.2f%@",(round1(tillionNum, toNearest: 0.01)),"t")
            }

                
            else {
                if(floor(num) == num){
                    return String(format: "%.2f",num)
                }
                return String(format: "%.2f",(round1(num, toNearest: 0.01)))
            }
        }
        
    }
    
    
    func round1(_ value: Double, toNearest: Double) -> Double {
        return Darwin.round(value / toNearest) * toNearest
    }
    
    
    
    // GoalsPlan Section define
    
   
    func sectionForGoalsPlan(_ planId: Int64) -> Int {
        if let kpiPlan = DataUtilities.sharedManager.findKPIForPlanDetails(planId) {
            if let golasPlan = DataUtilities.sharedManager.findGoalPlanDetails(planId) {
                if let suportingPlan = DataUtilities.sharedManager.findSuportingPlan(planId) {
                    if kpiPlan.count > 0 && golasPlan.count > 0 &&  suportingPlan.count > 0 {
                        return 3
                    }
                } else {
                    return 2
                }
            } else {
                if let _ = DataUtilities.sharedManager.findSuportingPlan(planId) {
                    return 2
                } else {
                    return 1
                }
            }
        } else {
            if let golasPlan = DataUtilities.sharedManager.findGoalPlanDetails(planId) {
                if let suportingPlan = DataUtilities.sharedManager.findSuportingPlan(planId) {
                    if  golasPlan.count > 0  &&  suportingPlan.count > 0 {
                        return 2
                    }
                } else {
                    return 1
                }
            } else {
                if let suportingPlan = DataUtilities.sharedManager.findSuportingPlan(planId) {
                    if suportingPlan.count > 0 {
                        return 1
                    }
                } else {
                    return 0
                }
            }
        }
        return 0
    }
    
    
    
    
    func numberOfRowInsectionForGoalsPlan(_ planId: Int64, section: Int) -> Int {
        let count = self.sectionForGoalsPlan(planId)
        if count > 0 {
            if section == 0 {
                if let _ = DataUtilities.sharedManager.findKPIForPlanDetails(planId) {
                    return 1
                }
                if let golasPlan = DataUtilities.sharedManager.findGoalPlanDetails(planId) {
                    return golasPlan.count
                }
                if let suportingPlan = DataUtilities.sharedManager.findSuportingPlan(planId) {
                    return suportingPlan.count
                }
            } else {
                if section == 1 {
                    if let _ = DataUtilities.sharedManager.findKPIForPlanDetails(planId) {
                        if let golasPlan = DataUtilities.sharedManager.findGoalPlanDetails(planId) {
                            return golasPlan.count
                        } else {
                            if let suportingPlan = DataUtilities.sharedManager.findSuportingPlan(planId) {
                                return suportingPlan.count
                            }
                        }
                    }
                }
                if section == 2 {
                    if let suportingPlan = DataUtilities.sharedManager.findSuportingPlan(planId) {
                        return suportingPlan.count
                    }
                }
            }
        } else {
            return 0
        }
        return 0
    }
    
    func viewForHeaderInSectionForGoalsPlan(_ planId: Int64, section: Int) -> String {
        let count = self.sectionForGoalsPlan(planId)
        if count > 0 {
            if section == 0 {
                if let _ = DataUtilities.sharedManager.findKPIForPlanDetails(planId) {
                    return PlansDetails.TableViewSection.kpi
                }
                if let _ = DataUtilities.sharedManager.findGoalPlanDetails(planId) {
                    return PlansDetails.TableViewSection.golas
                }
                if let _ = DataUtilities.sharedManager.findSuportingPlan(planId) {
                    return PlansDetails.TableViewSection.suportingPlans
                }
            } else {
                if section == 1 {
                    if let _ = DataUtilities.sharedManager.findKPIForPlanDetails(planId) {
                        if let _ = DataUtilities.sharedManager.findGoalPlanDetails(planId) {
                            return PlansDetails.TableViewSection.golas
                        } else {
                            if let _ = DataUtilities.sharedManager.findSuportingPlan(planId) {
                                return PlansDetails.TableViewSection.suportingPlans
                            }
                        }
                    }
                }
                if section == 2 {
                    if let _ = DataUtilities.sharedManager.findSuportingPlan(planId) {
                        return PlansDetails.TableViewSection.suportingPlans
                    }
                }
            }
        } else {
            return ""
        }
        return ""
    }
    
    
    func getCurrentLocalDate(_ dueDate: Date)-> Date {
        var now = dueDate
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        nowComponents.hour = Calendar.current.component(.hour, from: now)
        nowComponents.minute = Calendar.current.component(.minute, from: now)
        nowComponents.second = Calendar.current.component(.second, from: now)
        nowComponents.timeZone = TimeZone(abbreviation: "UTC")!
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
}



extension UIAlertController {
    
    /**
     A simple `UIAlertController` made to show an error message that's passed in.
     
     - parameter body: The body of the alert.
     
     - returns:  A `UIAlertController` with an 'Okay' button.
     */
    convenience init(title: String, body: String, dismissHandler: AlertBarAction?) {
        self.init(title: title, message: body, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: AlertActionButton.ok, style: .default) { action in
            if let handler = dismissHandler {
                handler()
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        self.addAction(okayAction)
    }
    
    convenience init(addReplayNote title: String, body: String, retryHandler: ActionSheetHandler?,  editHandler: ActionSheetHandler?) {
        self.init(title: title, message: body, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: AlertActionButton.retry, style: .`default`) { action in
            if let handler = retryHandler {
                handler(true)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.addAction(acceptAction)
        
        let editAction = UIAlertAction(title: AlertActionButton.edit, style: .cancel) { action in
            if let handler = editHandler {
                handler(false)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.addAction(editAction)
    }
    
    convenience init(touchIDConfirmationSheetTitle title: String, body: String, acceptHandler: ActionSheetHandler?,  declineHandler: ActionSheetHandler?) {
        
        self.init(title: title, message: body, preferredStyle: .actionSheet)
        
        let acceptAction = UIAlertAction(title: SettingsMessages.ActionSheet.TouchID.acceptButtonText, style: .destructive) { action in
            if let handler = acceptHandler {
                handler(true)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.addAction(acceptAction)
        
        let declineAction = UIAlertAction(title: SettingsMessages.ActionSheet.TouchID.declineButtonText, style: .cancel) { action in
            if let handler = declineHandler {
                handler(false)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.addAction(declineAction)
        
    }
    
    convenience init(logout title: String, body: String, discardHandler: ActionSheetHandler?,  cancelHandler: ActionSheetHandler?) {
        self.init(title: title, message: body, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: AlertActionButton.delete, style: .destructive) { action in
            if let handler = discardHandler {
                handler(true)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.addAction(acceptAction)
        
        let editAction = UIAlertAction(title: AlertActionButton.cancel, style: .cancel) { action in
            if let handler = cancelHandler {
                handler(false)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.addAction(editAction)
    }
    
    convenience init(discardNote title: String, body: String, discardHandler: ActionSheetHandler?,  cancelHandler: ActionSheetHandler?) {
        self.init(title: title, message: body, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: AlertActionButton.yes, style: .destructive) { action in
            if let handler = discardHandler {
                handler(true)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.addAction(acceptAction)
        
        let editAction = UIAlertAction(title: AlertActionButton.no, style: .cancel) { action in
            if let handler = cancelHandler {
                handler(false)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.addAction(editAction)
    }
    
    convenience init(deleteActionItem title: String, body: String, discardHandler: ActionSheetHandler?,  cancelHandler: ActionSheetHandler?) {
        self.init(title: title, message: body, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: AlertActionButton.yes, style: .destructive) { action in
            if let handler = discardHandler {
                handler(true)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.addAction(acceptAction)
        
        let editAction = UIAlertAction(title: AlertActionButton.no, style: .cancel) { action in
            if let handler = cancelHandler {
                handler(false)
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        self.addAction(editAction)
    }
    
    
}

extension UIImage{
    func resizeImageWith(_ newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height

        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }


}

extension CALayer {
    var borderColorFromUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        } set {
            self.borderColor = newValue.cgColor
        }
    }
}

extension DateFormatter {
    private static let dateFormatterISO: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatFromServer
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()
    
    private static let dateFormatterMessagesISO: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatmessagesFromServer
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()
    
    
    private static let dateFormatterPlanGoalsISO: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateOnlyFormatFromServer
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()
    
    
    private static let dateFormatterPlansKpiISO: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatPlansKPIFromServer
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()
    
    private static let dateFormatterActionItemDueISO: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateOnlyFormatFromServer
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()

    
    
    public class func isoString(from date: Date) -> String {
        return DateFormatter.dateFormatterISO.string(from: date)
    }
    
    public class func isoDate(from string: String?) -> Date? {
        if let dateString = string {
            return DateFormatter.dateFormatterISO.date(from: dateString)
        }
        return nil
    }
    
    public class func isoMessagesDate(from string: String?) -> Date? {
        if let dateString = string {
            return DateFormatter.dateFormatterMessagesISO.date(from: dateString)
        }
        return nil
    }
    
    public class func isoPlansKPIDate(from string: String?) -> Date? {
        if let dateString = string {
            return DateFormatter.dateFormatterPlansKpiISO.date(from: dateString)
        }
        return nil
    }
    
    
    public class func isoMessagesDateToString(from date: Date) -> String {
        return DateFormatter.dateFormatterMessagesISO.string(from: date)
    }
    
    public class func isoPlanGoalsDate(from string: String?) -> Date? {
        if let dateString = string {
            return DateFormatter.dateFormatterPlanGoalsISO.date(from: dateString)
        }
        return nil
    }
    
    public class func isoPlanDateCheck(from date: Date?) -> String? {
        if let dateString = date {
            return DateFormatter.dateFormatterPlanGoalsISO.string(from: dateString)
        }
        return nil
    }
    
    public class func isoActionItemDueDate(from string: String?) -> Date? {
        if let dateString = string {
            return DateFormatter.dateFormatterActionItemDueISO.date(from: dateString)
        }
        return nil
    }

    
    public class func currentDate() -> String {
        let date = Date()
        let formatedDateString = DateFormatter.dateFormatterISO.string(from: date)
        return formatedDateString
    }
    
    public class func currentDateFormat() -> String {
        let date = Date()
        let formatedDateString = DateFormatter.dateFormatterMessagesISO.string(from: date)
        return formatedDateString
    }
    
    
    public class func isoDateWithoutTime(from string: String?) -> Date? {
        if let dateString = string {
            if let date = DateFormatter.dateFormatterISO.date(from: dateString) {
                let components = DateFormatter.dateFormatterISO.calendar.dateComponents([.year, .month, .day], from: date)
                return DateFormatter.dateFormatterISO.calendar.date(from: components)
            }
        }
        return nil
    }
    
    public class func isoDateWithoutTimeMessages(from string: String?) -> Date? {
        if let dateString = string {
            if let date = DateFormatter.dateFormatterMessagesISO.date(from: dateString) {
                let components = DateFormatter.dateFormatterMessagesISO.calendar.dateComponents([.year, .month, .day], from: date)
                return DateFormatter.dateFormatterMessagesISO.calendar.date(from: components)
            }
        }
        return nil
    }
    
    
    private static let dateFormatterWithoutTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateOnlyFormatFromServer
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter
    }()
    
    public class func dateWithoutTime(from string: String?) -> Date? {
        if let dateString = string {
            return DateFormatter.dateFormatterWithoutTime.date(from: dateString)
        }
        return nil
    }
    
//    private static let dateFormatterMonthDate: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = DateFormat.monthDateFormat
//        return dateFormatter
//    }()
    
   
    private static let dateFormatterStringWithoutTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateOnlyFormat
        return dateFormatter
    }()
    
  
    public class func dateStringWithoutTime(from date: Date?) -> String {
        if let dateObject = date {
            return DateFormatter.dateFormatterStringWithoutTime.string(from: dateObject)
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = DateFormat.dateOnlyFormat
//            dateFormatter.timeZone = TimeZone(identifier: "UTC")
//
//            return dateFormatter.string(from: dateObject)
        }
        return ""
    }
    
    public class func getDatePlan (_ date: Date?) -> String {
        if let dateObject = date {
            return DateFormatter.dateFormatterMonthDate.string(from: dateObject)
        }
        return ""
    }

    
    public class func getDate (_ date: Date?) -> String {
        if let dateObject = date {
            let month = DateFormatter.dateFormatterByMonth.string(from: dateObject)
            let time = DateFormatter.dateFormatterByTime.string(from: dateObject)
            return month + " " + self.getFormatedDay(dateObject) + " " + time
        }
        return ""
    }
    
    public class func getTime (_ date: Date?) -> String {
        if let dateObject = date {
            let time = DateFormatter.dateFormatterByTime.string(from: dateObject)
            return time
        }
        return ""
    }
    
    public class func dateStringWithTime(from date: Date?) -> String {
        if let dateObject = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormat.dateAndTime
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            
            return dateFormatter.string(from: dateObject)
        }
        return ""
    }


    
    public class func getTimeMessages (_ date: Date?) -> String {
        if let dateObject = date {
            let time = DateFormatter.dateFormatterByTimeMessages.string(from: dateObject)
            return time
        }
        return ""
    }
    
    
    
    
    public class func getOnlyDate (_ date: Date) -> String {
        return DateFormatter.dateFormatterForCompare.string(from: date)
    }
    
    // Date format Like February 27th
    public class func getFormatedDate (_ date: Date) -> String {
        let month = DateFormatter.dateFormatterByFullMonthName.string(from: date)
        return month + " " + self.getFormatedDay(date)
        
    }
    
    // Date with "th, rd, nd"
    private static func getFormatedDay  (_ date: Date) -> String{
        
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        var day  = "\(anchorComponents.day!)"
        switch (day) {
        case "1" , "21" , "31":
            day.append("st")
        case "2" , "22":
            day.append("nd")
        case "3" ,"23":
            day.append("rd")
        default:
            day.append("th")
        }
        return day
        
    }
    
    private static let dateFormatterMonthDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.monthDateFormat
        return dateFormatter
    }()
    
    
    private static let dateFormatterByMonth: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.monthFormat
        return dateFormatter
    }()
    
    private static let dateFormatterByFullMonthName: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.month
        return dateFormatter
    }()
    
    
    private static let dateFormatterByTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.timeFormat
        return dateFormatter
    }()
    
    private static let dateFormatterByTimeMessages: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.timeFormatMessages
        return dateFormatter
    }()
    
    private static let dateFormatterForCompare: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    
}

class ETWAlertController: UIAlertController {
    
    private var alertWindow: UIWindow?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.alertWindow?.isHidden = true
        self.alertWindow = nil
    }
    
    func show(_ animated: Bool, completion: (() -> Swift.Void)? = nil) {
        self.alertWindow = UIWindow(frame: UIScreen.main.bounds)
        self.alertWindow?.rootViewController = UIViewController()
        self.alertWindow?.tintColor = AppDelegate.shared.window?.tintColor
        
        // window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
        if let topWindow =  UIApplication.shared.windows.last {
            self.alertWindow?.windowLevel = topWindow.windowLevel + 1;
        }
        self.alertWindow?.makeKeyAndVisible()
        self.alertWindow?.rootViewController?.present(self, animated: animated, completion: completion)
        
    }
}

class UILabelStatus: UILabel {
    //define padding
    var insets = UIEdgeInsets()//default
    
    //override drawText
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + insets.left + insets.right
        let heigth = superContentSize.height + insets.top + insets.bottom
        return CGSize(width: width, height: heigth)
    }
    
    public func setInsets(insets: UIEdgeInsets){
        self.insets = insets
    }
}


//MARK: UILabel extension for FomrattedText, this will takes the font assigned to UILabel in storyboard
extension UILabel {
    func setHTMLFromString(htmlString: String) {
        let modifiedSystemFont = NSString(format:"<span style=\"font-family: '-apple-system', 'Roboto'; font-size: \(self.font!.pointSize)\">%@</span>" as NSString, htmlString) as String
        
        //process collection values
        let htmlAttrStr = try! NSAttributedString(
            data: modifiedSystemFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = htmlAttrStr
    }
}

