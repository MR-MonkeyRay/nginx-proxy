# What is it?

Build a docker image based on Nginx:1.21.6 for Forward Proxy.

# How to build

```bash
git clone https://github.com/MR-MonkeyRay/nginx-proxy-docker.git

cd nginx-proxy-docker

docker build . -t monkeyray/nginx-proxy:latest
```

# How to deploy

Install docker-ce first. And then run the docker.

```bash
docker run -d \
    --name nginx-proxy \
    -p 1080:1080 \
    --restart always \
    --pull always \
    -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
    monkeyray/nginx-proxy:latest

# Check if container is running
docker ps
```

# How to test

For example:

My host IP is 127.0.0.1 and it's listening on 1080 port.

```bash
curl www.baidu.com -x 127.0.0.1:1080

* About to connect() to proxy 127.0.0.1 port 1080 (#0)
*   Trying 127.0.0.1...
* Connected to 127.0.0.1 (127.0.0.1) port 1080 (#0)
> GET HTTP://www.baidu.com/ HTTP/1.1
> User-Agent: curl/7.29.0
> Host: www.baidu.com
> Accept: */*
> Proxy-Connection: Keep-Alive
> 
< HTTP/1.1 200 OK
< Server: nginx
< Date: Fri, 01 Apr 2022 07:52:50 GMT
< Content-Type: text/html
< Content-Length: 2381
< Connection: keep-alive
< Accept-Ranges: bytes
< Cache-Control: private, no-cache, no-store, proxy-revalidate, no-transform
< Etag: "xxxxxxx"
< Last-Modified: Mon, 23 Jan 2017 13:28:12 GMT
< Pragma: no-cache
< Set-Cookie: BDORZ=27315; max-age=86400; domain=.baidu.com; path=/
< 
<!DOCTYPE html>
<!--STATUS OK--><html> <head><meta http-equiv=content-type content=text/html;charset=utf-8><meta http-equiv=X-UA-Compatible content=IE=Edge><meta content=always name=referrer><link rel=stylesheet type=text/css href=http://s1.bdstatic.com/r/www/cache/bdorz/baidu.min.css><title>百度一下，你就知道</title></head> <body link=#0000cc> <div id=wrapper> <div id=head> <div class=head_wrapper> <div class=s_form> <div class=s_form_wrapper> <div id=lg> <img hidefocus=true src=//www.baidu.com/img/bd_logo1.png width=270 height=129> </div> <form id=form name=f action=//www.baidu.com/s class=fm> <input type=hidden name=bdorz_come value=1> <input type=hidden name=ie value=utf-8> <input type=hidden name=f value=8> <input type=hidden name=rsv_bp value=1> <input type=hidden name=rsv_idx value=1> <input type=hidden name=tn value=baidu><span class="bg s_ipt_wr"><input id=kw name=wd class=s_ipt value maxlength=255 autocomplete=off autofocus></span><span class="bg s_btn_wr"><input type=submit id=su value=百度一下 class="bg s_btn"></span> </form> </div> </div> <div id=u1> <a href=http://news.baidu.com name=tj_trnews class=mnav>新闻</a> <a href=http://www.hao123.com name=tj_trhao123 class=mnav>hao123</a> <a href=http://map.baidu.com name=tj_trmap class=mnav>地图</a> <a href=http://v.baidu.com name=tj_trvideo class=mnav>视频</a> <a href=http://tieba.baidu.com name=tj_trtieba class=mnav>贴吧</a> <noscript> <a href=http://www.baidu.com/bdorz/login.gif?login&amp;tpl=mn&amp;u=http%3A%2F%2Fwww.baidu.com%2f%3fbdorz_come%3d1 name=tj_login class=lb>登录</a> </noscript> <script>document.write('<a href="http://www.baidu.com/bdorz/login.gif?login&tpl=mn&u='+ encodeURIComponent(window.location.href+ (window.location.search === "" ? "?" : "&")+ "bdorz_come=1")+ '" name="tj_login" class="lb">登录</a>');</script> <a href=//www.baidu.com/more/ name=tj_briicon class=bri style="display: block;">更多产品</a> </div> </div> </div> <div id=ftCon> <div id=ftConw> <p id=lh> <a href=http://home.baidu.com>关于百度</a> <a href=http://ir.baidu.com>About Baidu</a> </p> <p id=cp>&copy;2017&nbsp;Baidu&nbsp;<a href=http://www.baidu.com/duty/>使用百度前必读</a>&nbsp; <a href=http://jianyi.baidu.com/ class=cp-feedback>意见反馈</a>&nbsp;京ICP证030173号&nbsp; <img src=//www.baidu.com/img/gs.gif> </p> </div> </div> </div> </body> </html>

```

# How to update

```bash

# Stop current running container
docker stop nginx-proxy

# Remove old container
docker rm nginx-proxy

# Run new container
docker run -d \
    --name nginx-proxy \
    -p 1080:1080 \
    --restart always \
    --pull always \
    -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
    monkeyray/nginx-proxy:latest

# Check if container is running
docker ps
```