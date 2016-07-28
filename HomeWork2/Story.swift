//
//  Story.swift
//  HomeWork2
//
//  Created by student on 7/23/16.
//  Copyright © 2016 Pawan Araballi. All rights reserved.
//

import Foundation

class Story : NSObject{
    var title:String = ""
    var pubDate:String = ""
    var smallI:String = ""
    var largeI:String = ""
    var teaser:String = ""
    var audioFile:String = ""
    var ids:String = ""
    
    init(id:String,title:String,pubDate:String,smallI:String,largeI:String,teaser:String,audioFile:String) {
        self.largeI = largeI
        self.smallI = smallI
        self.title = title
        self.pubDate = pubDate
        self.teaser = teaser
        self.audioFile = audioFile
        self.ids = id
    }
    
}
