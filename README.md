# Win10_LTSC_2021_FixPacks
一键修复win10 ltsc 2021官方镜像的CPU占用问题，输入法显示问题并添加微软应用商店。

## 说明

**本文件中的激活模块整合了luzea9903 的 winactivate和massgravel 的 Microsoft-Activation-Scripts**

winactivate项目地址：https://github.com/luzea9903/winactivate

Microsoft-Activation-Scripts项目地址：https://github.com/massgravel/Microsoft-Activation-Scripts

**两种激活方法均可以使用，随便选一个使用就可以，如果有一个失败，尝试运行另外一个**

**官方的Win10 LTSC 2021镜像存在的bug**

- 进程`wsappx`长期占用CPU资源。
- 微软中文输入法不显示候选词。
- 缺少微软应用商店。

**问题分析**

查阅得知`wsappx`是微软应用商店自动更新相关的服务，所以猜测可能是因为LTSC系统中微软精简掉了微软应用商店和UWP应用的相关服务，所以有可能是缺少相应的运行环境，导致`wsappx`死循环无法正常工作，从而占用大量的CPU资源。

对于微软中文输入法不显示候选词的显示问题，当我们进入>微软拼音输入法设置>常规>兼容性中选择使用以前版本的输入法后，输入法显示正常。所以这个显示问题仅仅出现在新版本的输入法上面，而在普通消费者版本的Win10 21H2版本中，输入法并不存在此问题。所以猜测有可能是因为精简版本中精简掉不必要的文件，而导致的bug。

通过查阅得知，以上问题都是因为LTSC精简掉了这些软件所需要的VCLibs依赖库，导致部分功能无法实现，于是就出现了bug。

所以需要解决此问题仅需要手动安装VCLibs库即可。

考虑到日常使用中微软应用商店还是比较方便的，而微软商店同时需要VCLibs依赖库，所以本脚本解决以上问题的方案为安装微软应用商店。

## 使用方法

1. 前往项目 release 处下载文件 `Win10_LTSC_2021_FixPacks.zip`。

   如果速度过慢，这里提供另外的下载地址。

   文件分享地址：[https://www.123pan.com/s/yCC9-8Ig23](https://www.123pan.com/s/yCC9-8Ig23) 提取码:6666

   分享链接中的两个win10 LTSC 2021镜像分别为微软官方的64位和32位镜像。

2. 解压下载的压缩包文件。

3. 右键以管理员权限运行`RunThis.cmd`文件。

   ![](https://pic.imgdb.cn/item/629180020947543129f91dc8.jpg)

4. 根据提示和需求选择相应的运行选项。
