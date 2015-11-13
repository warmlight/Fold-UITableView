//
//  FoldTableViewController2.m
//  ExpandedTable
//
//  Created by yiban on 15/10/23.
//
//

#import "FoldTableViewController2.h"

@interface FoldTableViewController2 ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *sourceDic;       //要显示的数据
@property (strong, nonatomic) NSArray * sectionTitleArray;          //分区标题
@property (assign, nonatomic) NSInteger currentExpandSection;       //当前展开的section

@end

@implementation FoldTableViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.sectionTitleArray = [[NSMutableArray alloc] init];
    
    
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    NSMutableIndexSet * iset = [NSMutableIndexSet indexSet];
    //    [iset addIndex:section];
    //
    //    if ([self.currentFoldSections containsObject:iset]) {
    //        return 0;
    //    } else {
    //        NSString *key = [self.sectionTitleArray objectAtIndex:section];
    //        NSArray *array = [self.sourceDic objectForKey:key];
    //        return array.count;
    //    }
    if (section == self.currentExpandSection) {
        NSString *key = [self.sectionTitleArray objectAtIndex:section];
        NSArray *array = [self.sourceDic objectForKey:key];
        return array.count;
    }else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sourceDic.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    NSString *key = [self.sectionTitleArray objectAtIndex:indexPath.section];
    NSArray *array = [self.sourceDic objectForKey:key];
    NSString * str = array[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Item %@", str];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton * btnSection = [UIButton buttonWithType:UIButtonTypeCustom];
    //刷新分区会刷新按钮，无法保持选中信息，检索后手动赋值
    NSMutableIndexSet * iset = [NSMutableIndexSet indexSet];
    [iset addIndex:section];
    if (self.currentExpandSection == section) {
        btnSection.selected = YES;
    }
    
    [btnSection setBackgroundColor:[UIColor lightGrayColor]];
    //    [btnSection setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    //    [btnSection setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
    //
    //    btnSection.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //
    //    // title、图片位置
    //    UIImage *image = [UIImage imageNamed:@"down"];
    //    btnSection.titleEdgeInsets = UIEdgeInsetsMake(0, - image.size.width + 10, 0, 0);
    //    btnSection.imageEdgeInsets = UIEdgeInsetsMake(0, self.view.frame.size.width - 40, 0, 10);
    [btnSection setTitle:self.sourceDic.allKeys[section] forState:UIControlStateNormal];
    
    [btnSection addTarget:self action:@selector(btnSectionClicked:) forControlEvents:UIControlEventTouchDown];
    [btnSection setTag:section];
    
    return btnSection;
}

// 去掉UItableview headerview黏性效果(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

- (void)btnSectionClicked:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    NSMutableIndexSet * iset = [NSMutableIndexSet indexSet];
    [iset addIndex:button.tag];

    NSInteger oldsection = self.currentExpandSection;
    if (oldsection != -1) {
        if (oldsection == button.tag){
            self.currentExpandSection  = -1;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:oldsection] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else {
            self.currentExpandSection  = -1;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:oldsection] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            self.currentExpandSection = button.tag;
            [self.tableView reloadSections:iset  withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    }else {
        _currentExpandSection = button.tag;
        [self.tableView reloadSections:iset  withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    NSLog(@"%@", iset);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

