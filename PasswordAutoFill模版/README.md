### Password AutoFill 的使用

这篇文章将介绍密码自动填充（Password AutoFill）如何与 iOS 和网页应用交互。

密码自动填充功能在以下几个事件与 app 配合使用：

- 用户首次安装 app，如已在 Safari 保存密码，可以直接点击 QuickType bar 账号信息登陆。
- 用户注册账号时，自动生成强密码，注册成功后保存到 iCloud Keychain。
- 输入短信验证码时，点击 QuickType bar 直接输入。

在 iOS 系统安装 app 后，系统会尝试将 app 与 Associated Domains Entitlement 文件列出的域名进行关联。

1. 系统获取 Associated Domains Entitlement 中每个域名。
2. 尝试下载每个域名中 Apple App Site Association 文件（apple-app-site-associatio）。
3. 如果上述步骤均成功，系统会将 app 与域名进行关联，并为该域的凭据（credential）开启 Password AutoFill 功能。

详细介绍查看下面文章：

<https://github.com/pro648/tips/wiki/Password-AutoFill-的使用>

##### 系统要求

iOS 12.0+
