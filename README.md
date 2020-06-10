## 概要

docker で VPN サーバを立てるために使用します。

* 初回起動時、etc/cert.env 設定をもとに CA, サーバ証明書の生成を行います。  
  作成された証明書は etc/ipsec.d ディレクトリに保存されます。

* ect/certs.env の VPNSERVER_NAME にはサーバのグローバルIPアドレス、またはドメイン名を指定します。  
  同じ内容を etc/ipsec.conf の leftid に指定してください。

## サーバ起動手順

```
vi etc/ipsec.conf
vi etc/ipsec.secrets
vi etc/cert.env

docker-compose build
docker-compuse up
```

## クライアント側に CA 証明書のインストール

サーバ起動したあと、生成された CA 証明書 etc/ipsec.d/cacerts/ca.der をクライアント側にインストールしてください。  

Mac の場合、インストール後にキーチェーンを起動し、インストールされた証明書をダブルクリックし、信頼 > この証明書を使用するとき のところで「常に信頼」に変更してください。

