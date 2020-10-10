//
//  PermissionTableViewCell.h
//  Demo
//
//  Created by 夏利兵 on 2020/10/10.
//  Copyright © 2020 lbx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PermissionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *topLable;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *enableLabel;

@end

NS_ASSUME_NONNULL_END
