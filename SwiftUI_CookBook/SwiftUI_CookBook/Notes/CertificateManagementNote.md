#  CertificateManagement

iOS Provision, Profile, p12, bundle identifier, team
Xcode gen




Apple Developer ID

Using personal AppleID
  or creating a new one for Business 

Register Type:
个人/独资企业
  以您的个人名义或独资企业名义发布应用程序。在此设置中，您亲自与 Apple 签订法律协议。如果您在上一节中决定使用您的个  人 Apple ID，那么这是一个不错的选择。

组织。代表公司
  组织。代表公司、非营利组织或某种其他类型的组织或法人实体发布应用程序。如果您要为雇主发布应用程序，则应选      择此选项。在这种设置中，一个单独的法人实体与 Apple 签订合同。



2.您在 App Store 中的第一个应用程序
关键点
*     您需要启用双因素身份验证的 Apple ID 才能注册 Apple 开发者计划。  
*     您可以使用现有的 Apple ID 或根据您的需要创建一个新的。
*     您可以作为个人或组织加入 Apple 开发者计划。确保使用应用发布者的开发者帐户。
*     捆绑 ID 在 Apple 生态系统中唯一标识您的应用程序。您不能使用其他应用程序使用的捆绑包 ID。
*     开发证书允许您在设备上安装应用程序。
*     分发证书允许您将构建版本上传到 App Store。
*     使用 Xcode 创建发行版本并将其上传到 App Store Connect。

3.提交您的第一个应用程序以供审核

您可以将 App Store Connect 视为App Store 的管理仪表板。
1. Apple 开发者门户：您可以访问开发者门户：developer.apple.com或通过 Developer iOS 应用程序。在开发人员门户中，您可以创建“标识符”，例如应用程序标识符、开发人员证书和配置文件。如果这些听起来不熟悉，第 4 章“代码签名和配置”详细介绍了证书和配置文件。您还需要开发人员门户来下载 Xcode 和 Apple 操作系统的测试版。

2.App Store Connect：您可以通过appstoreconnect.apple.com或通过 App Store Connect iOS 应用程序访问 App Store Connect 。您通常需要进入 App Store Connect 添加新的“应用程序记录”（稍后详细介绍）、添加应用程序的新版本、提交应用程序以供审核、管理用户、签署合同以及与应用程序审核者互动。

随时随地管理您的提交
 iOS 设备上的 App Store 并搜索“App Store Connect”

App Review:
对应用程序审核有何期望？
以下是苹果拒绝应用程序的几个原因。有些是显而易见的，但另一些可能会让您感到惊讶。
1. 崩溃：如果您的应用程序在启动时或在明显的地方崩溃。
2. 屏幕截图不准确：如果您的应用程序屏幕截图无法准确解释您的应用程序的功能。
3. 低于标准的用户界面：如果您的应用程序严重偏离Apple的人机界面指南，并且您没有提供用户友好的替代方案。
4. 不完整的应用内购买：如果您没有正确实现 IAP 功能（例如，缺少“恢复”功能）。
5. 不允许的应用程序类别：Apple 平台上不允许使用整个类别的应用程序。例如，您无法制作启动其他应用程序的“启动器”应用程序。
6. 私有 API 使用：您的应用程序不能使用专为 Apple 内部使用而构建的框架。人工审核人员无法发现这一点，但应用程序审核也会扫描您的构建是否存在违规行为。

平均而言，Apple 会在 24 小时内审核 50% 的应用程序，在 48 小时内审核 90% 的应用程序。如果您提交的内容存在问题，Apple 会在 App Store Connect 中显示该问题。您可以使用“解决方案中心”在 App Store Connect 中与应用程序审阅者互动。

关键点
* 您需要在开发者门户中设置应用程序 ID ，并在 App Store Connect 中设置应用程序记录，以便可以从 Xcode 上传构建版本。



4.Code Signing & Provisioning

Provisioning Profile:
1 Who are you? 
  App ID Team ID
2 What do you want to do?
  Entitlements
3 Can I trust you?
  Certificate











