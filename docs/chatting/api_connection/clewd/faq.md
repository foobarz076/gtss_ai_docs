# Clewd 常见问题

!!! quote
    
    好消息！本页和各大浏览器均达成了合作，使用 ++ctrl+f++ (Windows) / ++command+f++ (macOS) 即可快速搜索关键词！

## 于终端输出的错误消息

## 于聊天界面上输出的错误消息

### 400 Bad Request

#### temperature: Extra inputs are not permitted 

* 原因：Claude.ai 不再支持传递温度参数。

* 解决方法：将`config.js`中的`PassParams`参数改为 false，然后重启 clewd。

```text
"PassParams": false,
```

## 其它问题