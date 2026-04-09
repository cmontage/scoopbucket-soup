# 📦 ScoopBucket-Soup 🍜

[![Scoop](https://img.shields.io/badge/Scoop-Manifests-blue.svg)](https://scoop.sh/) [![License](https://img.shields.io/badge/license-BSD--2--Clause-orange.svg)](LICENSE)

> 一个自用熬制的 Scoop 软件源。包含许多常用的国产软件及工具。

### ✨ 本仓库特性 (Features)

- **数据持久化**：针对常用国产软件进行深度优化，通过 `persist` 或 `Junction` 技术，尽可能（如果可以）确保应用设置、聊天记录等数据在升级或重装时得以保留。
- **卸载更纯净**：精心编写卸载脚本，在卸载应用时自动清理残留的缓存、临时文件及路径，尽力争取做到卸载不留痕。

---

## 🚀 如何使用 (How to use)

在 PowerShell 中运行以下命令添加此存储库：

```powershell
scoop bucket add soup 'https://gitee.com/cmontage/scoopbucket-soup'
```

---

## 🛠️ 应用清单 (App Manifests)

以下是当前 Bucket 中包含的所有应用及其简述：

<!-- APP_LIST_START -->
| 应用名称 | 描述 | 官方网站 |
| :--- | :--- | :--- |
| **123pan** | 123云盘是一款空间大、不限速、专注大文件传输分发的云存储服务产品。 | [Link](https://www.123pan.com/) |
| **adrive** | 一款速度快、不打扰、够安全、易于分享的网盘 | [Link](https://alipan.com/) |
| **baidunetdisk** | 百度网盘，百度公司推出的云存储服务 | [Link](https://pan.baidu.com/download) |
| **bilibili-livehime** | 哔哩哔哩直播姬 | [Link](https://link.bilibili.com/p/eden/download#/web) |
| **dingtalk** | 钉钉，企业协作与办公沟通平台。 | [Link](https://www.dingtalk.com/) |
| **dingtalk-gov** | 浙政钉 | [Link](https://www.ding.zj.gov.cn/pc/index.html) |
| **douyin** | 短视频社交应用程序，记录美好生活 | [Link](https://douyin.com/) |
| **downkyi** | Bilibili视频下载助手 | [Link](https://github.com/leiurayer/downkyi) |
| **feishu** | 新一代知识管理平台 | [Link](https://feishu.cn/) |
| **gemini-cli** | An open-source AI agent that brings the power of Gemini directly into your terminal | [Link](https://github.com/google-gemini/gemini-cli) |
| **hbuilderx** | HBuilderX，简称HX，轻如编辑器、强如IDE | [Link](https://www.dcloud.io/hbuilderx.html) |
| **iobit-unlocker** | Never Worry about Cannot Delete Files on Your PC | [Link](https://www.iobit.com/en/iobit-unlocker.php) |
| **lx-music** | An electron-based music player | [Link](https://github.com/lyswhut/lx-music-desktop) |
| **m3u8-downloader** | M3U8下载器，支持多线程下载、断点续传、自动合并等功能 | [Link](https://github.com/HeiSir2014/M3U8-Downloader/) |
| **navicat-premium-lite-cn** | Database administration and development tool | [Link](https://navicat.com.cn/products/navicat-premium-lite) |
| **neteasemusic** | 网易云音乐客户端，发现好音乐。 | [Link](https://music.163.com/) |
| **pot-desktop** | 一个跨平台的划词翻译和OCR软件 | [Link](https://pot-app.com/) |
| **qqnt** | QQ Windows版，全新NT架构，轻松做自己。 | [Link](https://im.qq.com/pcqq/index.shtml) |
| **quark** | 夸克浏览器，学习、工作、生活的高效拍档。 | [Link](https://www.quark.cn/) |
| **tim** | 团队沟通协作工具 | [Link](https://tim.qq.com/) |
| **todesk** | ToDesk远程桌面软件-免费安全流畅的远程连接电脑手机 | [Link](https://www.todesk.com/) |
| **total-uninstall-pro** | Total Uninstall Pro, Modified Version. | [Link](https://www.martau.com/) |
| **utools** | Your productive tools set and launcher. | [Link](https://u.tools/) |
| **uuyc** | 网易UU远程，提供低延迟远程连接与云游戏体验。 | [Link](https://uuyc.163.com/) |
| **wechat-devtools** | To help developers develop and debug Weixin Mini Programs more simply and efficiently. | [Link](https://developers.weixin.qq.com/miniprogram/dev/devtools/download.html) |
| **wecom** | WeCom/WXWork/企业微信/WeChat-Work, a professional office management tool for enterprises created by Tencent | [Link](https://work.weixin.qq.com/) |
| **weflow** | WeFlow - 一个本地的聊天导出和年度报告应用 | [Link](https://github.com/hicccc77/WeFlow) |
| **wemeet** | 腾讯会议是一款支持多场景、多平台、高清流畅的在线会议软件。 | [Link](https://meeting.tencent.com) |
| **wpsoffice-cn** | WPS Office 协同办公软件（国内版） | [Link](https://www.wps.cn) |
| **yuque** | Professional note and document repositories | [Link](https://yuque.com/) |
<!-- APP_LIST_END -->

---

## 📝 贡献内容 (Contributing)

如果您想添加新软件：
1. 请遵循 `bucket/` 目录下的 JSON 规范。
2. 运行 `bin/formatjson.ps1` 格式化您的提交。
3. 提交 PR！

---

## ⚖️ 许可证 (License)

本项目采用 [BSD 2-Clause License](LICENSE) 授权。



