//
//  SearchViewController.h
//  zhike
//
//  Created by 周博 on 2017/12/12.
//  Copyright © 2017年 zhoubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UISearchResultsUpdating> 
@property (strong, nonatomic) UINavigationController *nav;
@property (strong, nonatomic) UISearchBar *searchBar;
@end
