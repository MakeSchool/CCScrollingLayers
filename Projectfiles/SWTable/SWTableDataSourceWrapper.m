//
//  SWTableViewDelegateWrapper.m
//  Scrolling
//
//  Created by BrianC on 9/2/12.
//
//

#import "SWTableDataSourceWrapper.h"
#import "SWTableViewCell.h"

//Private class
@interface SWTableViewNodeCell : SWTableViewCell {
    CCNode *node;
}
@property (nonatomic, retain) CCNode *node;
@end

@implementation SWTableViewNodeCell
@synthesize node;

-(void)setNode:(CCNode *)s {
    if (node) {
        [self removeChild:node cleanup:YES];
    }
    s.anchorPoint = s.position = CGPointZero;
    node = s;
    [self addChild:node];
}
-(CCNode *)node {
    return node;
}
-(void)reset {
    [super reset];
    if (node) {
        [self removeChild:node cleanup:YES];
    }
    node = nil;
}
@end

//Private class:
@interface WrapperCell : SWTableViewNodeCell
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
    LOG_EXPR(index);
    SWTableViewNodeCell *cell = [table dequeueCell];
    if (!cell) {//|| cell.idx != index) { //index is a bit of a hack - fix later
        LOG_EXPR(@"generate");
        cell = [[WrapperCell alloc]init];
        
        CCLabelTTF* test = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i",index] fontName:@"Arial" fontSize:12];
        test.color=ccBLACK;
        test.anchorPoint=ccp(0,0);
        test.position = ccp(5,0);
        [cell addChild:test z:10];
        cell.idx = index;
        //cell.idx = index;
    }
    
        CCNode* node = [arrayOfNodes objectAtIndex:index];
        cell.node = node;
//        if (node.parent==nil)
//        {
//            [cell addChild:node];
//        }
//        else
//        {
//            [node removeFromParentAndCleanup:YES];
//            [cell addChild:node];
//        }
	
    
    return cell;
    
    
}

//method for SWTableViewDataSource
-(NSUInteger)numberOfCellsInTableView:(SWTableView *)table {
    return [arrayOfNodes count];
}

@end
