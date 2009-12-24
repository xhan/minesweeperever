Title:  MineSweeper Ever! Readme
Author: xhan
Date:   December 24, 2009

# MINE SWEEPER EVER

游戏介绍
---------
MINE SWEEPER EVER是经典的扫雷iphone版本.你可以在app store上免费下载 [Link](http://itunes.apple.com/us/app/minesweeperever/id345567798?mt=8)

![截图](http://ixhan.com/wp-content/uploads/2009/12/mainShot.jpg)

你可能可以学到什么
---------------
* 一个完整的游戏(片头,菜单,光卡,排行榜)
* 基本UIKIT界面的使用,手写和nib的混合
* 不同界面间传递消息
* 播放视频
* 简单游戏的状态机
* UserDefault的使用和简单的排行榜

在编译之前
-----------
由于资源文件比较多,开场视频是大头,还有许多策划时涂鸦使用的ps文件,请移步下载 `http://ixhan.com/kill/MineSweeperEver-Resource.zip` 到当前目录并解压.


为什么写这个小游戏
-----------

半年前(May 2009)做毕业设计([PlutoCMS](http://ixhan.com/2009/10/plutocms-ruby-on-rails-cms/))的时候头昏脑涨,逐下载了iPhoneSDK把玩下,原意是测试下学校带宽并看看iPhone模拟器是什么样子的.结果控制不住看了 iPhone cookbook ,记得第一章有个教你嵌套绘制图层 和 响应手指点击的 两个片段 .于是就想到了由两个技术做个扫雷绰绰有余,两个晚上后做了个只能扫雷不能放置旗帜的半成品就撒手不管.继续回头研究俺的毕业设计了. 

离职后的这段时间刚好有些空闲,决定把之前未完成的东西收尾,并开源给有需要的人.花费了一个下午修改完善了下之前的代码,又花了一个晚上和一个早上把其他东西(几个界面,排行榜)添加了上去.最后是UI方面,第一个晚上画了个logo,简单策划了下大概需要的素材,还找了美工朋友帮我画了个坑,可是第二天在ps中做素材发现还是无法掌控美术上的东西,干脆决定用windows上经典的界面.

等待9天后通过审核,然后在那天上海iphone会议上才在mars的真机上见到自己的程序(惭愧呀,iphone因经济危机被我卖了),感觉还不是特别糟糕.哈哈.

许多特性没来得及加上去:

* 互联网排行榜功能
* 退出保存当前状态功能
* 左右手不同界面
* 长按或双击添加/取消 旗帜功能
* 荣誉系统 ,包括炸死次数,成功次数,等等.

不过作为一个简单的教程应该还是够了.可能再过几个月闲的没事会改改~.
