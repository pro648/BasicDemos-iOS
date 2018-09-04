### UserNotifications框架详解

无论设备处于锁定状态还是使用中，都可以使用通知提供及时、重要的信息。无论app处于foreground、background或suspended状态，都可以使用通知发送信息。例如：体育类app可以使用通知告诉用户最新比分，还可以使用通知告诉app下载数据更新界面。通知的方式有显示横幅(banner)、播放声音和标记应用程序图标。

这个demo主要介绍了UserNotifications以下方面：

1. 申请通知权限。
2. 本地通知
3. 远程通知
4. payload
5. 可操作(actionable)通知发送和处理
6. 响应通知
7. Notification Service扩展
8. UserNotificationsUI框架

![UserNotifications](https://raw.githubusercontent.com/wiki/pro648/tips/images/UserNotifications.png)

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/UserNotifications框架详解>

##### 系统要求

iOS 10.0+
