CCScrollingLayers
==================================

TODO: Update to cocos2d and Kobold2D versions 2.X

cocos2D-iphone versions of a scrolling layer and a scrolling list, analogous to a UIScrollView and a UITableView (though many features of UIScrollViews and UITableViews are not implemented)

Examples created by Brian Chu for MakeGamesWithUs.
Modifications by Brian Chu (see individual file comments)
Parts of original source created by Sangwoo Im and Jerrod Putnam.

For both projects, read the example files!

FreeScrollingLayer Example shows you how to make a layer that pans (moves) in 2D and which has pinch zooming and double-tap zooming.
There is an optional FreeScrollingLayerDelegate protocol that can be implemented (see comments in the example).
You need to copy over the FreeScrolling folder into your project.

It is advisable to subclass the FreeScrollingLayer class, 
instead of instantiating it alone (for example, having a "Battlefield" class inherit it).
The FreeScrollingLayer class makes use of ccTouchBegan and the pinch, pan, and double tap gestures.

******

ScrollTableLayerExample shows you how to make a layer that adds a vertically or horizontally scrolling list.
You need to copy over the SWTable folder into your project.

The ScrollTableLayer defines 2 protocols: the SWTableViewDelegate protocol and the SWTableViewDataSource protocol.
SWTableViewDelegate handles the response to when a cell is touched.
SWTableViewDataSource stores what is displayed in the table (any instance of CCNode).
A DataSource class is already written (SWTableDataSourceWrapper) that uses an array of CCNodes. The class the creates the table needs to implement the Delegate protocol.
For greater flexibility and performance, you may choose to write your own class that implements the Data Source and creates it's own data directly.
It is advisable to instantiate ScrollTableLayer, instead of subclassing it.

A SWMultiColumnTableView class is also included which can be used to create multi-column tables.
The setup is identical to setting up a normal table. You will need to call the setColCount:<# of columns> method.
Make sure your cell size is small enough so that all the cells will fit in the screen.

******
Details on the internals of SWTableView:
A container is added to the table. The table's size is the view size. The container size is the content size (all cells, including off-screen ones).

The "offset" is essentially the position of the container. It is the distance from the bottom of the container to the bottom of the viewing layer (not the bottom of the screen, necessarily). The negative direction for the offset is scrolling the container up (for TopBottom fill).

Scrolling/moving the container around is handled by "contentOffset" methods (there are several). 

SWTableView implements SWScrollViewDelegate - this allows the scroll view code to call the scrollViewDidScroll method in SWTableView. SWTableView also holds references to the SWTableViewDataSource and SWTableViewDelegate.

CellsUsed = cells visible. First object is at the top of the containers, last object is at the bottom. The most # of cells in this array is the max # of cells that fit in the view screen.
CellsFreed = cells not visible ONLY during a bounce. The max # of cells here is the max number of cells hidden by the overscrolling/bounce effect.

INSET_RATIO determined bounce amount