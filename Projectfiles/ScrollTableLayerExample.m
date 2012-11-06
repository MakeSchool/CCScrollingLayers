//
//  ScrollTableLayer.m
//  Scrolling
//
//  Copyright 2012 MakeGamesWithUs Inc.
//  Created by Brian Chu
//



#import "ScrollTableLayerExample.h"
#import "SWTableViewCell.h"
#import "SWTableDataSourceWrapper.h"


@implementation ScrollTableLayerExample

SWTableDataSourceWrapper* dataSource; //must be an instance variable

-(id) init
{
	if( (self=[super init] )) {
        
        CGSize screenSize = [CCDirector sharedDirector].screenSize;        
        
        //set up some test sprites
        NSMutableArray* arrayOfSprites = [[NSMutableArray alloc] init];
        for(int i=0; i<10; i++)
        {
            CCSprite *testSprite = [CCSprite spriteWithFile:@"mole.png"];
            NSLog(@"%f",testSprite.contentSize.height);
            testSprite.anchorPoint = CGPointZero;
            [arrayOfSprites addObject:testSprite];
        }
        
        //Size of one cell in the table
        CGSize cellSize = CGSizeMake(screenSize.width, 200);
        
        //initialize the object that will feed data to our TableView
        dataSource = [[SWTableDataSourceWrapper alloc] initWithCellSize:cellSize andArrayOfCells:arrayOfSprites];
        
        //size of the "viewing window"
        //for example, a menu that pops up in-game will be smaller than full-screen
        //the screenSize width should be the same as the cellSize width
        tableView = [SWTableView viewWithDataSource:dataSource size:screenSize];
        
        //set the delegate to this class
        //For this to work, this class must implement the table:cellTouched: method (see after this method)
        tableView.delegate=self;
        
        //direction of the table.
        tableView.direction = SWScrollViewDirectionVertical;
        
        tableView.position = ccp(0,0);
        
        //SWTableViewFillTopDown fills the table with cell #1 at the top
        //BottomUp fills the table with cell #n (the last index) at the top
        tableView.verticalFillOrder = SWTableViewFillTopDown; //default is TopDown
        
        [self addChild:tableView];
        [tableView reloadData];

        
    }
	return self;
    
}

//method for SWTableViewDelegate
//called when a cell is touched
-(void)table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell {
 //get the index # of the cell that was touched using cell.idx
    LOG_EXPR(cell.idx);
}

@end
