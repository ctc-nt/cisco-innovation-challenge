# CTC network のオペレーション手順


## 新規構築

新規構築時は、CML を使います


## 経路迂回

経路迂回の際は、以下のオペレーションを実施します

迂回させるために、不安定なリンクを shutdown します。

shutdown させるコマンドは、機器のソフトウェア種別によって異なります。

IOS の場合は、以下のコマンドを実行します

```
configure terminal
interface X
shutdown
```

IOS XR の場合は、以下のコマンドを実行します

```
configure
interface X
shutdown
commit
```

