# おんどとりWebStorageから現在の温度一覧を取得します

## 準備
1. [WebStorageのサイト](https://ondotori.webstorage.jp/account/create-apikey.php)からアクセスキーなどを取得する
2. 上記で取得した情報を以下のフォーマット(json形式)で/var/tmp/webstorage.jsonに記載する

```
ファイルは以下の形式を想定
{
    "api_key":"xxxxxxxxxxxxxxxxxxxxxxxxx",
    "user_id" : "rbacXXXX",
    "user_pass" : "*******"
    "_comment" : "OndotoriWebStorage API Key and view only account info"
}
```
