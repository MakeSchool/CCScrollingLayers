//
//  SWTableViewDelegateWrapper.m
//  Scrolling
//
//  Created by BrianC on 9/2/12.
//
//

#import "SWTableDataSourceWrapper.h"
#import "SWTableViewCell.h"

//Private class:
@interface WrapperCell : SWTableViewCell
@property CGSize cellSize;
@end

@implementation WrapperCell
@synthesize cellSize;
@end

//Public class:
@implementation SWTableDataSourceWrapper
@synthesize cellSize;
@synthesize arrayOfNodes;

-(id) initWithCellSize: (CGSize) size
       andArrayOfCells: (NSArray*) array
{
    self= [super init];
    
    self.cellSize=size;
    arrayOfNodes=array;
    
    return self;
}

-(id) init
{
    @throw [NSException exceptionWithName:@"SWTableViewDelegate Invalid Instantiation"
                                   reason:@"You must call initWithCellSize:andArrayOfCells:"
                                 userInfo:nil];
}

//method for SWTableViewDataSource
-(CGSize)cellSizeForTable:(SWTableView *)table {
    return cellSize;
}

//method for SWTableViewDataSource
-(SWTableViewCell *)table:(SWTableView *)table cellAtIndex:(NSUInteger)index {
    
    SWTableViewCell *cell = [table dequeueCell];
    if (!cell) {
        cell = [WrapperCell new];
        CCNode* node = [arrayOfNodes objectAtIndex:index];
        if (node.parent==nil)
        {
            [cell addChild:node];
        }
        else
        {
            [node removeFromParentAndCleanup:YES];
            [cell addChild:node];
        }
	}
    
    return cell;
    
    
}

//-(void) setCellSize:(CGSize)cellSze
//{
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
//        && [[UIScreen mainScreen] scale] == 2.0)
//    {
//        //Retina
//        cellSize=CGSizeMake(cellSze.width*2, cellSze.height*2);
//    } else {
//        // Not Retina
//        cellSize=cellSze;
//    }
//}

//method for SWTableViewDataSource
-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    return [arrayOfNodes count];
}

@end
