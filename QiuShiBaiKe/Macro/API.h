//
//  API.h
//  QiuShiBaiKe
//
//  Created by conrad on 14-7-8.
//  Copyright (c) 2014年 conrad. All rights reserved.
//

#ifndef QiuShiBaiKe_API_h
#define QiuShiBaiKe_API_h


/*-----------QSBK api接口-----------*/

//***********糗事**********
// count:每页请求个数
//  page:当前页码
//************************
//图文
#define api_scandals_imgtext(count, page)   [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/suggest?count=%d&page=%d", count, page]
//纯文
#define api_scandals_onlytext(count, page)  [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/text?count=%d&page=%d", count, page]
//纯图
#define api_scandals_onlyimage(count, page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/imgrank?count=%d&page=%d", count, page]
//最新
#define api_scandals_latest(count, page)    [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/latest?count=%d&page=%d", count, page]
//精华
#define api_scandals_elite(count, page)     [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/list/day?count=%d&page=%d", count, page]


//************查看评论**********
//    id:糗事ID
// count:每页请求个数
//  page:当前页码
//*****************************
#define api_comment_browse(id, count, page) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/%@/comments?count=%d&page=%d", id, count, page]


//************发表评论**********
//      id:糗事ID
// POST请求:
//         Header:Qbtoken
//         参数:{"content" : "啊啊啊","anonymous" : false}
//*****************************
#define api_comment_create(id) [NSString stringWithFormat:@"http://m2.qiushibaike.com/article/%@/comment/create", id]

//登录:POST
#define api_owner_login                           @"http://m2.qiushibaike.com/user/signin"

//附近糗友:POST Header:Qbtoken
#define api_nearby_user                           @"http://nearby.qiushibaike.com/nearby/fetch"

//关闭附近功能，并清除位置:POST Header:Qbtoken
#define api_nearby_clearloc                       @"http://nearby.qiushibaike.com/nearby/clear_loc"

//小纸条列表:GET Header:Qbtoken
#define api_message_list(page)                   [NSString stringWithFormat:@"http://msg.qiushibaike.com/messages/list?page=%d", page]



//我收藏的: GET Header:Qbtoken
#define api_mine_collect(page, count)            [NSString stringWithFormat:@"http://m2.qiushibaike.com/collect/list?page=%d&count=%d", page, count]

//我评论的: GET Header:Qbtoken
#define api_mine_participate(page, count)        [NSString stringWithFormat:@"http://m2.qiushibaike.com/user/my/participate?page=%d&count=%d", page, count]

//我发表的: GET Header:Qbtoken
#define api_mine_articles(page, count)           [NSString stringWithFormat:@"http://m2.qiushibaike.com/user/my/articles?page=%d&count=%d", page, count]

//收藏功能 POST Header:Qbtoken
#define api_qiushi_collect(id)                   [NSString stringWithFormat:@"http://m2.qiushibaike.com/collect/%@", id]

//取消收藏功能 DELETE Header:Qbtoken
#define api_qiushi_delete(id)                    [NSString stringWithFormat:@"http://m2.qiushibaike.com/collect/%@", id]

//顶、踩糗事:POST
#define api_qiushi_vote                          @"http://vote.qiushibaike.com/vote_queue"

//************发布糗事**********
// POST请求:
//         Header:Qbtoken
//                Content-Type:multipart/form-data
//          boundary=ixhan-dot-com
//*****************************
#define api_qiushi_create                        @"http://m2.qiushibaike.com/article/create"

#endif
