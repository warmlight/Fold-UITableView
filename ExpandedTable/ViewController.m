//
//  ViewController.m
//  ExpandedTable
//
//  Created by yiban on 15/11/13.
//
//

#import "ViewController.h"
#import "FoldTableViewController1.h"
#import "FoldTableViewController2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *canExpandSeveralSection = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    canExpandSeveralSection.titleLabel.font = [UIFont systemFontOfSize:14];
    [canExpandSeveralSection setTitle:@"可展开多个分区" forState:UIControlStateNormal];
    [canExpandSeveralSection addTarget:self action:@selector(canExpandSeveralSectionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:canExpandSeveralSection];
    
    UIButton *expandOneSection = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 30)];
    expandOneSection.titleLabel.font = [UIFont systemFontOfSize:14];
    [expandOneSection setTitle:@"只展开一个分区" forState:UIControlStateNormal];
    [expandOneSection addTarget:self action:@selector(expandOneSectionClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:expandOneSection];
    // Do any additional setup after loading the view.
}

- (void)canExpandSeveralSectionClick {
    FoldTableViewController1 *expandSeveralSectionCon = [[FoldTableViewController1 alloc] init];
    [self.navigationController pushViewController:expandSeveralSectionCon  animated:YES];
}

- (void)expandOneSectionClick {
    FoldTableViewController2 *expandOneSectionCon = [[FoldTableViewController2 alloc] init];
    [self.navigationController pushViewController:expandOneSectionCon  animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
