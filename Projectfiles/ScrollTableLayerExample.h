//
//  ScrollTableLayer.h
//  Scrolling
//
//  Copyright 2012 MakeGamesWithUs Inc.
//  Created by Brian Chu
//


#import "cocos2d.h"
#import "SWTableView.h"
#import "SWMultiColumnTableView.h"

//The <> syntax declares that ScrollTableLayerExample "implements" the SWTableViewDelegate protocol.
//Protocols are Objective-C's equivalent of Java interfaces
@interface ScrollTableLayerExample : CCLayer <SWTableViewDelegate>
{
    SWTableView * tableView;
}

@end
