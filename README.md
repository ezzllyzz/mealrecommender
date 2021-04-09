# Meal Recommender #

### 内啥微信里面说太乱了我就直接在这写了嗷 ###
 * 目前的code完成了natural language的部分，可以进行一次问答，试图写无限问答的loop完全失败。
 * 小圆现在的想法大概就是，先写一个可以根据要求找dish name的基础project，如果还有精力的话再加也可以找出他们的recipe的功能。（只是想法elly也可以按照自己的来嗷（比如说我再起床就能api直接输出recipe了啥的）
 * code里面也写了dictionary，写上了那个网站上所有area和category的种类。
 * 现在的逻辑是用q(Ans)启动UI，可以用类似于 what can I eat for dessert 和 Give me a recipe of chinese food之类的话输入，目前返回的是他们之中的那个需要后期用api去网站上找的关键词(eg. category的dessert和area的chinese)
 * grammar部分是在geology.pl 的基础上做了一点点延伸，**elly写api需要更改的部分大概只有 noun([X | L],L,X) :- category(X). 和 adj([X | L],L,X) :- area(X). 这两个function，目前为了debug方便他们return的（也就是q(Ask) return的）是关键词。**

大噶就是这些辽！elly加油！小圆先去睡觉了嗷！明天见！
