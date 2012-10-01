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
A DataSource class is already written (SWTableDataSourceWrapper). The class the creates the table needs to implement the Delegate protocol.
For greater flexibility, you may choose to write your own class that implements the Data Source.
It is advisable to instantiate ScrollTableLayer, instead of subclassing it.

A SWMultiColumnTableView class is also included which can be used to create multi-column tables.
The setup is identical to setting up a normal table. You will need to call the setColCount:<# of columns> method.
Make sure your cell size is small enough so that all the cells will fit in the screen.