//
//  ViewController.m
//  ExpandedTable
//
//  Created by yiban on 15/10/16.
//
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableDictionary *sourceDic;       //要显示的数据
@property (strong, nonatomic) NSMutableArray *currentExpandSection; //展开的section
@property (strong, nonatomic) NSArray * sectionTitleArray;          //分区标题

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.sectionTitleArray = [[NSMutableArray alloc] init];
    self.currentExpandSection = [[NSMutableArray alloc] init];
    
    
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
    
      self.sectionTitleArray = [self.sourceDic allKeys];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableIndexSet * iset = [NSMutableIndexSet indexSet];
    [iset addIndex:section];
    
    if ([self.currentExpandSection containsObject:iset]) {
        NSString *key = [self.sectionTitleArray objectAtIndex:section];
        NSArray *array = [self.sourceDic objectForKey:key];
        return array.count;
    } else {
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
    if ([self.currentExpandSection containsObject:iset]) {
        btnSection.selected = YES;
    }
    
    [btnSection setBackgroundColor:[UIColor lightGrayColor]];
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
    
    //button被选中就展开
    if (button.isSelected) {
        [self.currentExpandSection addObject:iset];
    }else {
        if ([self.currentExpandSection containsObject:iset]) {
            [self.currentExpandSection removeObject:iset];
        }
    }
    [self.tableView reloadSections:iset withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
