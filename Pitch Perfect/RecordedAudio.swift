//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Richard Reed on 12/22/15.
//  Copyright © 2015 Richard Reed. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
