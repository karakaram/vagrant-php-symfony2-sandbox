# vagrant-php-symfony2-sandbox

## 概要

Symfony2.4 環境を CentOS6.5 上に構築します。vagrant up 後、すぐに Symfony を動作させることができます。

Windows7, Max OS X での動作確認を取っています。

* CentOS6.5
* Nginx, PHP-FPM
* PHP5.5, OPcache, APCu, Xdebug, PHPUnit, Composer
* MySQL5.6
* Samba(for Windows)
* Symfony2.4

## 使い方

### プラグインをインストール

Windows の場合は vagrant up する前に vagrant-windows プラグインをインストールしてください。

```
$ vagrant plugin install vagrant-windows
```

推奨プラグイン。Guest Additions のバージョンを最新版に自動更新します。

```
$ vagrant plugin install vagrant-omnibus
```

### vagrant up

```
$ git clone https://github.com/karakaram/vagrant-php-symfony2-sandbox
$ cd vagrant-php-symfony2-sandbox
$ vagrant up
```

## 動作確認

### phpinfo

http://192.168.33.10/symfony/web/_profiler/phpinfo

### Symfony2 デモ画面

http://192.168.33.10/symfony/web/

# Xdebug を有効にしたい場合

初期状態では Xdebug を無効にしています。有効にする場合は Vagrantfile の chef.json xdebug_enable 1 にして vagrant provision してください。

```
# vagrant-php-symfony2-sandbox/Vagrantfile

config.vm.provision :chef_solo do |chef|
...
chef.json = {
  ...
  php: {
    ...
    xdebug_enable: 1,
    ...
  }
  ...
}
```

vagrant provision で変更を反映します。

```
$ vagrant provision
```

# Samba を有効にしたい場合


初期状態では Samba を無効にしています。有効にする場合は Vagrantfile の chef.json samba:enable: 1 にして vagrant provision してください。

```
# vagrant-php-symfony2-sandbox/Vagrantfile

...
chef.json = {
  ...
  samba: {
    enable: 1,
  }
  ...
}
```

vagrant provision で変更を反映します。

```
$ vagrant provision
```

共有フォルダへは以下のようにアクセスできます。

```
\\192.168.33.10\vagrant
```
