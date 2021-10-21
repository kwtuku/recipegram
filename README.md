# [Recipegram](https://recipegram-kwtuku.herokuapp.com/)

<p>
  <img alt="ruby version" src="https://img.shields.io/badge/Ruby-v2.7.3-701516">
  <img alt="rails version" src="https://img.shields.io/badge/Rails-v6.1.3.1-cc0000">
  <img alt="Lines of code" src="https://img.shields.io/tokei/lines/github/kwtuku/recipegram">
  <img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/m/kwtuku/recipegram">
  <img alt="GitHub deployments" src="https://img.shields.io/github/deployments/kwtuku/recipegram/recipegram-kwtuku">
</p>

## 概要

Instagramのクローンアプリで、画像付きのレシピを投稿するSNSです。**通知**、**検索**、**無限スクロール**、**タグ**機能などがあります。

https://recipegram-kwtuku.herokuapp.com/

アプリのURLはこちらです。ゲストログインというボタンから**ワンクリックでログイン**することができます。Herokuにデプロイしていますが、GASで定期的にアクセスをしているので、**表示は早い**です。

TwitterやZenn、GitHub、DEV、Qiita、noteも参考にして、**実際のSNSに近づけ、テストもコード化**しています。

[【プログラミング入門】Ruby on Rails でウェブアプリを作ってみよう](https://youtube.com/playlist?list=PL7dhNz439lnRzd3hEZLrwCGe9gO6Y4oMG)で作成したアプリを拡張しました。

拡張前のアプリにはユーザーとレシピのCRUD機能のみしかなく、ローカル環境でのみ動くものでした。

拡張前のアプリの[デモ動画](https://youtu.be/auLih2TFwio?t=65)と[GitHubリポジトリ](https://github.com/Farstep/recipegram_demo)

## 各ページのスクリーンショット

ログイン前のトップページ | ログイン後のトップページ
:---|:---
![root](https://user-images.githubusercontent.com/76758720/138095767-5da9e267-bd8d-4e16-8ca2-9ede79882d07.png) | ![root_after_signed_in](https://user-images.githubusercontent.com/76758720/138095852-079399d5-73e2-4a50-9297-9ecdf9a910c5.png)
ログインをしていなくてもフィードとしてランダムなレシピが表示され、**無限スクロール**することができます。ユーザーもランダムに表示されます。 | フォローしている人と自身の投稿のフィードが表示されます。まだフォローしていないユーザーがランダムで表示され、表示されたユーザーのフォロワーの内、自身がフォローしているユーザーの数もわかるようになっています。
**フィードの無限スクロールの様子** | **新規登録ページ**
![infinite_scroll_compression](https://user-images.githubusercontent.com/76758720/138103684-72aab849-c24b-4620-8523-eb176acfad0e.gif) | ![generate_username](https://user-images.githubusercontent.com/76758720/138098031-34e70b9d-4247-4aeb-9d58-00b63cbd8ee6.gif)
**無限スクロール**することができます。 | 目のアイコンをクリックすることで入力中のパスワードを表示することができ、**AJAX**で既存のusernameと一致しないように自動生成することができます。
**ユーザーの詳細ページ** | **アカウント削除確認ページ**
![users_show](https://user-images.githubusercontent.com/76758720/138095925-05c8a704-60ed-4b68-8ee1-ad3a572769fc.png) | ![registrations_confirm_destroy](https://user-images.githubusercontent.com/76758720/138218820-3ff8941b-ddbb-4770-b6af-7449f1caf5d2.png)
ユーザーの**URLのパラメーターにはidではなくusernameカラムを使用**しています。ユーザーが投稿、コメント、いいねしたレシピは**無限スクロール**することができます。 | **アカウントを削除するのにパスワードの入力を求める**ようになっています。
**レシピの詳細ページ** | **レシピの詳細ページのモーダル**
![recipes_show](https://user-images.githubusercontent.com/76758720/138096052-ef679cb0-8c1c-40fc-95f7-9d51036a152c.png) | ![recipes_show_modal](https://user-images.githubusercontent.com/76758720/138096130-bb3e7b3b-e3c2-46f9-bb19-fe6358b7f8cb.png)
投稿者の他のレシピも表示されます。 | 画像をクリックするとモーダルで画像を画面中央に表示することができます。
**レシピの詳細ページのコメント一覧** | **レシピ投稿ページ**
![recipes_show_comments](https://user-images.githubusercontent.com/76758720/138097870-8b44eef5-3601-42aa-b555-ed4c9c43f578.png) | ![recipes_new](https://user-images.githubusercontent.com/76758720/138096242-d63f48be-80cd-4207-af1d-48d4411adab9.png)
コメントの表示件数を1件もしくは全件に切り替えることができます。 | アップロードする画像のプレビューが表示でき、文字数がカウントされ、テキストエリアはリサイズされます。
**レシピ編集ページ** | **タグのインクリメンタルサーチの様子**
![resize_textarea](https://user-images.githubusercontent.com/76758720/138098101-a4f68fba-fbf2-4691-838f-2bf25a4e7203.gif) | ![tag_incremental_search](https://user-images.githubusercontent.com/76758720/138098114-855c8159-5a48-46c9-b68e-464c71b4cd1f.gif)
アップロードする画像のプレビューが表示でき、文字数がカウントされ、テキストエリアはリサイズされます。 | **AJAXでタグをインクリメンタルサーチ**することができます。レシピに紐付けられるタグの数のバリデーションも設定しています。
**通知一覧ページ** | **タグの詳細ページ**
![notifications_index](https://user-images.githubusercontent.com/76758720/138219276-caa52016-f53f-421c-92fe-90e2e51f0a4d.png) | ![tags_show](https://user-images.githubusercontent.com/76758720/138096550-f540d180-9170-47c9-a607-97b8d6e04ed8.png)
投稿したレシピにいいねまたはコメントがついたとき、フォローされたときに通知が作成されます。コメントしたレシピに他のユーザーがコメントしたときにも通知が作成されます。 | タグ付けされているレシピが一覧で表示され、無限スクロールすることができます。**URLのパラメーターにはidではなくnameカラムを使用していて、日本語にも対応**しています。
**レシピ名の検索結果ページ** | **レシピ名の検索結果をいいねが多い順でソートしたときのページ**
![search_recipe_title](https://user-images.githubusercontent.com/76758720/138096361-46570a1b-854f-4ee1-8229-e053d6d9571d.png) | ![search_recipe_title_sorted_by_favorite_count](https://user-images.githubusercontent.com/76758720/138096470-66da07d5-c1bf-424d-82ba-957de5dc3b5f.png)
**一度に複数のテーブルのカラムを検索**できます。 | レシピ名と作り方の検索結果はいいねの多い順やコメントの多い順でソートすることができます。
**ニックネームの検索結果ページ** | **ニックネームの検索結果をフォロワーが多い順でソートしたときのページ**
![search_user_nickname](https://user-images.githubusercontent.com/76758720/138218887-f94197ca-29d0-4df4-bf44-f09262d7b890.png) | ![search_user_nickname_sorted_by_follower_count](https://user-images.githubusercontent.com/76758720/138218901-caeae842-c88b-4fb0-92ce-10549675169e.png)
ページが遷移してもキーワードがリセットされないようになっています。 | ニックネームとプロフィールの検索結果はフォロワーの多い順や投稿したレシピが多い順にソートすることができます。

## 拡張、工夫したこと

### 実際のSNSにある機能を追加

実際のSNSにある**通知**、**検索**、**無限スクロール**、**タグ**、コメント、いいね、フォロー機能を実装しています。

無限スクロール機能、いいね機能、フォロー機能はAJAXで動きます。

### 通知機能

投稿したレシピにいいねまたはコメントされたときとフォローされたときに通知が作成されます。

コメントしたレシピに他のユーザーがコメントしたときにも通知が作成されます。

拡張しやすいように**ポリモーフィック関連付け**を用いて実装しています。

Comments, Favorites, RelationshipsテーブルがnotifiableとしてNotificationsテーブルと関連付けられています。

Notificationsテーブルを作成するメソッドはNotificationモデルにクラスメソッドとして定義しています。

自身のレシピにコメントやいいねをした場合は、通知が作成されないようにもしてあります。

### 検索機能

Ransackを用いて実装しています。

ユーザーとレシピを検索することができます。

GitHubの検索機能を参考にし、GitHubの検索機能のように**一度に複数のテーブルのカラムを検索**できます。

半角または全角スペース区切りでAND検索することもできます。

いいねの多い順やフォロワーの多い順といった、**関連付けられているレコードの数で検索結果をソート**することもできます。

ページが遷移しても検索対象のカラムとキーワードがリセットされないようになっています。

### 無限スクロール機能

ユーザーとレシピが複数表示されるページでは無限スクロールすることができます。

**AJAX**で動きます。

読込中はアニメーションが表示されます。

### タグ機能

ActsAsTaggableOnとTagifyを用いて実装しています。

タグの入力時に**AJAXでインクリメンタルサーチ**ができるようになっています。

タグのnameカラムをURLのパラメーターに使用していて、そのためのバリデーションや日本語にも対応しています。

レシピに紐付けられるタグの数のバリデーションも設定しています。

### ユーザーのURLのパラメーターにusernameカラムを使用

実際のSNSのように、**ユーザーのURLのパラメーターにはidではなくusernameカラムを使用**するようにしています。

usernameは他のルーティングと一致しないように、使用できない単語のバリデーションを設定してあります。

ワンクリックで既存のusernameと一致しないように自動生成することもできます。AJAXで動きます。

### RSpecでテストをコード化

**RSpecでテストコード**が書いてあり、Model specが94件、Request specが197件、System specが58件、その他25件の**合計374件のexample**があります。

Model specではバリデーションと定義したメソッドをテストしています。具体的には、ユーザーのURLのパラメーターに使用しているusernameカラムが一意であり、登録できない単語を設定できているかや、通知を作成するメソッドで通知が送られるユーザーが正しいかなどについてです。

Request specではHTTPレスポンスステータスやボディ内容、レコード数の増減と更新、アクセス権限をテストしています。具体的には、投稿者のみがレコードの更新と削除を行うことができるようになっているかなどについてです。

System specでは正常に一連の操作をした場合のテストをしています。具体的には、妥当な情報を入力するとレコードの作成、更新、削除ができるかなどについてです。無限スクロールもテストしています。

他にはcarrierwaveのuploaderのテストもしています。具体的には、画像の保存先のフォルダを環境変数によって分けることができているかやデフォルトの画像が設定できているか、拡張子と容量の制限ができているかなどについてです。

### 導線を追加

実際のSNSのように導線を追加しています。

他ユーザーの詳細ページではTwitterのように、他ユーザーのフォロワーの内、自身がフォローしているユーザーが表示されます。

レシピの詳細ページでは投稿者の他のレシピも表示されます。

トップページではInstagramのようにフィードに加えて、まだフォローしていないユーザーが表示されます。

無限スクロールでフィードを全て読み込み終えてしまった場合はランダムな投稿が読み込まれるようにしています。

### UXの向上

入力中のパスワードを表示することができます。

入力中の文字数がカウントされます。

テキストエリアが自動でリサイズされます。

アップロードする画像のプレビューを見ることができます。

レシピが複数表示されているページでは、Instagramのように画像の上にマウスカーソルを重ねると、いいねとコメント数が表示されます。

アイコンだけのリンクや最後のほうが省略されている文字のリンクにはtitle属性を付与してリンク先がわかるようになっています。

バリデーションエラーが発生したカラムの入力欄は赤く囲われ、その下にエラーメッセージが表示されます。

### その他

deviseをカスタマイズして、**アカウントを削除するのにパスワードの入力を求める**ようにしています。

各フォームで文字が入力されていないときや空文字のときはサブミットボタンを押すことができなくなっています。

Cloudinaryの使用容量を減らすために、画像が更新されるときは更新前の画像をCloudinaryから削除した後に新しい画像がアップロードされます。

Cloudinaryによってブラウザごとに最適なフォーマットの画像が表示されます。

各ページでN+1問題に配慮しています。

全てのページがレスポンシブ対応しています。

簡単に環境構築ができるように**Dockerを使用**しています。

HerokuのDynoがスリープして初回アクセスの表示に時間がかからないようにGASで定期的にアクセスがされるようにしています。

Googleフォームでお問い合わせフォームを作成しています。

Googleアナリティクスを導入しています。

## ER図

![ER図](er_diagram.drawio.svg)

## 使用技術

### 開発環境

* Windows 10 Home
* Docker
* Docker Compose

### フロントエンド

* HTML
* SCSS
* JavaScript

#### 主要モジュール

* Bulma
* tagify

### バックエンド

* Ruby 2.7.3
* Ruby on Rails 6.1.3.1

#### 主要Gem

* Devise
* CarrierWave
* Ransack
* Kaminari
* ActsAsTaggableOn
* RSpec
* RuboCop
* Bullet

### データベース

* PostgreSQL 13.3

### インフラストラクチャ

* Puma
* Heroku
* Cloudinary
