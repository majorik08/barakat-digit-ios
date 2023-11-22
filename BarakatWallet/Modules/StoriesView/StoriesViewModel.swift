//
//  StoriesViewModel.swift
//  BarakatWallet
//
//  Created by km1tj on 16/11/23.
//

import Foundation

public class StoriesItem: Equatable {
    
    public static func == (lhs: StoriesItem, rhs: StoriesItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    let action: String
    let button: String
    let type: Int
    let id: Int
    var snaps: [SnapItem]
    
    var lastPlayedSnapIndex = 0
    var isCompletelyVisible = false
    var isCancelledAbruptly = false
    
    init(action: String, button: String, type: Int, id: Int, snaps: [SnapItem]) {
        self.action = action
        self.button = button
        self.type = type
        self.id = id
        self.snaps = snaps
    }
    
    init(stories: AppStructs.Stories) {
        self.action = stories.action
        self.button = stories.button
        self.type = stories.type
        self.id = stories.id
        self.snaps = stories.images.map({ SnapItem(id: $0.id, source: $0.source, storyID: $0.storyID) })
    }
    
    public class SnapItem {
        let id: Int
        let source: String
        let storyID: Int
        
        init(id: Int, source: String, storyID: Int) {
            self.id = id
            self.source = source
            self.storyID = storyID
        }
    }
}

class StoriesViewModel {
    
    let service: BannerService
    
    var stories: [StoriesItem] = []
    
    /** This index will tell you which Story, user has picked*/
    var handPickedStoryIndex: Int //starts with(i)
    /** This index will tell you which Snap, user has picked*/
    var handPickedSnapIndex: Int //starts with(i)
    /** This index will help you simply iterate the story one by one*/
    
    init(service: BannerService, stories: [AppStructs.Stories], handPickedStoryIndex: Int, handPickedSnapIndex: Int = 0) {
        self.service = service
        self.stories = stories.map({ StoriesItem(stories: $0) })
        self.handPickedStoryIndex = handPickedStoryIndex
        self.handPickedSnapIndex = handPickedSnapIndex
    }
}
