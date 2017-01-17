# JSONParseTest
6个开源库的JSON解析速度测试

在iOS开发中，有很多人使用 [SBJSON](https://github.com/stig/json-framework) （又被称作json-framework)来做JSON解析库。我想这是因为SBJSON是最早在iOS上出现的JSON解析库。但是随着iOS开发的流行，越来越多优秀的JSON解析库也涌现出来, SBJSON和它们相比，性能上有很大的差距。

现在iOS行业内主要流行的JSON解析库有：
[NSJSONSerialization](http://developer.apple.com/library/ios/#documentation/Foundation/Reference/NSJSONSerialization_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40010946)、
[NextiveJson](https://github.com/nextive/NextiveJson)、
[TouchJSON](https://github.com/TouchCode/TouchJSON)、
[SBJSON](http://github.com/stig/json-framework)、
[YAJL](http://github.com/gabriel/yajl-objc)、
[JSONKit](http://github.com/johnezang/JSONKit)

iOS API新增了JSON解析的API，我们将其和其他五个开源的JSON解析库进行了解析速度的[测试](http://lib.csdn.net/base/softwaretest)，下面是测试的结果和工程代码附件。

我们选择了四个包含json格式的数据的文件进行测试。每一个文件进行100的解析动作，对解析的时间进行比较。

工程包含以下的文件和框架：
![项目框架](http://upload-images.jianshu.io/upload_images/2230056-f68ea4351f1e6091.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

测试时间间隔的的代码的宏定义如下，其中计算的次数和解析的代码由外部调用传入：
```objc
#define RunWithCount(count, description, expr) \
do { \
CFAbsoluteTime start = CFAbsoluteTimeGetCurrent(); \
for(NSInteger i = 0; i < count; i++) { \
expr; \
} \
\
CFTimeInterval took = CFAbsoluteTimeGetCurrent() - start; \
NSLog(@"%@ %0.3f", description, took); \
\
} while (0)
```

这是外面调用的代码，设置读取的json文件和计算的次数，每一个函数在进行对应框架API的解析代码：
```
JSONTest *test = [[JSONTest alloc] init];

NSInteger count = 100;

[test runWithResourceName:@"twitter_public.json" count:count];
NSLog(@"\n\n\n");
[test runWithResourceName:@"lastfm.json" count:count];
NSLog(@"\n\n\n");
[test runWithResourceName:@"delicious_popular.json" count:count];
NSLog(@"\n\n\n");
[test runWithResourceName:@"yelp.json" count:count];
NSLog(@"\n\n\n");
```
我们的测试的环境是Xcode 8.2.1和iOS10，计算次数是100次，这是计算的结果Log：
```
2017-01-17 16:42:34.557 JSONParseTest[21468:1030203] NSJSONSerialization-twitter_public.json 0.029
2017-01-17 16:42:34.604 JSONParseTest[21468:1030203] YAJL-twitter_public.json 0.046
2017-01-17 16:42:34.658 JSONParseTest[21468:1030203] NextiveJson-twitter_public.json 0.053
2017-01-17 16:42:34.715 JSONParseTest[21468:1030203] JSONKit-twitter_public.json 0.056
2017-01-17 16:42:34.834 JSONParseTest[21468:1030203] TouchJSON-twitter_public.json 0.118
2017-01-17 16:42:35.098 JSONParseTest[21468:1030203] SBJSON-twitter_public.json 0.264

2017-01-17 16:42:35.145 JSONParseTest[21468:1030203] NSJSONSerialization-lastfm.json 0.044
2017-01-17 16:42:35.208 JSONParseTest[21468:1030203] YAJL-lastfm.json 0.063
2017-01-17 16:42:35.298 JSONParseTest[21468:1030203] NextiveJson-lastfm.json 0.089
2017-01-17 16:42:35.387 JSONParseTest[21468:1030203] JSONKit-lastfm.json 0.089
2017-01-17 16:42:35.602 JSONParseTest[21468:1030203] TouchJSON-lastfm.json 0.214
2017-01-17 16:42:36.012 JSONParseTest[21468:1030203] SBJSON-lastfm.json 0.409

2017-01-17 16:42:36.064 JSONParseTest[21468:1030203] NSJSONSerialization-delicious_popular.json 0.050
2017-01-17 16:42:36.119 JSONParseTest[21468:1030203] YAJL-delicious_popular.json 0.054
2017-01-17 16:42:36.193 JSONParseTest[21468:1030203] NextiveJson-delicious_popular.json 0.073
2017-01-17 16:42:36.275 JSONParseTest[21468:1030203] JSONKit-delicious_popular.json 0.082
2017-01-17 16:42:36.430 JSONParseTest[21468:1030203] TouchJSON-delicious_popular.json 0.154
2017-01-17 16:42:36.771 JSONParseTest[21468:1030203] SBJSON-delicious_popular.json 0.341

2017-01-17 16:42:36.808 JSONParseTest[21468:1030203] NSJSONSerialization-yelp.json 0.034
2017-01-17 16:42:36.856 JSONParseTest[21468:1030203] YAJL-yelp.json 0.047
2017-01-17 16:42:36.922 JSONParseTest[21468:1030203] NextiveJson-yelp.json 0.065
2017-01-17 16:42:37.001 JSONParseTest[21468:1030203] JSONKit-yelp.json 0.078
2017-01-17 16:42:37.139 JSONParseTest[21468:1030203] TouchJSON-yelp.json 0.137
2017-01-17 16:42:37.487 JSONParseTest[21468:1030203] SBJSON-yelp.json 0.347
```
将上面的数据整理成下面的图表：

![6个开源库的JSON解析速度测试.png](http://upload-images.jianshu.io/upload_images/2230056-f1ab5a1f314ad912.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

测试的结果显示，系统的API的解析速度最快，我们在工程项目中选择使用，也是应用较为广泛的SBJSON的解析速度为倒数第二差，令我大跌眼镜。
与系统API较为接近的应该是YAJL。

这里没有对API的开放接口和使用方式进行比较，若单纯基于以上解析速度的测试：
1：尽量选择系统的API进行
2：如果使用第三方,建议使用YAJL

####结论(四组数据的平局值显示):

1. NSJSONSerialization(0.05325)
2. YAJL(0.07325)
3. NextiveJson(0.09875)
4. JSONKit(0.10325)
5. TouchJSON(0.21575)
6. SBJSON(0.448) 


程序附件链接：
https://github.com/zhongad/JSONParseTest
