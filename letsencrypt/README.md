# 证书操作容器

## 说明

获得和更新Letscrypt证书。域名需注册在aliyun，并获取API访问ak和sk。

## 打包

```shell
docker build --no-cache -t tier_letsencrypt .
```

## 取得证书

支持获取多个域名和通用域名证书。

```shell
docker run -it --rm -e "ali_ak=access_key" -e "ali_sk=access_secret_key" -e "email=simon@tiertime.net" -v ./ssl/:/etc/letsencrypt/ tier_letsencrypt obtain_cert -d "*.tiertime.net"
```

*生成的证书在当前目录下的ssl目录里，目录不要移动，更新的时候还需要这个路径。*

## 刷新证书

```shell
docker run -it --rm -v ./ssl/:/etc/letsencrypt/ tier_letsencrypt renew_certs
```
