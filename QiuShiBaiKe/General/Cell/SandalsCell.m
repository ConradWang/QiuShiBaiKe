//
//  SandalsCell.m
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-10.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#import "SandalsCell.h"

@implementation SandalsCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configScandalsCellWithQiuShi:(QiuShi *)qiuShi
{
    //config author
    if (qiuShi.author) {
        [_userIcon setImageWithURL:[NSURL URLWithString:qiuShi.authorImageURL] placeholderImage:[UIImage imageNamed:@"placeholder_icon.png"]];
        [_userIcon.layer setMasksToBounds:YES];
        [_userIcon.layer setCornerRadius:18.5];
        _name.text = qiuShi.author;
    } else {
        _userIcon.frame = CGRectZero;
        _name.frame = CGRectZero;
    }
    
    //config content
    _content.text = qiuShi.content;
    if (_userIcon.frame.size.height == 0) {
        _content.frame = CGRectMake(15, 15, 290, qiuShi.contentSize.height);
    } else {
        _content.frame = CGRectMake(15, 55, 290, qiuShi.contentSize.height);
    }
    
    //config image
    if (qiuShi.imageURL) {
        _image.frame = CGRectMake(10 , _content.frame.origin.y + _content.frame.size.height + 2, SCREEN_WIDTH - 20,  ((SCREEN_WIDTH - 20) / qiuShi.imageMidSize.width) * qiuShi.imageMidSize.height);
        [_image setImageWithURL:[NSURL URLWithString:qiuShi.imageMidURL] placeholderImage:[UIImage imageNamed:@"placeholder_image.png"]];
    } else {
        _image.frame = CGRectZero;
    }
    
    //config up and comment count
    _up.text = [NSString stringWithFormat:@"%d 好笑", qiuShi.upCount];
    _comment.text = [NSString stringWithFormat:@"%d 评论", qiuShi.commentsCount];
    [_up sizeToFit];
    [_comment sizeToFit];
    _separator.frame = CGRectMake(_up.frame.origin.x + _up.frame.size.width, _up.frame.origin.y, 20, 21);
    _comment.frame = CGRectMake(_separator.frame.origin.x + 20, _separator.frame.origin.y, _comment.frame.size.width, _comment.frame.size.height);

}


@end
