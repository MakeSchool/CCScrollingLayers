//
//  SWTableViewDelegateWrapper.h
//  Scrolling
//
//  Created by BrianC on 9/2/12.
//
//

#import "CCNode.h"
#import "SWTableView.h"

//protocol declaration
@interface SWTableDataSourceWrapper: CCNode <SWTableViewDataSource>
{}
@property (nonatomic) CGSize cellSize;
@property (nonatomic) NSArray* arrayOfNodes;

-(id) initWithCellSize: (CGSize) size
       andArrayOfCells: (NSArray*) array;
-(CGSize)cellSizeForTable:(SWTableView *)table;
-(SWTableViewCell *)table:(SWTableView *)table cellAtIndex:(NSUInteger)index;
-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table;


@end
