//
//  PaintItem.swift
//  Watercolors
//
//  Created by Paul ReFalo on 7/4/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct PaintItem {
    
    let paintNumber: String
    let havePaint: Int
    let needPaint: Int
    
    let ref: FIRDatabaseReference?
    
    init(paintNumber: String, havePaint: Int, needPaint: Int, key: String = "") {
        self.paintNumber = paintNumber
        self.havePaint = havePaint
        self.needPaint = needPaint
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        havePaint = snapshotValue["havePaint"] as! Int
        needPaint = snapshotValue["needPaint"] as! Int

        paintNumber = snapshotValue["paintNumber"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "paintNumber": paintNumber,
            "havePaint": havePaint,
            "needPaint": needPaint
        ]
    }
    
}
