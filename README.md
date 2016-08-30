
# 设计灵感
设计此效果的作者 [Nick](https://material.uplabs.com/nickbuturisvili);
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/download.gif)


# 开始之前你需要了解的
先上一张CAAnimation层次图:
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/caanimation.png)

图上只是一些类的常用属性,后边更多代码会讲到.

# 怎样分解动画

关于分解gif,其实用mac 预览 开发gif文件,就可以看到所有帧的图片.
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/fenjie_download.png)

选取其中几张动画节点的图片存好备用.比如:
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/download1.png)
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/download2.png)
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/download3.png)
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/download4.png)
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/download5.png)

考虑到适配问题service类里已经提取好了.

# 怎样连贯动画

连贯动画是展示你做的效果流畅不流畅,看着舒服不舒服的能力.其实我是也是尝试很多遍,让很多人看了这个效果,有说别扭的咱就改,咋顺咋来.所以让动画连贯起来尤为重要.

第一,就是要动画节点要选准确,定位好动画与动画的衔接处.
第二,让动画结束时,恢复自然状态,而不是默认状态.尽量不要有太大的差异和不规整的地方
第三,使用组合动画,掐好时间节点.

简单的就说就说这么多,下面我们开始演练代码~~~~~~

# 代码实现 

## 基本实现想法
1.自定义UIControl类,因为它本身就是UIView子类,做点击事件的View再好不过.(另一种方式用block点击回调)
2.点击区域是否在圆内判断
3.两个CAShapeLayer圆环+(一个CAShapeLayer箭头和CAShapeLayer竖线)组合成箭头+label
4.一个service类管理创建所用到的path和animation


## service 类
### service属性
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/service_shuxing.png)
### service方法
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/service_method.png)
### service key
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/service_m_1.png)
### service 比例系数
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/service_m_2.png)

## download 类
### 属性
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/download_h.png)
### 所有方法预览
![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/download_all.png)

方法比较多,在这不一一展示了,有感兴趣的童鞋可以直接去[github下载](https://github.com/Josin22/JSDownloadView),记得点个星星哦~~~😜


# 最终效果

现实与理想还是有些差距,希望不是很大,在此分享一下自己研究的经验,有任何问题都可以Issues我,

![images](https://raw.githubusercontent.com/Josin22/JSDownloadView/master/JSDownloadView/Source/download_animation.gif)



# 