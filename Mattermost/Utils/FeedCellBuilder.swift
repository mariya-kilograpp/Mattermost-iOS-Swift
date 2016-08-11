//
//  PostStrategy.swift
//  Mattermost
//
//  Created by Maxim Gubin on 10/08/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

import UIKit


private protocol Inteface: class {
    func heightForPost(post: Post, previous: Post?) -> CGFloat
    func cellForPost(post: Post, previous: Post?) -> UITableViewCell
}

private enum CellType {
    case Attachment
    case FollowUp
    case Common
}

final class FeedCellBuilder {
    
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    private init?(){
        return nil
    }
    
    private func typeForPost(post: Post, previous: Post?) -> CellType {
        if post.hasAttachments() {
            return .Attachment
        }
        if let _ = previous where post.hasSameAuthor(previous) {
            return .FollowUp
        }
        return .Common
    }
}


extension FeedCellBuilder: Inteface {
    func cellForPost(post: Post, previous: Post?) -> UITableViewCell {
        
        var reuseIdentifier: String
        
        switch self.typeForPost(post, previous: previous) {
            case .Attachment:
                reuseIdentifier = FeedAttachmentsTableViewCell.reuseIdentifier
                break
            case .FollowUp:
                reuseIdentifier =  FeedFollowUpTableViewCell.reuseIdentifier
                break
            case .Common:
                reuseIdentifier = FeedCommonTableViewCell.reuseIdentifier
                break
        }
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! FeedBaseTableViewCell
        cell.transform = self.tableView.transform
        cell.configureWithPost(post)
        return cell
    }
    
    func heightForPost(post: Post, previous: Post?) -> CGFloat {
        switch self.typeForPost(post, previous: previous) {
        case .Attachment:
            return FeedAttachmentsTableViewCell.heightWithPost(post)
        case .FollowUp:
            return FeedFollowUpTableViewCell.heightWithPost(post)
        case .Common:
            return FeedCommonTableViewCell.heightWithPost(post)
        }
    }
    
}

