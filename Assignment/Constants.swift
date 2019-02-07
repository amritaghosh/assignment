//
//  Constants.swift
//  ETW
//
//  Created by Afshan Momin on 20/01/17.
//  Copyright © 2017 Ness Digital Engineering. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

typealias NetworkRetrieverDownloadTaskDidWriteDataBlock = (Int64, Int64, Int64) -> Swift.Void
typealias NetworkRetrieverDataTaskDidReceiveData = (Any?, NSError?) -> Swift.Void
typealias TouchIDEvaluation = (Bool, Error?) -> Swift.Void
typealias RefreshToken = (Bool) -> Swift.Void
public typealias AlertBarAction = () -> Swift.Void
public typealias ActionSheetHandler = (Bool) -> Swift.Void
public typealias CompletionHandler = () -> Swift.Void

let kScreenHeight_iPhone5x: CGFloat                 =  568.0
let kScreenHeight_iPhoneX: CGFloat                  =  812.0





// Set Environment for API
let currentEnvironment: Environments = Environments.Development





enum Environments {
    case Development
    case Staging
    case Production
}


struct NetworkingConstants {
    static let DataHeaderContentType    = "application/x-www-form-urlencoded"

    static let DataHeaderAccept         = "application/json"
    static let DataHeaderAcceptCharset  = "UTF-8"
    static let BasicAuthorization       = "Authorization"
    static let DataHeaderMobile         = "YES"
    static let baseURLDevelopment       = "http://13.233.218.85"
    static let baseURLStaging           = "https://api.stage.etw.com/"
    static let baseURLProduction        = "https://api.prod.etw.com/"
    static let baseURLDevelopmentImage   = "https://api.dev.etw.com"
    static let baseProcedure            = ""
    
    
    static func baseURL() -> String {
        switch currentEnvironment {
        case .Development:
            return NetworkingConstants.baseURLDevelopment
        case .Staging:
            return NetworkingConstants.baseURLStaging
        case .Production :
            return NetworkingConstants.baseURLProduction
        }
    }
    
}

struct ProfileImageConstant {
    static let PeopleInRoomProfileImageUpdateNotification = "PeopleInRoomProfileImageUpdateNotification"
    static let GoalActionItemProfileImageUpdateNotification = "GoalActionItemProfileImageUpdateNotification"
    static let AssigneeListProfileImageUpdateNotification = "AssigneeListProfileImageUpdateNotification"

}

struct PubNubConstants {
    struct Development {
        static let publishKey           = "pub-c-6c33c02c-4f42-4df9-bd35-f81d82cdec2a"
        static let subscribeKey         = "sub-c-8f77a54e-81e1-11e6-974e-0619f8945a4f"
    }
    struct Local {
        static let publishKey           = "pub-c-6c33c02c-4f42-4df9-bd35-f81d82cdec2a"
        static let subscribeKey         = "sub-c-8f77a54e-81e1-11e6-974e-0619f8945a4f"
    }
    struct Test {
        static let publishKey           = "pub-c-fef60540-da5e-4b5b-a290-fcdbb6df5c76"
        static let subscribeKey         = "sub-c-ab76f632-81e1-11e6-a68c-0619f8945a4f"
    }
    struct Staging {
        static let publishKey           = "pub-c-426964dd-07c9-4336-bdb9-478461b4e83b"
        static let subscribeKey         = "sub-c-cab3631e-81e1-11e6-974e-0619f8945a4f"
    }
    struct Production {
        static let publishKey           = "pub-c-128f19f5-8c49-4f32-b894-c91a7967a169"
        static let subscribeKey         = "sub-c-4b41d00e-81f8-11e6-bb6b-0619f8945a4f"
    }
    static var publishKey               = PubNubConstants.Development.publishKey
    static var subscribeKey             = PubNubConstants.Development.subscribeKey
}

struct NetworkingHeaders {
    static let ContentTypeHeaderField      = "Content-Type"
    static let AcceptHeaderField           = "Accept"
    static let AuthorizationHeaderField    = "Authorization"
    static let ClientIDHeaderField         = "ETWClientID"
    static let CookieHeaderField           = "cookie"
    static let CookieUserAccountHeaderField  = "Set-Cookie"
}

struct HttpMethods{
    static let httpGET      = "GET"
    static let httpPOST     = "POST"
    static let httpPUT      = "PUT"
    static let httpPATCH    = "PATCH"
    static let httpDELETE   = "DELETE"
    static let httpOptions  = "OPTIONS"
}

struct QueryParameters {
    // Authentication
    static let login                   = "/api/user/login"
    static let forgotPassword          = "reset"
    static let accountDetails          = "v1/users/%d?details=true" //pass <userId>
    static let logOut                  = "logout"
    static let refresh                 = "refresh"
    static let channelGroups           = "messaging/v1/users/%d/channelGroups"
    
    // Notes
    static let pageStartKey            = "?startKey=%@"
    static let notesUnreadMessages     = "communication/v1/messages/unread"
    static let archiveNote             = "communication/v1/messages/%@/archive"
    static let archiveAllNotes         = "communication/v1/messages/archive?messageids=%@"
    static let archiveNotesList        = "communication/v1/messages/archived"
    static let unarchiveNote           = "communication/v1/messages/%@/unarchive"
    
    // Goals
    static let userGoals               = "goal/v1/users/%d/goals" //pass <userId>
    //goal-notes
    static let goalNotes               = "goal/v1/goals/%d/goalType/%@/messages" //pass <goalId><goalType>
    static let goalStatus              = "goal/v1/goals/%d/goalType/%@" //pass goalId//goalType/ e.g /80//culture
    static let goalPlan                = "plan/v1/plans/%d" //plan associated with the goal// pass the planID
    static let addGoalNote             = "goal/v1/goals/%d/goalType/%@/messages" // goalId/goalType
    static let fetchAvatarImage          = "avatar/v1/avatars/users/%d/%@"
    
    
    //fetching single goal
    static let fetchUserGoal           = "goal/v1/goals/%d/goalType/%@"//method=get, passwith: goalId, goalType
    
    // Message
    static let archivedMessages       = "messaging/v1/channels/%d/archive?" //pass <channelId>
    static let messagesListCount      = "limit=50"
    static let paginationStartKey     = "end=%@&"
    static let readMessages           = "messaging/v1/channels/%d/read" //pass <channelId>
    static let addMessage             = "messaging/v1/channels/%d/archive" //pass <channelId>
    
    //Search Direct Message
    static let searchDirectMessages   = "useraccount/v1/users?query=%@" //pass <search string>
    
    // Create Direct Channel
    static let createDirectChannel   =  "messaging/v1/channels"
    
    static let retriveCurrentChannels = "messaging/v1/users/%d/channelGroups?grantAccess=false" //pass user id
    
    //Search People In Room
    static let searchPeopleInRoom    = "useraccount/v1/userList?%@" //pass <user IDs>
    
    //Leave DirectMessage
    static let leaveDirectMessage    = "messaging/v1/groups/%d/channels/%d" //pass <channelGroupId>, <channelId>
    
    //Settings
    static let settings               = "accountsettings/v1/settings"
    
    
    //Pinned Plan
    static let pinnedPlan                     = "plan/v1/pinnedPlans?kpiLimit=%d" //pass selccted KPI Limit
    static let pinnedPlanDetails              = "plan/v1/plans/%d/details?kpiLimit=%d" //pass selccted PlanID
    static let pinnedPlanForPeople            = "plan/v1/mobile/users/%d/plans?kpiLimit=%d" //pass selccted, User and KPI Limit

    
    //Actionitems
    static let actionItemsList       = "actionitem/v1/users/%d/actionitems?completed=false" //user ID
    static let actionItemComplete    = "actionitem/v1/actionitems/%d" //ActionItem ID
    //CompletedActionitems
    static let completedActionItemsList       = "actionitem/v1/users/%d/actionitems?ascending=true&completed=true&pageNumber=%d&pageSize=%d&sortBy=dueDate" //user ID
    
    //ActionitemsGoals
    static let goalActionItemsList               = "actionitem/v1/goals/%d/goalType/%@/actionitems?completed=false" //Goal ID, GoalType
    static let goalCompletedActionItemsList      = "actionitem/v1/goals/%d/goalType/%@/actionitems?ascending=true&completed=true&pageNumber=%d&pageSize=%d&sortBy=dueDate" //Goal ID, GoalType
    
    //SingleUser
    static let singleUserInfo                   = "useraccount/v1/users/%d" //user ID
    
    //ActionitemsDetails
    static let actionItemDetails                = "actionitem/v1/actionitems/%d" //user ID
    
    static let actionItemAssigneeList           = "actionitem/v1/goals/%d/goalType/%@/assignable_users" //Goal Id, GoalType
 
    static let actionItemAssigneeUserList       = "useraccount/v1/userList?userAccountIds=%@" //user Array
    static let createActionItem                 = "actionitem/v1/actionitems"
    static let manageAssignAssigneeList         = "useraccount/v1/users/peoplepage" //Goal Id, GoalType

    //MeetingSeries
    static let meetingSeriesList                = "meeting/v1/users/%d/series" //user ID
    static let pendingMeetingList               = "meeting/v1/users/%d/series/%d/instances?ascending=false&completed=false&pageNumber=0&pageSize=25&sortBy=date" //userId,seriesId, Pagestart, Pagesize
    static let completedMeetingList             = "meeting/v1/users/%d/series/%d/instances?ascending=false&completed=true&pageNumber=0&pageSize=25&sortBy=date" //userId,seriesId, Pagestart, Pagesize

    static let meetingDetailTopics               = "meeting/v1/mobile/instances/%d" // meetingInstanceId
    
    // Search PeopleList
    static let searchPeopleList                  = "useraccount/v1/users/%d/direct-reports"

    // Search PeopleProfile
    static let peopleProfile                     = "useraccount/v1/users/%d" // peopleID

    
    // Search Upload Attached Image
    static let attachedImage                     = "goal/v1/goals/%d/goalType/%@/files" // goalId, goalType

}


struct NetworkingTasks {
    static let systemCheckTask                  = "systemCheckTask"
    static let loginTask                        = "LoginTask"
    static let resetPasswordTask                = "ResetPasswordTask"
    static let signOutTask                      = "SignOutTask"
    static let refreshTokenTask                 = "RefreshTokenTask"
    static let myAccountTask                    = "UserInfoTask"
    static let userNotesUnreadMessageTask       = "UserNotesUnreadMessageTask"
    static let archiveNoteTask                  = "ArchiveNoteTask"
    static let archiveAllNotesTask              = "ArchiveAllNotesTask"
    static let someTask                         = "SomeTask"
    static let userGoalsTask                    = "UserGoalsTask"
    //goal-notes
    static let changeGoalStatusTask             = "ChangeGoalStatusTask"
    static let addGoalNoteTask                  = "AddGoalNoteTask"
    static let replyGoalNoteTask                = "ReplyGoalNoteTask"
    static let progressGoalNoteTask             = "ProgressGoalNoteTask"
    static let statusGoalNoteTask               = "StatusGoalNoteTask"

    static let avatarImageTask                  = "AvatarImageTask"
    static let archivedMessagesTask             = "ArchivedMessagesTask"
    static let readMessagesTask                 = "ReadMessagesTask"
    static let leaveDirectMessagesTask          = "LeaveDirectMessagesTask"
    static let rejoinDirectMessagesTask         = "RejoinDirectMessagesTask"
    static let pinnedPlanTask                   = "PinnedPlanTask"
    static let pinnedPlanForPeopleTask          = "PinnedPlanForPeopleTask"

    static let pinnedPlanDetailsTask            = "PinnedPlanDetailsTask"
    static let settingsTask                   = "SettingsTask"
    static let actionItemsListTask            = "ActionItemsListTask"
    static let swapCompleteActionItemsListTask  = "SwapCompleteActionItemsListTask"
    static let completeActionItemsListIncompleteTask  = "CompleteActionItemsListIncompleteTask"
    static let completeActionItemsListCompleteTask  = "CompleteActionItemsListCompleteTask"

    static let completedActionItemsListTask   = "CompletedActionItemsListTask"
    
    static let goalActionItemsListTask            = "GoalActionItemsListTask"
    static let actionItemsDetailsTask             = "ActionItemsDetailsTask"
    static let actionItemsDeleteTask             = "ActionItemsDeleteTask"
    static let actionItemsUpdatePercentageTask        = "ActionItemsUpdatePercentageTask"
    static let actionItemsUpdateTitleTask             = "ActionItemsUpdateTitleTask"
    static let actionItemsUpdateDescriptionTask       = "ActionItemsUpdateDescriptionTask"
    static let actionItemsUpdateDateTask              = "ActionItemsUpdateDateTask"
    static let actionItemsAssigneeListTask            = "ActionItemsAssigneeListTask"
    static let actionItemsUsersAccountAssigneeListTask            = "ActionItemsUsersAccountAssigneeListTask"
    static let createActionItemsTask                  = "CreateActionItems"


    // Meetings
    static let meetingSeriesTask                = "MeetingSeriesTask"
    static let pendingMeetingTask               = "PendingMeetingTask"
    static let completedMeetingTask             = "CompletedMeetingTask"
    static let meetingDetailTopicsTask          = "MeetingDetailTopicsTask"
    
    // People
    static let peopleSearchListTask             = "PeopleSearchListTask"
    static let peopleProfileTask                = "PeopleProfileTask"

    //search direct messages
    static let searchDirectMessagesTask         = "SearchDirectMessagesTask"
    
    //create direct channel
    static let createDirectChannel              = "CreateDirectChannel"
    static let retrieveCurrentChannels          = "RetrieveCurrentChannels"
    static let addMessagesTask                  = "AddMessagesTask"
    static let avatarGoalActionItemImageTask    = "GoalActionItemAvatarImageTask"
    static let singleUserTask                   = "SingleUserTask"
    
    
}

//Error Message From Server

struct ErrorMessage {
    
    struct Server {
        static let error                        = "Error accessing server."
        static let unknownGoalType              = "This message could not be saved."
        static let addNoteError                 = "Unknown goal type"
        static let unexpectedEndOfInput         = "Unexpected end-of-input: was expecting closing quote for a string value"
        
    }
    
    struct Login {
        static let invalidCompanyID             = "No message available"
        static let invalidUsernameorPassword    = "Bad credentials"
    }
    
    struct UserInfo {
        static let userNotFound                 = "User account not found"
    }
    
    struct ForgotPassword {
        static let notFoundEmailId              = "The email address you entered does not match any user accounts, please see your system admin for further help."
    }
    
    struct Notes {
        static let retrieve                      = "Notes could not be retrieved."
        static let archiveNote                   = "Goal message not found"
        static let archiveAllNotes               = "Goal message not found"
        static let unarchiveNote                 = "Goal message not found"
    }
    
    struct Goals {
        static let retrieve                      = "Goals could not be retrieved."
        static let notesRetrive                  = "Goal notes could not be retrieved."
    }
    
    struct ActionItem {
        static let notAssigned                      = "Must be assignee or in boss chain to view personal action item."
    }
    
    struct Plan {
        static let accessDenied                      = "Access is denied"
         static let notRetrive                       = "Plans for this person could not be retrived"
    }

    
    
}

struct ErrorDomain  {
    static let loginErrorDomain                 = "com.etw.error.authentication"
    static let forgotpasswordErrorDomain        = "com.etw.error.forgotpassword"
    static let userInfoErrorDomain              = "com.etw.error.userInfo"
    static let logoutErrorDomain                = "com.etw.error.logout"
    static let noteErrorDomain                  = "com.etw.error.note"
    static let archiveNoteErrorDomain           = "com.etw.error.archivenote"
    static let archiveAllNotesErrorDomain       = "com.etw.error.archivenotes"
    static let unarchiveNoteErrorDomain         = "com.etw.error.unarchivenote"
    static let goalsErrorDomain                 = "com.etw.error.goals"
    static let goalNotesErrorDomain             = "com.etw.error.goalnotes"
    static let serverErrorDomain                = "com.etw.error.server"
    static let channelGroupsErrorDomain         = "com.etw.error.channelgroups"
    static let createDirectChannelErrorDomain   = "com.etw.error.createDirectChannel"
    static let actionItemErrorDomain            = "com.etw.error.actionItem"
    static let planErrorDomain                  = "com.etw.error.plan"

    
}

struct ErrorCode {
    struct Login {
        static let invalidCompanyID                 = 1000
        static let invalidUsernameorPassword        = 1001
        static let errorAccessingServer             = 1002
    }
    
    struct UserInfo {
        static let userNotFound                      = 1010
    }
    
    struct ForgotPassword {
        static let notFoundEmailId                   = 1020
    }
    
    struct Notes {
        static let retrieve                         = 1030
        static let archiveNote                      = 1031
        static let archiveAllNotes                  = 1032
        static let unarchiveNote                    = 1033
    }
    
    struct Goals {
        static let retrieve                         = 1040
        static let notesRetrive                     = 1041
    }
    
    struct Server {
        static let operationNotCompleted            = 1050
        static let lostConnection                   = 1051
        static let unknownGoalType                  = 1052
        static let unexpectedEndOfInput             = 1053
        static let errorAccessingServer             = 1054
        
    }
    
    struct ActionItem {
        static let notAssigned                         = 1060
    }

    struct Plan {
        static let accessDenie                         = 1070
    }

}



struct SegueIdentifier {
    static let showLoginTerms                               = "kShowLoginTermsViewController"
    static let showChooseUserID                             = "kChooseIDViewController"
    static let showSettings                                 = "kSettingsViewController"
    static let showGoalsView                                = "kGoalsViewController"
    static let showArchiveNotesView                         = "kShowArchivedNotesViewController"
    static let showNoNotesViewControllerFromUnreadNotes     = "kShowNoNotesViewControllerFromUnreadNotes"
    static let showNoNotesViewControllerFromArchivedNotes   = "kShowNoNotesViewControllerFromArchivedNotes"
    static let showNoGoalsViewControllerFromGoals           = "kShowNoNotesViewControllerFromGoals"
    static let showGoalNotesListView                        = "kShowGoalNotesListView"
    static let goalStatusViewController                     = "kGoalStatusViewController"
    static let unwindSegueToGoalNotesListViewController     = "kUnwindSegueToGoalNotesListViewController"
    static let replyGoalNoteViewController                  = "kReplyGoalNoteView"
    static let unwindToGoalCardsListViewController          = "kunwindToGoalCardsList"
    static let unwindToGoalNotesListViewController          = "kCancelToGoalNotesList"
    static let unwindToGoalNoteToNote                       = "kUnwindToNote"
    static let showRoomDirectMessageListView                = "kShowRoomDirectMessageListView"
    static let unwindToMessagesViewController               = "kUnwindToMessagesList"
    static let searchDirectMessage                          = "kSearchDirectMessage"
    static let showPeopleInRoomListView                     = "kShowPeopleInRoomListView"
    static let unwindSegueToSettingsViewController          = "kUnwindSegueToSettingsViewController"
    static let showPlanDetails                              = "kShowPlanDetails"
    static let actionItemDetailViewController               = "kActionItemDetailViewController"
    static let newActionItemDetail                          = "kNewActionItemDetail"
    static let meetingsSeriesListInstance                   = "kMeetingsSeriesListInstance"
    static let meetingDetailViewController                  = "kMeetingsInstanceTopics"
    static let peopleProfileIdentifier                      = "kPeopleProfileIdentifier"
}

struct StoryboardName {
    static let main = "Main"
    static let mainWithActionItem = "MainWithActionItem"
    static let mainWithMessage = "MainWithMessage"
    static let mainWithActionItemMessage = "MainWithActionItemMessage"
    static let authentication = "Authentication"
    static let goals = "Goals"
    static let goalsHome = "GoalsHome"
    static let alerts = "Alerts"
    static let menu = "Menu"
    static let addreply = "AddReply"
    static let addMessage = "AddMessage"
    static let messageList = "MessageList"
    static let plan = "Plans"
    static let meeting                = "Meetings"
    static let peopleSearchList       = "PeopleSearchList"
    static let plansPeople = "PlansPeople"
    static let actionItemsPeople      = "ActionItemsPeople"
    static let goalsPeople            = "GoalsPeople"
    static let progressImprove        = "ProgressImprove"
    static let statusImprove          = "StatusImprove"
    static let addNoteConversation    = "AddNoteConversation"
    static let imageView              = "ImageView"

}

struct StoryboardIdentifier {
    static let loginViewController       = "kLoginViewController"
    static let loadingViewController     = "kLoadingViewController"
    static let alertBarViewController    = "kAlertBarViewController"
    static let notesViewController       = "kNotesViewController"
    static let noNotesViewController     = "kNoNotesViewController"
    static let noGoalsViewController     = "kNoGoalsViewController"
    static let goalsContainerViewController = "kGoalsContainerViewController"
    static let goalsViewController       = "kGoalsViewController"
    static let goalsCardListViewController       = "kGoalsCardListViewController"
    static let messagesListViewController       = "kMessagesListViewController"
    static let searchContainerViewController = "kSearchContainerViewController"
    static let searchDirectMessageListViewController = "kSearchMsgListViewController"
    static let searchPeopleListViewController = "kSearchMsgListViewController"
    static let assigneePeopleListViewController = "kAssigneePeopleListViewController"
    static let plansViewController       = "kPlansViewController"
    static let plansContainerViewController       = "kPlansContainerViewController"
    static let noPlansViewController       = "kNoPlansViewController"
    static let actionItemsListViewController       = "kActionItemsListViewController"
    static let completedActionItemsListViewController       = "kCompletedActionItemsListViewController"
    
    static let goalActionItemsListViewController             = "kGoalActionItemsListViewController"
    static let goalCompletedActionItemsListViewController    = "kGoalCompletedActionItemsListViewController"
    static let completedGoalActionItems                      = "kCompletedGoalActionItems"
    static let newGoalActionItemDetail                       = "kNewGoalActionItemDetail"
    static let completedActionItems                          = "kCompletedActionItems"
    static let meetingSeriesListTableViewController          = "kMeetingSeriesListTableViewController"
    static let meetingSeriesContainerViewController          = "kMeetingSeriesContainerViewController"
    static let peopleSearchListContainerViewController       = "kPeopleSearchListContainerViewController"
    static let peopleSearchListTableViewController           = "kPeopleSearchListTableViewController"
    static let actionItemsContainerViewController            = "kActionItemsContainerViewController"
    static let progressImproveTableViewController            = "kProgressImproveTableViewController"
    static let statusImproveTableViewController              = "kStatusImproveTableViewController"
    static let goalNoteConversationTableViewController       = "kGoalNoteConversationTableViewController"
    static let imageDisplayViewController                    = "kImageDisplayViewController"

}


struct StoryboardCellIdentifier {
    static let homeTableViewCell            = "kHomeTableViewCell"
    static let notesTableViewCell           = "kNotesTableViewCell"
    static let notesSectionsHeaderView      = "kNotesSectionsHeaderView"
    static let goalsCardTableViewCell       = "kGoalsCardCell"
    static let goalNotesHeaderViewCell      = "kGoalNotesHeaderViewCell"
    static let goalNotesListViewMainCell    = "kGoalNotesListViewMainCell"
    static let goalNotesListViewSubCell     = "kGoalNotesListViewSubCell"
    static let goalNotesListViewSubLastCell = "kGoalNotesListViewSubLastCell"
    static let goalsSectionsHeaderView      = "kGoalsSectionsHeaderView"
    static let alertBarListCell             = "kAlertBarListCell"
    static let alertBarNoInternetCell       = "kAlertBarNoInternetCell"
    static let chooseIDTableViewCell        = "kChooseIDTableViewCell"
    static let chooseDifferentUserIDTableViewCell   = "kChooseDifferentUserIDCell"
    static let goalStatusTableViewCell      = "kGoalStatusCell"
    static let messageListTableViewCell       = "kMessageListTableViewCell"
    static let messagesSectionHeaderView      = "kMessagesHeaderView"
    static let roomDirectMessageListTableViewCell       = "kRoomDirectMessageListTableViewCell"
    static let searchDirectMsgTableCell       = "kSearchRoomTableViewCell"
    static let plansTableViewCell           = "kPlansTableViewCell"
    static let touchIDTableViewCell           = "kTouchIDTableViewCell"
    static let plansCardTableViewCell           = "kPlansCardTableViewCell"
    static let maxKPITableViewCell                        = "kMaxKPITableViewCell"
    static let plansKPITableViewCell                      = "kPlansKPITableViewCell"
    static let plansKPIDataSeriesTableViewCell            = "kPlansKPIDataSeriesTableViewCell"
    
    static let goalSectionsHeaderView                     = "kGoalSectionsHeaderView"
    
    static let plansDetailsKPITableViewCell               = "kPlansDetailsKPITableViewCell"
    static let plansDetailsKPICell                       = "kPlansDetailsKPICell"
    static let plansDetailsKPIDataSeriesTableViewCell     = "kPlansDetailsKPIDataSeriesTableViewCell"
    static let planGoalsViewCell                          = "kPlanGoalsViewCell"
    static let actionItemsListTableViewCell               = "kActionItemsListTableViewCell"
    static let goalActionItemsListTableViewCell           = "kGoalActionItemsListTableViewCell"
    static let actionItemTitleDescriptionCell             = "kActionItemTitleDescriptionCell"
    static let actionItemDueDateCell                      =  "kActionItemDueDateCell"
    static let actionItemAssigneeCell                     = "kActionItemAssigneeCell"
    static let actionItemProgressCell                     = "kActionItemProgressCell"
    static let actionItemCreatedByCell                    = "kActionItemCreatedByCell"
    static let actionItemDescriptionCell                  = "kActionItemDescriptionCell"
   static let actionItemExpandAssigneeCell               = "kActionItemExpandAssigneeCell"
    static let actionItemPlanGoalCell                     = "kActionItemPlanGoalCell"
    static let actionItemGoalCell                         = "kActionItemGoalCell"
    static let actionItemDetailMeetingCell                = "kActionItemDetailMeetingCell"
    static let actionItemDatePickerCell                   = "kActionItemDatePickerCell"
    static let meetingSeriesHeaderView                    = "kMeetingSeriesHeaderView"
    static let meetingSeriesListTableViewCell             = "kMeetingSeriesListTableViewCell"
    static let meetingDetailsCell                         = "kMeetingDetailsCell"
    static let noTopicsViewCell                           = "kNoTopicsViewCell"
    static let meetingInstanceHeaderCell                  = "kMeetingInstanceHeaderCell"
    static let meetingInstanceNoteView                    = "kMeetingInstanceNoteView"
    static let actionItemsInMeetingTableViewCell          = "kActionItemsInMeetingTableViewCell"
    static let progressSliderTableViewCell                = "kProgressSliderTableViewCell"
    static let milestoneTableViewCell                     = "kMilestoneTableViewCell"
    static let milestoneTextViewTableViewCell             = "kMilestoneTextViewTableViewCell"
    static let incrementalTextViewTableViewCell           = "kIncrementalTextViewTableViewCell"
    static let incrementalTableViewCell                   = "kIncrementalTableViewCell"
    static let statusImproveTableViewCell                 = "kStatusImproveTableViewCell"
    static let addConversationTableViewCell               = "kAddConversationTableViewCell"

    
}

struct NibName {
    static let alertBar = "AlertBarView"
    static let  goalsSectionsHeaderView      = "GoalsSectionsHeaderView"
}

struct NavigationTile {
    static let editAddNote      = "Add Note"
    static let editReplyNote    = "Reply Note"
    static let editAddMessage   = "Add Message"
    static let progressImprve   = "Progress-Improve"
    static let progressRegress  = "Progress-Regress"
    static let statusImprove    = "Status-Improve"
    static let statusRegress    = "Status-Regress"
    static let generalNote      = "General Note"

    
}

struct CreateNewActionItem {
    static let user        = "user"
    static let title       = "title"
    static let description = "description"
    static let completed   = "completed"
    static let type        = "type"
    static let progress    = "progress"
    static let dueDate     = "dueDate"
}

struct PlaceholdderImages {
    
    // Page Outlines
    static let page1 = #imageLiteral(resourceName: "PageTemplateNextGen1")
    static let page2 = #imageLiteral(resourceName: "PageTemplateNextGen2")
    static let page3 = #imageLiteral(resourceName: "PageTemplateNextGen3")
    static let page4 = #imageLiteral(resourceName: "PageTemplateNextGen4")
}

enum ViewMode {
    case Drawer
    case FullScreen
    case FullScreenViewOnly
}

enum AddReplyViewMode {
    case normal
    case editAdd
    case addMessage
}

enum GoalNoteViewMode {
    case goal
    case note
    case plansGoal
}

enum ActionItemDetailMode {
    case personal
    case managerAssign
    case goal
    case meeting
}


enum AlertType {
    case error
    case warning
    case success
    case userInfo
    
    var color: UIColor {
        switch self {
        case .error: return #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)//= 0xF44336
        case .warning: return #colorLiteral(red: 1, green: 0.5960784314, blue: 0, alpha: 1)//= 0xFF9800
        case .success: return #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)//= 0x4CAF50
        case .userInfo: return #colorLiteral(red: 0.3333333333, green: 0.3490196078, blue: 0.3607843137, alpha: 1)//= 0x818A91
        }
    }
}

struct ActionItem {
    struct DetailsScreen {
        static let title            = "TITLE"
        static let description      = "DESCRIPTION"
        static let due              = "DUE"
        static let assignee         = "ASSIGNEE"
        static let assignor         = "ASSIGNOR"
        static let progress         = "PROGRESS"
        static let supports         = "SUPPORTS"
        static let activity         = "ACTIVITY"
        static let titlePlaceholder            = "Title"
        static let descriptionPlaceholder      = "Description"
        static let progressPercentage    = "Progress Percentage"
        
    }
}

struct AlertMessages {
    struct Authentication {
        static let loginNoService = "Error accessing server to login."
        static let badCredentials = "Please check your login credentials."
        static let touchIdDisabled = "Touch ID disabled."
        static let touchIdEnabled = "Touch ID enabled."
        
        static let touchIdPasscodeNotSetTitle   = "Touch ID Isn't Set Up on This Device"
        static let touchIdPasscodeNotSetMessage = "To set up Touch ID on this device, go to Settings > Touch ID & Passcode and add a valid fingerprint."
        
        struct PasswordReset {
            static let successTitle = "Your Request Has Been Sent!"
            static let successMessage = "Please check your email inbox"
            static let error = "There was a problem resetting your password. Please try again."
            static let invalidEmail = "Please enter a valid email address"
        }
        
        struct EnableTouchID {
            static let title = "Verify with Password"
            static let message = "To enable Touch ID please revalidate your password."
            static let success = "Touch ID enabled!"
        }
        
        struct DisableTouchID {
            static let title    = "Alert"
            static let message  = "Touch ID is not available"
            static let success = "Touch ID disabled."
        }
    }
    
    struct AddReplyNote {
        static let addNoteserverError       = "Add Note could not be sent.\n Do you wish to retry ?"
        static let replyNoteserverError     = "Reply Note could not be sent.\n Do you wish to retry ?"
        static let inProgress               = "Add note process in progress"
        static let inProgressReplyNote      = "Reply note process in progress"
        static let inProgressAddMessage      = "Add message process in progress"
        static let delete                   = "Newly added note was not saved. Are you sure you want to delete the note ?"
        static let deleteMessage            = "Newly added message was not saved. Are you sure you want to delete the message ?" // TODO Need to be check from ETW
        static let discard                  = "Are you sure you want to discard changes ?"
    }
    
    struct DeleteActionItem {
        static let deleteActionItem       = "Delete ActionItem"
        static let deleteItem             = "Are you sure you want to delete Action Item?"

    }

    struct AddMessageList {
        static let addMessageServerError       = "New message is not added. \n Do you wish to retry ?" // TODO Need to be check from ETW
    }
    
    struct Reachability {
        static let noInternet = "Internet Connection not available."
        static let offline = "Internet connection lost. Please reconnect."
    }
    
    struct Notification {
        static let noSubscription = "You are not subscribed to receive any Notifications."
    }
    
    struct RequestTimedOut {
        static let title = "Request Timed Out."
        static let message = "Internet connection lost. Please reconnect."
    }
    struct ServerError {
        static let message = "Server error. Please reconnect."
        static let login = "Error accessing server to login."
        static let access = "Error accessing server."
    }
    struct GoalsError {
        static let retrieve         = "Goals could not be retrieved."
        static let retrieveNotes    = "Goal notes could not be retrieved."
        static let nolongerAvailable     = "The goal is no longer available"
        
        struct StatusUpdate {
            static let inactive = "Goal must be in \"Active\" to update status."
            static let permission = "You do not have permission to update."
        }
        
        struct AddNote {
            static let inactive     = "Goal must be in \"Active\" to add note."
            static let permission   = "You do not have permission to add."
        }
    }
    
    struct logout {
        static let confirmation = "Are you sure you want to delete the note and logout ?"
        static let confirmationMessage = "Are you sure you want to delete the message and logout ?"
    }
    
    struct NotesError {
        static let retrieve   = "Notes could not be retrieved."
        static let archive    = "Note could not be archived."
        static let archiveAll = "Notes could not be archived."
        static let unarchive  = "Note could not be unarchived."
        static let corrupted  = "Note could not be converted to HTML."
    }
    
    struct GenericError {
        static let retry      = "Something went wrong. Please retry"
    }
    
    
}

typealias AlertsStructure = (type: AlertType, message: String)


struct Alerts {
    // Login Screen
    static let loginServerAccess = (AlertType.error, AlertMessages.ServerError.login)
    static let badCredentials = (AlertType.error, AlertMessages.Authentication.badCredentials)
    static let serverAccess = (AlertType.error, AlertMessages.ServerError.access)
    
    // Forgot Password
    static let passwordResetError = (AlertType.error, AlertMessages.Authentication.PasswordReset.error)
    static let invalidEmailError = (AlertType.error, AlertMessages.Authentication.PasswordReset.invalidEmail)
    
    // Touch ID
    static let touchIdEnableSuccess = (AlertType.success, AlertMessages.Authentication.EnableTouchID.success)
    static let touchIdDisableSuccess = (AlertType.userInfo, AlertMessages.Authentication.DisableTouchID.success)
    
    // Notifications
    static let noSubscription = (AlertType.userInfo, AlertMessages.Notification.noSubscription)
    
    // Notes
    static let retrieveNotes = (AlertType.error, AlertMessages.NotesError.retrieve)
    static let archive = (AlertType.error, AlertMessages.NotesError.archive)
    static let archiveAll = (AlertType.error, AlertMessages.NotesError.archiveAll)
    static let unarchive = (AlertType.error, AlertMessages.NotesError.unarchive)
    static let corrupted = (AlertType.error, AlertMessages.NotesError.corrupted)
    static let notesRetrieve = (AlertType.error, AlertMessages.NotesError.retrieve)
    static let addNoteInProgress = (AlertType.userInfo, AlertMessages.AddReplyNote.inProgress)
    static let replyNoteInProgress = (AlertType.userInfo, AlertMessages.AddReplyNote.inProgressReplyNote)
    static let addMessageInProgress = (AlertType.userInfo, AlertMessages.AddReplyNote.inProgressAddMessage)
    
    // Goals
    static let retrieveGoals = (AlertType.error, AlertMessages.GoalsError.retrieve)
    static let retrieveGoalNotes = (AlertType.error, AlertMessages.GoalsError.retrieveNotes)
    static let updateStatusError = (AlertType.userInfo, AlertMessages.GoalsError.StatusUpdate.inactive)
    static let updateStatusPermissionError = (AlertType.error, AlertMessages.GoalsError.StatusUpdate.permission)
    static let goalIsNolognerAvailable = (AlertType.error, AlertMessages.GoalsError.nolongerAvailable)
    
    static let addNoteError = (AlertType.userInfo, AlertMessages.GoalsError.AddNote.inactive)
    static let addNotePermissionError = (AlertType.error, AlertMessages.GoalsError.AddNote.permission)
    static let goalsRetrieve = (AlertType.error, AlertMessages.GoalsError.retrieve)
    
    
    // ActionItem
    static let actionItemNotAssigned = (AlertType.error, ErrorMessage.ActionItem.notAssigned)

    // ActionItem
    static let planNotRetrived = (AlertType.error, ErrorMessage.Plan.notRetrive)

    
    // Reachability
    static let noInternet = (AlertType.error, AlertMessages.Reachability.offline)
    static let offline = (AlertType.error, AlertMessages.Reachability.offline)
    static let serverError = (AlertType.error, AlertMessages.ServerError.message)
    
    //Server
    static let server = (AlertType.error, ErrorMessage.Server.error)
    static let unknownGoalType = (AlertType.error, ErrorMessage.Server.unknownGoalType)
    
    
    static let genericError = (AlertType.error, AlertMessages.GenericError.retry)
    
    
    
}


struct SettingsMessages {
    struct ActionSheet {
        struct TouchID {
            static let title                = "Disable Touch ID"
            static let message              = "Are you sure you want to turn off Touch ID?"
            static let acceptButtonText     = "Yes"
            static let declineButtonText    = "No"
        }
    }
    
    struct text {
        static let signIn                = "SIGN IN"
        static let plans                 = "PLANS"
        static let plansKPI              = "Max KPI on Plan Cards"
    }
}

struct ContactSupportText {
    struct Email {
        static let id                   = "support@etw.com"
        static let subject              = "Help - Contact Support"
        static let messageBody          = "Sending e-mail from ETW app"
    }
}

struct LoginTermsText {
    static let firstPartRegular           = "To enable Touch ID ® for sign in, you are required to save your Company ID and Username on this device.\n\n "
    static let secondPartMedium           = "Once Touch ID ® is enabled, you understand and agree that any Touch ID ® fingerprint stored on this device can be used to access your accounts for ETW.\n\n"
    static let thirdPartRegular           = "ETW neither controls the functionality of Touch ID ® nor has access to your fingerprint information.\n\nThere may be circumstances where Touch ID ® will not function as expected and we may ask you to sign in using your Password.\n\nBy choosing Accept, you agree to these terms and conditions. Choose Decline to cancel set up of Touch ID ® for ETW.\n\n"
}

struct SectionForGoals {
    static let performanceGoal             = "PERFORMANCE GOALS"
    static let roleGoal                    = "ROLE GOALS"
    
}

struct UserGoals{
    static let alignmentGoals   = "alignmentGoals"
    static let performanceGoals = "performanceGoals"
    static let allGoals         = "allGoals"
}

struct LabelStrings {
    static let dueDate                  = "DUE: "
    static let untitledGoal             = "Untitled Goal"
    static let untitledPlan             = "Untitled Plan"
    static let managerAssignGoalType    = "Manager Assigned"
    
}

struct MessagesStrings {
    static let group                  = "GROUP"
    static let rooms                  = "ROOMS"
    static let directMessages         = "DIRECT MESSAGES"
    static let teamAvailable          = "teamAvailable"
    static let notification           = "NOTIFICATION"
    static let channelMemberships     = "channelMemberships"
    static let team                   = "team"
    static let modules                = "modules"
    static let exp                    = "exp"
    static let authorities            = "authorities"
    static let feature                = "feature"
    static let communication          = "COMMUNICATION"
    static let enabled                = "enabled"
    static let direct                 = "DIRECT"
    static let memberIsHidden         = "memberIsHidden"
    static let directCheck            = "DIRECT"
    static let plan                   = "PLAN"
    static let viewPlan               = "VIEW_PLANS"
    static let actionItems            = "ACTION_ITEMS"
    static let meetings               = "MEETINGS"
    static let people                 = "VIEW_PEOPLE_PEERS"
    static let managerialAuthority    = "DELEGATE_MANAGERIAL_AUTHORITY"

    
}

struct MessagesListGroup  {
    static let planGroup                 = "PLAN_GROUP"
    static let teamGroup                 = "TEAM_GROUP"
    static let privateGroup              = "PRIVATE_GROUP"
    static let publicGroup               = "PUBLIC_GROUP"
    static let directGroup               = "DIRECT"
    static let directYou                 = "DIRECT_YOU"
    
}

struct PlansListStatus  {
    static let onTrackCount              = "onTrackCount"
    static let atRiskCount               = "atRiskCount"
    static let fallingBehindCount        = "fallingBehindCount"
    static let noStatus                  = "noStatusCount"
    
}

struct PlansDetails  {
    struct TableViewSection  {
        static let kpi                       = "KEY PERFORMANCE INDICATORS"
        static let golas                     = "GOALS"
        static let suportingPlans            = "SUPPORTING PLANS"
    }
    
}

struct ActionItems  {
    struct TableViewSection  {
        static let dueSoon                   = "DUE SOON"
        static let overdue                   = "OVERDUE"
        static let upcoming                  = "UPCOMING"
    }
    
}



struct JsonKeys {
    
    struct Errors {
        static let type             = "error"
        static let status           = "status"
        static let message          = "message"
        static let path             = "path"
        static let timestamp        = "timestamp"
        static let debugMessage     = "debugMessage"
        
        struct RefreshToken {
            static let invalidToken     = "invalid_token"
            static let tokenParseFail   = "Token parse failed"
        }
    }
    
    struct JWT {
        static let access           = "access_token"
        static let refresh          = "refresh_token"
        static let authKey          = "auth_key"
    }
    
    static let responseHeader       = "responseHeader"
    static let response             = "response"
    
    struct Notes {
        static let totalCount       = "numFound"
    }
    
    struct NoteDetails {
        static let date             = "Date"
    }
    
    struct Goals {
        static let id                   = "id"
        static let alignmentGoalType    = "alignmentGoalType"
        static let plan                 = "plan"
        static let roleName             = "roleName"
        static let performanceGoalType  = "performanceGoalType"
        static let dueDate              = "dueDate"
        static let state                = "state"
        static let status               = "status"
        static let title                = "title"
        static let groupTitle           = "groupTitle"
        static let goalGroup            = "goalGroup"
        static let groupSortId          = "groupSortId"
        static let assignees            = "assignees"
        static let participants         = "participants"
        static let viewers              = "viewers"
    }
    
    struct NotesUnreadMessage {
        static let date             = "createdDate"
        static let draft            = "draft"
        static let messageID        = "id"
        static let lastEvalKey      = "lastEvalKey"
        static let message          = "messageBody"
        static let subject          = "subject"
        static let author           = "author"
        static let goalId           = "goalId"
        static let goalTitle        = "goalTitle"
        static let goalType         = "goalType"
        static let parentMessageId  = "parentMessageId"
        static let userId  = "userId"

        
    }
    
    struct Author {
        static let alias             = "alias"
        static let firstName         = "firstName"
        static let id                = "id"
        static let lastName          = "lastName"
        static let terminationDate   = "terminationDate"
        static let userEnable        = "userEnabled"
        static let username          = "username"
        static let authorId          = "authorId"
        
    }
    
    struct Goal {
        static let createdDate          = "createdDate"
        static let dueDate              = "dueDate"
        static let grouped              = "grouped"
        static let id                   = "id"
        static let messageCount         = "messageCount"
        static let state                = "state"
        static let status               = "status"
        static let title                = "title"
        static let plan                 = "plan"
        static let alignmentGoalType    = "alignmentGoalType"
        static let performanceGoalType  = "performanceGoalType" 
        static let group                = "goalGroup"
        static let groupSortId          = "groupSortId"
        static let assignees            = "assignees"
        static let participants         = "participants"
        static let viewers              = "viewers"
        static let performanceGoalId    = "performanceGoalId"
        static let alignmentGoalId      = "alignmentGoalId"
        static let ownerSet             = "ownerSet"
        static let participantSet       = "participantSet"
        static let progress             = "progress"
        static let syncKpiStatus        = "syncKpiStatus"
        static let hasAutomaticProgress = "hasAutomaticProgress"

    }
    
    struct Role {
        static let id                 = "roleId"
        static let name               = "roleName"
        
    }
    
    struct Group {
        static let id                 = "goalGroup"
        static let title              = "groupTitle"
        static let sortId             = "groupSortId"
        
    }
    
    struct Plan {
        static let id                  = "id"
        static let title               = "title"
        static let ownerSet            = "ownerSet"
        static let participantSet      = "participantSet"
    }
    
    struct UserInfo {
        static let alias               = "alias"
        static let firstName           = "firstName"
        static let lastName            = "lastName"
        static let title               = "title"
        static let username            = "username"
        
    }
    
    struct ChannelGroups {
        static let channelMemberships = "channelMemberships"
        static let uuid               = "uuid"
        static let type               = "type"
    }
    
    struct PubNub {
        static let aps                = "aps"
        static let messageBody        = "messageBody"
        static let alert              = "alert"
        
    }
    
    
    struct ArchiveMessage {
        static let id             = "id"
        static let userId         = "userId"
        static let uuid           = "uuid"
        static let clientId       = "clientId"
        static let type           = "type"
    }
    
    struct ChannelMemberships {
        static let id                      = "id"
        static let userId                  = "userId"
        static let uuid                    = "uuid"
        static let clientId                = "clientId"
        static let type                    = "type"
        static let name                    = "name"
        static let isVisible               = "isVisible"
        static let unreadMessageCount      = "unreadMessageCount"
        static let isHidden                = "isHidden"
        static let members                 = "members"
        static let channelId               = "channelId"
        static let channelUuid             = "channelUuid"
        static let userName                = "userName"
        static let displayName             = "displayName"
        
    }
    
    struct SubscriberGroups {
        static let id                      = "id"
        static let userId                  = "userId"
        static let uuid                    = "uuid"
        static let clientId                = "clientId"
        static let type                    = "type"
    }
    
    struct Team {
        static let id                      = "id"
        static let clientId                = "clientId"
        static let title                   = "title"
        static let description             = "description"
        static let teamLeaderId            = "teamLeaderId"
        static let channelId               = "channelId"
    }
    
    struct DictionaryMessages {
        static let m_Id                    = "m_Id"
        static let m_userId                = "m_userId"
        static let m_uuid                  = "m_uuid"
        static let m_type                  = "m_type"
        
        static let cm_Id                   = "cm_Id"
        static let cm_uuid                 = "cm_uuid"
        static let cm_userId               = "cm_userId"
        static let cm_type                 = "cm_type"
        static let cm_name                 = "cm_name"
        static let cm_isVisible            = "cm_isVisible"
        static let cm_isHidden             = "cm_isHidden"
        static let cm_unreadMessageCount   = "cm_unreadMessageCount"
        static let cm_isMembers            = "cm_isMembers"
        static let cm_Members              = "members"
        static let cm_MembersArray              = "membersArray"
        
        
        
        static let team_title               = "team_title"
        static let team_teamLeaderId        = "team_teamLeaderId"
        static let team_id                  = "team_id"
        
        static let listNotAvailable         = "listNotAvailable"
        static let untitledRoom             = "Untitled Room"
        
    }
    
    struct  searchDirectMsg {
        static let id                         = "id"
        static let firstName                  = "firstName"
        static let lastName                   = "lastName"
        static let userName                   = "username"
        static let title                      = "title"
        static let alias                      = "alias"
        static let uuid                       = "uuid"
        static let reportsToId                = "reportsToId"
    }
    
    
    struct MessagesmessagesList {
        static let channelId               = "channelId"
        static let channelUuid             = "channelUuid"
        static let text                    = "text"
        static let userId                  = "userId"
        static let clientId                = "clientId"
        static let userName                = "userName"
        static let displayName             = "displayName"
        static let publishedDate           = "publishedDate"
        static let randomId                = "randomId"
        static let action                  = "action"
        static let person                  = "person"
        static let uuid                    = "uuid"
        static let id                      = "id"
        
    }
    
    struct PinnedPlans {
        static let id                        = "id"
        static let clientId                  = "clientId"
        static let title                     = "title"
        static let description               = "description"
        static let parentPlanId              = "parentPlanId"
        static let parentPlanTitle           = "parentPlanTitle"
        static let hasStrategy               = "hasStrategy"
        static let hasOutcomes               = "hasOutcomes"
        static let hasKpi                    = "hasKpi"
        static let hasReadiness              = "hasReadiness"
        static let hasSubplans               = "hasSubplans"
        static let hasGoals                  = "hasGoals"
        static let state                     = "state"
        static let atRiskCount               = "atRiskCount"
        static let fallingBehindCount        = "fallingBehindCount"
        static let onTrackCount              = "onTrackCount"
        static let noneCount                 = "noneCount"
        static let autoGenerateRequirements  = "autoGenerateRequirements"
        static let primaryOwnerId            = "primaryOwnerId"
        static let ownerSet                  = "ownerSet"
        static let participantSet            = "participantSet"
        static let viewOnlySet               = "viewOnlySet"
        static let ownerAssignments          = "ownerAssignments"
        static let planHierarchyList         = "planHierarchyList"
        static let isAccessible              = "isAccessible"
        static let overallPlanStatus         = "overallPlanStatus"
        static let channelId                 = "channelId"
        static let participantAssignments    = "participantAssignments"
        
        static let kpis                      = "kpis"
        static let series                    = "series"
        static let goal                      = "goals"
        static let subPlans                  = "subPlans"
        static let points                    = "points"
    }
    
    struct KPIList {
        static let status           = "status"
        static let actualSeries     = "actualSeries"
        static let planSeries       = "planSeries"
        static let newestPoint      = "newestPoint"
        static let oldestPoint      = "oldestPoint"
        static let createdDate      = "createdDate"
        static let date             = "date"
        static let number           = "number"
        static let comment          = "comment"
        static let plan             = "plan"
        static let format           = "type"
    }
    
    struct DataSeries {
        static let name             = "name"
        static let isPlan           = "isPlan"
        static let isActual         = "isActual"
    }
    
    struct GoalsPlan {
        static let alignmentGoalType             = "alignmentGoalType"
        static let clientId                      = "clientId"
        static let dueDate                       = "dueDate"
        static let id                            = "id"
        static let performanceGoalType           = "performanceGoalType"
        static let sortId                        = "sortId"
        static let state                         = "state"
        static let status                        = "status"
        static let title                         = "title"
        static let userContributable             = "userContributable"
        static let userEditable                  = "userEditable"
    }
    
    
    struct SearchInPeopleList {
        static let firstName           = "firstName"
        static let lastName            = "lastName"
        static let username            = "username"
        static let id                  = "id"
        static let title               = "title"
        static let alias               = "alias"
        static let userEnabled         = "userEnabled"
    }
    
    struct ActionItems {
        static let records                   = "records"
        static let id                        = "id"
        static let clientId                  = "clientId"
        static let title                     = "title"
        static let description               = "description"
        static let assignedBy                = "assignedBy"
        static let user                      = "user"
        static let completed                 = "completed"
        static let viewedByUser              = "viewedByUser"
        static let completedBy               = "completedBy"
        static let type                      = "type"
        static let progress                  = "progress"
        static let dueDate                   = "dueDate"
        static let createdDate               = "createdDate"
        static let modifiedDate              = "modifiedDate"
        static let completedOnDate              = "completedOnDate"
        static let createdBy                 = "createdBy"
        static let modifiedBy                = "modifiedBy"
        static let canEdit                   = "canEdit"
        static let performanceGoalId         = "performanceGoalId"
        static let performanceGoalType       = "performanceGoalType"
        static let alignmentGoalId           = "alignmentGoalId"
        static let alignmentGoalType         = "alignmentGoalType"
        static let goal                      = "goal"
        static let plan                      = "plan"
        static let topic                     = "topic"
        static let series                    = "series"
    }
    
    struct SingleUserInfo {
        static let emailAddress              = "emailAddress"
        static let userEnabled               = "userEnabled"
        static let firstName                 = "firstName"
        static let lastName                  = "lastName"
        static let username                  = "username"
        static let alias                     = "alias"
        static let title                     = "title"
        static let contactPhone              = "contactPhone"
    }
    
    struct MeetingSeriesList {
        static let id                        = "id"
        static let type                      = "type"
        static let title                     = "title"
        static let frequency                 = "frequency"
        static let hidden                    = "hidden"
        static let instanceCount             = "instanceCount"
    }
    
    struct MeetingPaginated {
        static let id                        = "id"
        static let seriesId                  = "seriesId"
        static let state                     = "state"
        static let date                      = "date"
        static let lastCompleted             = "lastCompleted"
        static let isCompleted               = "isCompleted"
    }
    
    struct MeetingInstanceTopics {
        static let hasActionItems            = "hasActionItems"
        static let isVisible                 = "isVisible"
        static let note                      = "note"
        static let previousNote              = "previousNote"
    }
    
    struct PeopleSearchList {
        static let alias                     = "alias"
        static let firstName                 = "firstName"
        static let lastName                  = "lastName"
        static let title                     = "title"
        static let emailAddress              = "emailAddress"
        static let username                  = "username"
        static let userEnabled               = "userEnabled"
        static let performanceGoalPerformance    = "performanceGoalPerformance"
        static let goalPerformance           = "goalPerformance"
        static let onTrack                   = "onTrack"
        static let atRisk                    = "atRisk"
        static let fallingBehind             = "fallingBehind"
        static let none                      = "none"
        static let performanceScore          = "performanceScore"
        static let cultureScore              = "cultureScore"
        static let leadershipScore           = "leadershipScore"
        static let evalDirection             = "evalDirection"
        static let evalMinCutpoint           = "evalMinCutpoint"
        static let evalMaxCutpoint           = "evalMaxCutpoint"
        static let leadershipPercent         = "leadershipPercent"
        static let culturePercent            = "culturePercent"
        static let performancePercent        = "performancePercent"
        static let evalMin                   = "evalMin"
        static let evalMax                   = "evalMax"
    }

}

struct UpdateGoalNote {
    
    struct ProgressImprove {
         static let milestone                     = "<h5>What milestones were completed to allow this progress? What did you do ? How did it go?</h5>"
        static let obtained                       = "<h5>What incremental value was obtained?</h5>"
        static let milestoneDisplay               = "What milestones were completed to allow this progress? What did you do ? How did it go?"
        static let obtainedDisplay                = "What incremental value was obtained?"
    }
    
    struct ProgressRegress {
        static let milestone                      = "<h5>What happened to cause the progress to decrease?</h5>"
        static let obtained                       = "<h5>What remediation steps have been taken to prevent a decrease in the future?</h5>"
        static let milestoneDisplay               = "What happened to cause the progress to decrease?"
        static let obtaineDisplay                 = "What remediation steps have been taken to prevent a decrease in the future?"
    }

    struct StatusImprove {
        static let goalStatus                     = "<h5>What actions have been taken to improve goal status?</h5>"
        static let trajectoryStatus               = "<h5>What steps are you taking to ensure an improved trajectory?</h5>"
        static let goalStatusDisplay              = "What actions have been taken to improve goal status?"
        static let trajectoryStatusDisplay        = "What steps are you taking to ensure an improved trajectory?"
    }
    
    struct StatusRegress {
        static let goalStatus                     = "<h5>What happened to cause the status to regress?</h5>"
        static let trajectoryStatus               = "<h5>What remediation steps have been taken to prevent regression in the future?</h5>"
        static let goalStatusDisplay              = "What happened to cause the status to regress?"
        static let trajectoryStatusDisplay        = "What remediation steps have been taken to prevent regression in the future?"
    }
    
}


struct HomeDictionaryKey {
    
    static let name                  = "Name"
    static let description           = "Description"
    static let image                 = "Image"
    
    static let notes                 = "NOTES"
    static let descriptionNote       = "Recent note entries added to your assigned goals"
    
    static let goals                 = "GOALS"
    static let descriptionGoal       = "A list of goals that are assigned to you to complete"
    
    static let messages              = "MESSAGES"
    static let descriptionMessages   = "A list of Rooms and Direct Messages you belong to."
    
    static let plans                 = "PLANS"
    static let descriptionPlans      = "A list of Plans you belong to"
    
    static let actionItems           = "ACTION ITEMS"
    static let descriptionActionItems      =  "A list of action items that are assigned to you to complete"
    
    static let meetings               = "MEETINGS"
    static let descriptionMeetings    =  "A list of meetings you are assigned to or have attended."

    static let people               = "PEOPLE"
    static let descriptionPeople    =  "A list of people which may include your peers, direct reports, and indirect reports"

}

struct DictionaryKey {
    
    struct GoalNote {
        static let author             = "author"
        static let id                 = "id"
        static let goalId             = "goalId"
        static let goalType           = "goalType"
        static let messageBody        = "messageBody"
        static let status             = "status"
        static let planId             = "planId"
        static let parentMessageId    = "parentMessageId"
        static let noteId             = "noteId"
        static let progress           = "progress"

    }
    
    struct UserAccountDetails {
        static let companyId            = "companyId"
        static let userName             = "userName"
        static let password             = "password"
    }
    
    struct CreateDirectChannel {
        static let name            = "name"
        static let type            = "type"
        static let groupType       = "groupType"
        static let userIds         = "userIds"
        static let isVisible       = "isVisible"
    }
    
    struct OnlinePresenceKey {
        static let udidNo          = "uuidNo"
        static let occupancy       = "occupancy"
        static let uuid            = "uuids"
    }
    
}

struct JsonValues {
    
    struct GoalType {
        static let managerAssigned             = "MANAGER_ASSIGNED"
        static let personal                    = "PERSONAL"
    }
    
    struct Authentication {
        static let unauthorized         = "Unauthorized"
    }
    
    struct Reachability {
        static let offline              = "The Internet connection appears to be offline."
    }
    
    struct Notifications {
        static let type                 = "NOTIFICATIONS"
        static let actionItem                 = "ACTION_ITEM_NOTIFICATIONS"

    }
}


struct JwtKeys {
    static let userID               = "userId"
}

struct ApiResponseCode {
    static let success                         = 200
    static let archiveNoteSuccess              = 201
}

struct DataIdentifierKeys {
    static let dataSource           = "dataSourceName"
    
}

struct CustomColors {
    static let authenticationFieldInactive      =  #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    static let authenticationFieldActive        =  #colorLiteral(red: 0.3921568627, green: 0.5960784314, blue: 0.8078431373, alpha: 1)
    static let authenticationSignDisable        =  #colorLiteral(red: 0, green: 0.3764705882, blue: 0.4862745098, alpha: 0.65)
    static let authenticationSignEnable         =  #colorLiteral(red: 0, green: 0.3764705882, blue: 0.4862745098, alpha: 1)
    static let gunmetalColor                    =  #colorLiteral(red: 0.3333333333, green: 0.3490196078, blue: 0.3607843137, alpha: 1)
    static let backgroundColor                  =  #colorLiteral(red: 0.9843137255, green: 0.9843137255, blue: 0.9843137255, alpha: 1)
    static let baseColor                  =  #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
}

struct CustomFonts {
    struct Roboto {
        static func regular(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Regular", size: size)!
        }
        static func italic(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Italic", size: size)!
        }
        static func medium(_ size: CGFloat) -> UIFont {
            return UIFont(name: "Roboto-Medium", size: size)!
        }
    }
}



public enum AuthenticationCell: Int {
    case companyID
    case username
    case password
    case touchIDCheckBox
    case signIn
    case signInUsingTouchID
    case useDifferentID
    case forgotPassword
}

struct Validation {
    struct AuthenticationMinimumCharacterCount {
        static let companyID     =  1
        static let username      =  1
        static let password      =  8
    }
    struct ForgotPasswordMinimumCharacterCount {
        static let emailID     =  1
    }
}

struct AlertActionButton {
    static let ok           =  "OK"
    static let retry        =  "Retry"
    static let edit         =  "Edit"
    static let discard      =  "Discard"
    static let cancel       =  "Cancel"
    static let delete       =  "Delete"
    static let yes          =  "Yes"
    static let no           =  "No"

    
}


struct UserDefaultKeys {
    static let touchIDIntentEnabled     = "TouchIDIntentEnabled"
    static let userLoggedIn             = "UserLoggedIn"
    static let peopleProfileSelected    = "PeopleProfileSelected"
    static let peopleProfileFullName    = "PeopleProfileFullName"
    static let peopleProfileTitle       = "PeopleProfileTitle"
    static let peopleProfileImage       = "PeopleProfileImage"
    static let selectedPeopleID         = "SelectedPeopleID"
    static let peopleSelectedFromHome   = "PeopleSelectedFromHome"
    
    static let userAlias                = "alias"
    static let userAccountName          = "UserAccountName"
    static let userFirstName            = "UserFirstName"
    static let userLastName             = "UserLastName"
    static let userTitle                = "UserTitle"
    static let userProfileImage         = "UserProfileImage"
    static let isUserInfoFetched        = "UserInfoFetch"
    static let isFetchingUserImage      = "FetchingUserImage"
    static let isUserImageFetched       = "UserImageFetched"
    static let checkEnvironment         = "Environment"
    static let isLaunchedBefore         = "LaunchedBefore"
    static let notificationChannels     = "membershipChannels"
    static let membershipChannels       = "membershipChannelsMessages"
    static let onlinePresenceChannels   = "onlinePresenceChannels"
    static let addReplyNote             = "addReplyNoteDictionary"
    static let inProgressAddReplyNote   = "InProgressAddReplyNote"
    static let badgeCountKey            = "badgeCountKey"
    static let addNoteInAccessoryView   = "addNoteInAccessoryView"
    static let replyNoteInAccessoryView      = "replyNoteInAccessoryView"
    static let goalNoteAvailableInDB         = "goalNoteAvailableInDB"
    static let isPushNotificationReceived    = "IsPushNotificationReceived"
    static let isRoomsAvailable              = "IsRoomsAvailable"
    static let isDirectMessageAvailable      = "IsDirectMessageAvailable"
    static let userProfileImageUpdate         = "UserProfileImageUpdate"
    static let addMessageDictionary          = "addMessageDictionary"
    static let inProgressAddMessage          = "InProgressAddMessage"
    static let addMessageInAccessoryView     = "addMessageInAccessoryView"
    static let budgeCountMessage             = "BudgeCountMessage"
    static let budgeCountActionItem            = "BudgeCountActionItem"
    static let publishedDateNotification     = "PublishedDateNotification"
    static let pubNubNewChannelNotification  = "PubNubNewChannel"
    static let pubNubNewAddChannelNotification  = "PubNubAddChannel"
    static let onlineCheck                      = "OnlineCheck"
    static let pushNotificationMessage          = "PushNotificationMessage"
    static let pushNotificationActionItem        = "PushNotificationActionItem"
    static let pushNotificationMessgaeDictionary  = "PushNotificationMessgaeDictionary"
    static let pushNotificationActionItemDictionary  = "PushNotificationActionItemDictionary"
    static let pushNotificationReceiveFromMessage  = "PushNotificationReceiveFromMessage"
    static let pushNotificationReceiveFromActionItem  = "PushNotificationReceiveFromActionItem"
    static let isInDirectRoom                        = "IsInDirectRoom"
    static let notificationContentBody                        = "NotificationContentBody"
    static let setUserId                              = "SetUserId"
    static let pushNotificationMessgaeDictionaryArray  = "PushNotificationMessgaeDictionaryArray"
    static let pushNotificationActionItemDictionaryArray  = "PushNotificationActionItemDictionaryArray"

    static let refreshTokenExpTime                      = "RefreshTokenExpTime"
    static let planEnable                              = "PlanEnable"
    static let maxKPI                                = "MAXKPIValue"
    static let loginDictionaryArray                  = "LoginDictionaryArray"
    
    
}


struct NoteStatusColor {
    static let noStatus:UIColor         = #colorLiteral(red: 0.3333333333, green: 0.3490196078, blue: 0.3607843137, alpha: 1)//= 0x818A91
    static let fallingBehind:UIColor    = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)//= 0xF44336
    static let atRisk:UIColor           = #colorLiteral(red: 1, green: 0.5960784314, blue: 0, alpha: 1)//= 0xFF9800
    static let onTrack:UIColor          = #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)//= 0x4CAF50
    static let draft:UIColor            = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)//= 0xFFFFFF //need to check with Jason
    static let defaultColor:UIColor     = #colorLiteral(red: 0.9254901961, green: 0.9333333333, blue: 0.937254902, alpha: 1)//= 0xECEEEF
    
    static let draftGoal:UIColor        = #colorLiteral(red: 0.5058823529, green: 0.5411764706, blue: 0.568627451, alpha: 1)
    static let active:UIColor           = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let suspended:UIColor        = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let completed:UIColor        = #colorLiteral(red: 0.3176470588, green: 0.7490196078, blue: 0.8862745098, alpha: 1)
    
}

public enum NoteStatus:Int {
    case noStatus = 0,
    fallingBehind,
    atRisk,
    onTrack,
    defaultStatus,
    draftStatus = -1, //draft status is null response from API
    draft = 11,
    suspended = 13,
    completed = 14
}

public enum GoalsPlanStatus: Int {
    case noStatus = 0,
    fallingBehind,
    atRisk,
    onTrack,
    draft = 11
}


public enum PinnedPlanStateStatus: Int {
    case draft = 1,
    suspended = 3,
    completed = 4
}


public enum PinnedPlanStatus:Int {
    case noStatus = 0,
    fallingBehind,
    atRisk,
    onTrack,
    almostOnTrack,
    almostFallingBehind
}

public enum ChangeStatus:Int {
    case noStatus = 0,
    onTrack,
    atRisk,
    fallingBehind
}

struct NotesStatusText{
    static let NoStatus         = "No Status" //status 0
    static let FallingBehind    = "Falling Behind" //status 1 //Red
    static let AtRisk           = "At Risk" //status 2 //Yellow
    static let OnTrack          = "On Track" //status 3 //Green
    static let DefaultStatus    = ""
    static let Draft            = "Draft"
    
    static let Active           = "Active"
    static let Suspended        = "Suspended"
    static let Completed        = "Completed"
}


struct PinnedPlanStatusText{
    static let NoStatus                      = "PINNED PLANS - NO STATUS" //status 0
    static let FallingBehind                 = "PINNED PLANS - FALLING BEHIND" //status 1
    static let AtRisk                        = "PINNED PLANS - AT RISK" //status 2
    static let OnTrack                       = "PINNED PLANS - ON TRACK" //status 3
    static let AlmostOnTrack                 = "PINNED PLANS - ALMOST ON TRACK" //status 4
    static let AlmostFallingBehind           = "PINNED PLANS - ALMOST FALLING BEHIND" //status 5
    
}


struct NotesMessageFont {
    static let font = "Roboto"
    static let size = 14
    static let color = "#55595c"
}

public enum GoalTypes:Int32 {
    case plan = 1,
    managerAssigned,
    personal,
    role,
    custom
}

public enum GoalTypesName: String {
    case plan             = "PLAN"        //Performance Goals
    case managerAssigned  = "MANAGER_ASSIGNED"
    case personal         = "PERSONAL"
    case role             = "ROLE"       //Role Goals
    case culture          = "CULTURE"    //Mixed Group Goals
    case leadership       = "LEADERSHIP"
    //case default          = "DEFAULT"    //Default
}

struct DateFormat {
    static let dateFormatFromServer         = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    static let monthFormat                  = "MMM"
    static let timeFormat                   = "'at' h:mm a"
    static let am                           = "am"
    static let pm                           = "pm"
    static let dateOnlyFormatFromServer     = "yyyy-MM-dd"
    static let dateOnlyFormat               = "MM/dd/yyyy"
    static let month                        = "MMMM"
    static let dateFormatmessagesFromServer = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let dateFormatPlansKPIFromServer = "yyyy-MM-dd'T'HH:mm:ss.SSS+0000"
    static let timeFormatMessages           = "h:mm a"
    static let monthDateFormat               = "MM/dd"
    static let refreshTokenTimeFormat       = "HH:mm:a"
    static let dateAndTime                  = "MM/dd/yyyy HH:mm a"
    
}

struct pointFormat {
    static let percentage         = "%"
    static let dollar             = "$"
    static let minus             = "-"
    
}

struct NotificationObserverKeys {
    static let pushNotificationRecieved = "PushNotificationRecieved"
    static let refreshNotesRequested    = "RefreshNotesRequested"
    static let onlinePresenceRequested  = "OnlinePresenceRequested"
    static let offlineRequested         = "OfflineRequested"
    static let onlinePresenceCoreDataUpdate  = "OnlinePresenceCoreDataUpdate"
    static let kpiValueChange    = "KPIValueChange"
    
}

struct PubNubObserverKey {
    static let messageListRecieved       = "MessageListRecieved"
    static let addMessageListRecieved    = "AddMessageListRecieved"
}

struct DatabasePath {
    static let coredata    = "com.etw.ios"
}


struct GoalAccessType
{
    static let isStreamGoalOnly = "isStreamGoalOnly" //goal accessed through stream note only but not from user goals list
}

struct GoogleAnalytics {
    
    struct Screens {
        struct Login {
            static let loginScreen              = "LoginScreen"
            static let termsAndConditionScreen  = "TermsAndConditionScreen"
        }
        struct Home {
            static let homeScreen               = "HomeScreen"
        }
        struct ForgotPassword {
            static let forgotPasswordScreen     = "ForgotPasswordScreen"
        }
        struct Setting {
            static let menuScreen               = "MenuScreen"
            static let settingsScreen           = "SettingsScreen"
            static let chooseDifferentIDScreen  = "ChooseDifferentIDScreen"
            static let helpScreen               = "HelpScreen"
        }
        struct Note {
            static let notes                    = "NotesScreen"
            static let archive                  = "NotesArchiveScreen"
        }
        struct Goal {
            static let goalsListScreen          = "GoalsListScreen"
            static let goalNotesScreen          = "GoalNotesScreen"
            static let editGoalStatusScreen     = "EditGoalStatusScreen"
            static let replyGoalScreen          = "ReplyGoalScreen"
            
        }
        
        struct Message {
            static let messagesScreen            = "MessagesScreen"
            static let messageListScreen         = "MessagesListScreen"
        }
        
        struct Plan {
            static let plansTabScreen               = "PlansScreen"
            static let planDetailsScreen            = "PlanDetailsScreen"
        }
        struct ActionItem {
            static let actionItemListScreen         = "ActionItemListScreen"
            static let actionItemCompletedListScreen = "ActionItemCompletedListScreen"
            static let actionItemDetailScreen       = "ActionItemDetailScreen"
            static let actionItemListGoalScreen     = "ActionItemListGoalScreen"
            static let actionItemCompletedListGoalScreen     = "ActionItemListCompletedGoalScreen"
            
        }
        
        struct MeetingSeries {
            static let meetingListScreen            = "MeetingListScreen"
            static let meetingSeriesDetailScreen    = "MeetingSeriesDetailScreen"
            static let meetingInstanceScreen        = "MeetingInstanceScreen"
            static let actionItemDetailsScreen     = "ActionItemDetailsScreen"
        }
        
        
        struct Server {
            static let serverError              = "Server"
            static let noInternetconnection     = "NoInternetconnection"
            
        }
        
    }
    
    struct Events {
        struct Login {
            static let login                     = "Login"
            static let loginTermsAccepted        = "LoginTermsAccepted"
        }
        struct Home {
            static let homeTabSelected           = "HomeTabSelected"
            static let messageEnable             = "communicationEnableForThisUser"
            static let messageNotEnable          = "communicationNotEnableForThisUser"
            
        }
        struct ForgotPassword {
            static let forgotPasswordSelected    = "ForgotPasswordSelected"
            static let resetsPassword            = "ResetsPassword"
        }
        struct Setting {
            static let settingsMenuSelected      = "SettingsMenuSelected"
            static let enableTouchSelected       = "EnableTouchSelected"
            static let disableTouchSelected      = "DisableTouchSelected"
            static let helpSelected              = "HelpSelected"
            static let signOutSelected           = "SignOutSelected"
            static let differentIDScreenSelected = "DifferentIDScreenSelected"
            static let differentIDSelected       = "DifferentIDSelected"
            
        }
        struct Note {
            static let notesTabSelected          = "NotesTabSelected"
            static let noteMessageSelected       = "NoteMessageSelected"
            static let archiveNoteSelected       = "ArchiveNoteSelected"
            static let archiveAllSelected        = "ArchiveAllSelected"
            static let unArchiveSelected         = "UnArchiveSelected"
            static let archiveTabSelected        = "ArchiveTabSelected"
            
        }
        struct Goal {
            static let goalsTabSelected          = "GoalsTabSelected"
            static let goalSelected              = "GoalSelected"
            static let addNoteSelected           = "AddNoteSelected"
            static let replyNoteSelected         = "ReplyNoteSelected"
            static let editStatusSelected        = "EditStatusSelected"
            static let goalStatusChanges         = "GoalStatusChanges"
        }
        
        struct Message {
            static let messageTabSelected        = "MessagesTabSelected"
            static let roomSelected              = "RoomSelected"
            static let directMessageSelected     = "DirectMessageSelected"
            static let newDirectMessageSelected  = "NewDirectMessageSelected"
            static let leaveDirectMessageSelected = "LeaveDirectMessageSelected"
            static let addMessageSelected        = "AddMessageSelected"
            static let peopleInRoomSelected      = "PeopleInRoomSelected"
        }
        
        struct Plan {
            static let planTabSelected           = "PlansTabSelected"
            static let planListSelected          = "PlanSelected"
            static let planGoalSelected          = "PlanGoalSelected"
            static let supportingPlanSelected    = "SupportingPlanSelected"
            
        }
        
        struct ActionItem {
            static let actionItemTabSelected           = "ActionItemTabSelected"
            static let actionItemDetailView            = "ActionItemDetailView"
            static let newActionItemCreated            = "NewActionItemCreated"
            static let actionItemMarkedComplete        = "ActionItemMarkedComplete"
            static let actionItemMarkedInComplete      = "ActionItemMarkedInComplete"
            static let actionItemDeleted               = "ActionItemDeleted"
            static let listGoalActionItems             = "ListGoalActionItems"
            static let listCompletedActionItems        = "ListCompletedActionItems"
            static let listCompletedGoalActionItems    = "ListCompletedGoalActionItems"
        }
        
        struct MeetingSeries {
            static let meetingSeriesListSelected           = "MeetingSeriesListSelected"
            static let meetingInstanceListSelected         = "MeetingInstanceListSelected"
            static let meetingInstanceDetailsSelected      = "MeetingInstanceDetailsSelected"
            static let meetingActionItemSelcted            = "MeetingActionItemSelcted"
        }
        
        struct Error {
            static let trackError                = "ErrorFound"
        }
        
        
    }
    
    struct EventParameters {
        static let noteId       = "noteId"
        static let goalId       = "goalId"
        static let goalType     = "goalType"
        static let goalStatus   = "goalStatus"
        static let author       = "author"
        static let arhiveDate   = "archiveDate"
        static let beforeStatus = "beforeStatus"
        static let afterStatus  = "afterStatus"
        static let errorCode    = "errorCode"
    }
    
    struct UserProperties {
        static let clientId    = "clientId"
        static let userId      = "userId"
    }
}

var eventParameters: [(String)] = [
    (GoogleAnalytics.EventParameters.noteId),
    (GoogleAnalytics.EventParameters.goalId),
    (GoogleAnalytics.EventParameters.goalType),
    (GoogleAnalytics.EventParameters.goalStatus),
]

struct Server {
    static let error       = "Could not interpret data from the server."
}

struct PeopleInRoom {
    static let room             = "ROOMS"
    static let peopleInRoom     = "People In Room"
    static let people           = "People"
    static let assignee           = "Assignee"
}


