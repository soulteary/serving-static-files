# 静态资源保存方案

![静态资源保存方案](./icon.png)

高度定制化的前端静态资源保存方案，减少前后端分离成本。

## 适用场景 && 解决问题

- 前后端发布有明显依赖关系，希望减少或者完全分离前后端开发&&上线依赖的场景；
- 希望使用一套方案管理多个前端应用；
- HTTPS CDN未就绪，需要回源机作为"CDN"使用的场景；
- 本方案支持单独为静态资源配置域名或将静态资源保存在已投入使用的域名的子目录下：
    - 单独配置资源域名: 各种前后端分离场景。后续说明以```独立域名方案```指代。
    - 已投入使用域名子目录: HTTPS CDN尚未投入使用或不需要将资源放置CDN的场景。后续说明以```域名目录方案```指代。
- 前端对静态文件有一些定制化需求：
    - 可以直接通过路径访问静态页面（SPA应用），且页面路径友好。
    - 资源需要支持concat（同版本、稳定版本和开发版本），以支持在线热补丁或者AB Test，以及debug等。

## 对项目的要求

- 需要将发布的版本按版本号(Semantic Versioning 2.0.0)归档储存，如:release/stable/1.0.2
- 当然如果你不愿意维护管理版本号，使用MD5短hash也可以。（8位，如：4621d373cade4e83）
- 如果需要保存静态页面，且不需要访问地址带版本号，需要将代码保存在: release/stable/lastest 或 release/trunk 下
- 处于不稳定状态的测试代码如需预发布测试，需要储存至 release/trunk
- 需要将最后发布的稳定版本代码同步或链接至statble/lastest目录下。

## 资源URL协议

### 通用文件访问

```
{{protocol}}://{{hostname}}/{{pathname(*optional)}}/{{application name}}/{{release status}}/{{version or random string}}/{{filename}}
```

## 访问示例

假设: resource.static.io 为资源机器域名；site.static.io 为已投入使用的域名。
resource.static.io 映射到 site.static.io/resource 目录下，我们需要访问名为demo的应用。

### 静态资源包含固定版本

用于使用指定版本号引入的资源，建议使用非覆盖发布，方便项目回滚和进行灰度测试。

#### 协议

```
{{protocol}}://{{hostname}}/{{pathname(*optional)}}/{{application name}}/{{release status}}/{{version}}/{{filename}}
```

#### 示例

```
http://site.static.io/resource/demo/stable/1.0.0/index.js
http://resource.static.io/release/demo/stable/1.0.0/index.js
http://site.static.io/resource/demo/stable/1.0.1/index.js
http://resource.static.io/release/demo/stable/1.0.1/index.js
http://site.static.io/resource/demo/stable/4621d373cade4e83/index.js
http://resource.static.io/release/demo/stable/4621d373cade4e83/index.js
```

### 静态资源包含随机时间戳

用于使用页面loader以时间戳控制的资源，通过使用loader控制缓存。

#### 协议

```
{{protocol}}://{{hostname}}/{{pathname(*optional)}}/{{application name}}/{{random string}}/{{filename}}
```

#### 示例

```
http://site.static.io/resource/demo/201501011213/index.js
http://resource.static.io/release/demo/201501011213/index.js
```

### 访问URL相对友好的静态页面

用于直接访问静态页面。

#### 协议

线上开发版本：

```
{{protocol}}://{{hostname}}/{{application name}}/{{filename}}.html
```

指定版本：

```
{{protocol}}://{{hostname}}/{{application name}}/{{release status}}/{{filename}}.html
```

#### 示例

```
## 线上版本
http://site.static.io/resource/demo/index.html
http://resource.static.io/release/demo/index.html

## 指定版本
http://site.static.io/resource/demo/trunk/index.html
http://resource.static.io/release/demo/trunk/index.html
```

### 动态Combo线上文件

用于线上调试，或者AB测试，以及支持Combo加载的loader。

#### 协议

同应用，不同分支文件合并加载：

```
{{protocol}}://{{hostname}}/{{pathname(*optional)}}/{{application name}}/??{{release status}}/{{version}}/{{filename}},{{release status}}/{{version}}/{{filename}}
```

同应用同发布分支，不同版本文件合并加载：

```
{{protocol}}://{{hostname}}/{{pathname(*optional)}}/{{application name}}/{{release status}}/??{{version}}/{{filename}},{{version}}/{{filename}}
```

同应用同发布分支同版本文件，不同文件合并加载：

```
{{protocol}}://{{hostname}}/{{pathname(*optional)}}/{{application name}}/{{release status}}/{{version}}/??{{filename}},{{filename}}
```

#### 示例

```
http://site.static.io/resource/demo/??stable/1.0.0/index.js,trunk/index.js
http://resource.static.io/release/demo/??stable/1.0.0/index.js,trunk/index.js

http://site.static.io/resource/demo/??stable/1.0.0/index.js,stable/lastest/index.js
http://resource.static.io/release/demo/??stable/1.0.0/index.js,stable/lastest/index.js

http://site.static.io/resource/demo/stable/??1.0.0/index.js,1.0.1/feature.js
http://resource.static.io/release/demo/stable/??1.0.0/index.js,1.0.1/feature.js

http://site.static.io/resource/demo/stable/1.0.1/??index.js,new-feature.js
http://resource.static.io/release/demo/stable/1.0.1/??index.js,new-feature.js
```

### 开发部署可选模式

- 项目由单人开发维护：
    - 使用版本号或者MD5保存项目稳定版本到```stable```目录下，当前开发分支状态保存于```trunk```目录下。
- 项目由多人开发维护：
    - 使用```参与者姓名或等价可靠标识```作为```{{release status}}```，其他同单人开发维护。


