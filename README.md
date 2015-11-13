# Fold-UITableView
#UITableView的折叠效果
*************
　　项目需求要做出一级列表的效果，也就是将`UITableView`模拟出折叠`section`的效果。网上类似的代码demo还是很多哒~我这里是自己进行一个总结巩固，顺便理清一下思路。<br/>
　　我写出了两个效果，一个是没有互斥效果的，即当前可展开多个`section`,一个是有互斥效果的，即当前只会展开一个`section`，当展开第二个分区的时候第一个分区会有一个自动收起的动作。<br/><br/>
　　**效果图**：<br/>
<br/>1.可展开多个分区的GIF<br/>
![可展开多个section](http://ac-3xs828an.clouddn.com/4be3e6d99c1e8866.gif)

<br/>2.只可以展开一个分区GIF<br/>
![只展开一个section](http://ac-3xs828an.clouddn.com/2e0b07253c91ae45.gif)
<br/>


###1.可展开多个分区的实现
我们需要一个数组来存储当前展开的分区。

	@property (strong, nonatomic) NSMutableArray *currentExpandSection;  //展开的section

通过在返回分区内cell的数量时，判断该cell是否在`currentExpandSection`数组里，来决定当前cell是否折叠（即返回0行）。

	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
	{
    NSMutableIndexSet * iset = [NSMutableIndexSet indexSet];
    [iset addIndex:section];
    //判断当前section是否是收起状态的
    if ([self.currentExpandSection containsObject:iset]) {
        return 0;
    } else {
        NSString *key = [self.sectionTitleArray objectAtIndex:section];
        NSArray *array = [self.sourceDic objectForKey:key];
        return array.count;
    }
    }
在`-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section`函数里返回了一个`UIButton`,button的tag就是section的值,点击改变button选中状态,给它一个点击事件,判断选中的状态来决定是收起还是展开,控制`currentExpandSection`里元素的增减，并刷新分区。
	
	-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton * btnSection = [UIButton buttonWithType:UIButtonTypeCustom];
    //刷新分区会刷新按钮，无法保持选中信息，检索后手动赋值为选中
    NSMutableIndexSet * iset = [NSMutableIndexSet indexSet];
    [iset addIndex:section];
    //若当前分区在currentExpandSection中表明它当前被选中且被展开
    if ([self.currentExpandSection containsObject:iset]) {
        btnSection.selected = YES;
    }
    [btnSection setBackgroundColor:[UIColor lightGrayColor]];
    [btnSection setTitle:self.sourceDic.allKeys[section] forState:UIControlStateNormal];
    [btnSection addTarget:self action:@selector(btnSectionClicked:) forControlEvents:UIControlEventTouchDown];
    [btnSection setTag:section];
    
    return btnSection;
	}
	
	- (void)btnSectionClicked:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    //点击后改变选中的状态，改变后若为选中表示展开，将其对应的分区加入currentExpandSection。
    button.selected = !button.selected;
    
    //通过button的tag来获得第几个分区
    NSMutableIndexSet * iset = [NSMutableIndexSet indexSet];
    [iset addIndex:button.tag];
    
    //button点击后被选中就展开
    if (button.isSelected) {
        [self.currentExpandSection addObject:iset];
    }else {
        if ([self.currentExpandSection containsObject:iset]) {
            [self.currentExpandSection removeObject:iset];
        }
    }
    //刷新点击的分区,可选择动画
    [self.tableView reloadSections:iset withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	
###2.只展开一个分区的实现
因为每次点击只会展开一个分区，所以需要知道当前是哪个`section`被展开。
   
    @property (assign, nonatomic) NSInteger currentExpandSection;       //当前展开的section
    
因为一开始所有分区都为收起状态，所以不指向任何一个分区，默认值给-1.

    //模拟数据
    self.sourceDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < 10; i ++) {
        NSString * key = [[NSString alloc] initWithFormat:@"key %d",i];
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (int j = 0; j < i + 1; j ++) {
            NSString *item = [[NSString alloc] initWithFormat:@"%d",j];
            [list addObject:item];
        }
        [self.sourceDic setObject:list forKey:key];
    }
    self.currentExpandSection = -1;
    self.sectionTitleArray = [self.sourceDic allKeys];
    
在返回分区里的cell数量时，只有当前展开的section返回相应的行数，其余的section都返回0，保证视觉上每次只会展开一个分区。

    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //当前展开的分区返回正确的行数，其余返回0
    if (section == self.currentExpandSection) {
        NSString *key = [self.sectionTitleArray objectAtIndex:section];
        NSArray *array = [self.sourceDic objectForKey:key];
        return array.count;
    }else {
        return 0;
    }
	}
	
与展开多个分区一样，在`-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section`函数里返回了一个`UIButton`,需要判断分区是否是当前的展开分区,
    
    -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton * btnSection = [UIButton buttonWithType:UIButtonTypeCustom];
    //刷新分区会刷新按钮，无法保持选中信息，检索后手动赋值
    NSMutableIndexSet * iset = [NSMutableIndexSet indexSet];
    [iset addIndex:section];
    //分区如果是当前的展开分区，选中状态为yes
    if (self.currentExpandSection == section) {
        btnSection.selected = YES;
    }
    
    [btnSection setBackgroundColor:[UIColor lightGrayColor]];
    [btnSection setTitle:self.sourceDic.allKeys[section] forState:UIControlStateNormal];    
    [btnSection addTarget:self action:@selector(btnSectionClicked:) forControlEvents:UIControlEventTouchDown];
    [btnSection setTag:section];
    
    return btnSection;
	}
	
button的点击事件比上面那种情况稍微复杂一丢丢，同样，button的tag就是第几个分区，在`currentExpandSection`未被赋值为新的点击分区时用一个变量`oldsection`保存点击之前是第几个分区被展开.

	- (void)btnSectionClicked:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSMutableIndexSet * iset = [NSMutableIndexSet indexSet];
    [iset addIndex:button.tag];

    NSInteger oldsection = self.currentExpandSection;
    if (oldsection != -1) { //不等于-1表示当前有分区被展开
        if (oldsection == button.tag){
        	//点击前展开的分区与当前点击的分区是同一个分区，要折叠此分区
        	//并且currentExpandSection重新赋值-1，表示当前没有分区被展开
            self.currentExpandSection  = -1;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:oldsection] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else {
        	//当前展开分区与被点击展开的分区不同时
        	//先把当前展开的分区收起，恢复到没有展开的状态，刷新分区
            self.currentExpandSection  = -1;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:oldsection] withRowAnimation:UITableViewRowAnimationAutomatic];
            //把点击的分区赋值给currentExpandSection。并刷新分区
            self.currentExpandSection = button.tag;
            [self.tableView reloadSections:iset  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else {
    	//当前没有分区被展开，直接展开被点击的分区
        self.currentExpandSection = button.tag;
        [self.tableView reloadSections:iset  withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    NSLog(@"%@", iset);
}
