//
//  OmCell.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 27..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface OmCell : UITableViewCell
{
    TTTAttributedLabel *_label;
}

- (void)setString:(NSString *)str searchString:(NSString*)search;
@end
