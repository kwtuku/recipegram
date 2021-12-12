# [Recipegram](https://recipegram-kwtuku.herokuapp.com/)

<p>
  <img alt="ruby version" src="https://img.shields.io/badge/Ruby-v2.7.3-701516">
  <img alt="rails version" src="https://img.shields.io/badge/Rails-v6.1.3.1-cc0000">
  <img alt="Lines of code" src="https://img.shields.io/tokei/lines/github/kwtuku/recipegram">
  <img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/m/kwtuku/recipegram">
  <img alt="GitHub deployments" src="https://img.shields.io/github/deployments/kwtuku/recipegram/recipegram-kwtuku">
</p>

## 概要

Instagramのクローンアプリで、画像付きのレシピを投稿するSNSです。<br>
**通知**、**検索**、**無限スクロール**、**タグ**機能などがあり、RSpecでテストコードを書いていて、400件近くのexampleがあります。

https://recipegram-kwtuku.herokuapp.com/<br>
アプリのURLはこちらです。ゲストログインというボタンから簡単にログインできます。<br>
HerokuにデプロイしていますがGASで定期的にアクセスをしているので表示は早いです。

[【プログラミング入門】Ruby on Railsでウェブアプリを作ってみよう - YouTube](https://youtube.com/playlist?list=PL7dhNz439lnRzd3hEZLrwCGe9gO6Y4oMG)で作成したアプリを拡張しました。<br>
拡張前のアプリはユーザーとレシピのCRUD機能があり、ローカル環境で動くものでした。<br>

## 各ページのスクリーンショットと機能の概要

ログイン前のトップページ | ログイン後のトップページ
:--- | :---
![root](https://user-images.githubusercontent.com/76758720/138095767-5da9e267-bd8d-4e16-8ca2-9ede79882d07.png) | ![root_after_signed_in](https://user-images.githubusercontent.com/76758720/138095852-079399d5-73e2-4a50-9297-9ecdf9a910c5.png)
ログインをしていなくてもランダムなレシピがフィードとして表示され、**無限スクロール**できます。ユーザーもランダムに表示されます。表示されるフィードとユーザーは**キャッシュ**されます。 | フォローしている人と自身の投稿のフィードとまだフォローしていないユーザーがランダムで表示されます。表示されたユーザーのフォロワーの内、自身がフォローしているユーザーの数もわかるようになっています。表示されるユーザーは**キャッシュ**されます。

フィードの無限スクロールの様子 | 新規登録ページ
:--- | :---
![infinite_scroll_compression](https://user-images.githubusercontent.com/76758720/138103684-72aab849-c24b-4620-8523-eb176acfad0e.gif) | ![generate_username](https://user-images.githubusercontent.com/76758720/138098031-34e70b9d-4247-4aeb-9d58-00b63cbd8ee6.gif)
**無限スクロール**できます。 | 目のアイコンをクリックすることで入力中のパスワードを表示、**AJAX**で既存のusernameと一致しないように自動生成することができます。

ユーザーの詳細ページ | アカウント削除確認ページ
:--- | :---
![users_show](https://user-images.githubusercontent.com/76758720/138095925-05c8a704-60ed-4b68-8ee1-ad3a572769fc.png) | ![registrations_confirm_destroy](https://user-images.githubusercontent.com/76758720/138218820-3ff8941b-ddbb-4770-b6af-7449f1caf5d2.png)
ユーザーの**URLのパラメーターにはidではなくusernameカラムを使用**しています。ユーザーが投稿、コメント、いいねしたレシピは**無限スクロール**できます。 | **アカウントを削除時はパスワードの入力を求める**ようになっています。

レシピの詳細ページ | レシピの詳細ページのモーダル
:--- | :---
![recipes_show](https://user-images.githubusercontent.com/76758720/138096052-ef679cb0-8c1c-40fc-95f7-9d51036a152c.png) | ![recipes_show_modal](https://user-images.githubusercontent.com/76758720/138096130-bb3e7b3b-e3c2-46f9-bb19-fe6358b7f8cb.png)
投稿者の他のレシピも表示されます。 | 画像をクリックするとモーダルで画像を画面中央に表示することができます。

レシピの詳細ページのコメント一覧 | レシピ投稿ページ
:--- | :---
![recipes_show_comments](https://user-images.githubusercontent.com/76758720/138097870-8b44eef5-3601-42aa-b555-ed4c9c43f578.png) | ![recipes_new](https://user-images.githubusercontent.com/76758720/138096242-d63f48be-80cd-4207-af1d-48d4411adab9.png)
コメントの表示件数を1件もしくは全件に切り替えることができます。 | アップロードする画像のプレビューが表示でき、文字数がカウントされ、テキストエリアはリサイズされます。

レシピ編集ページ | タグ入力時のサジェスト機能
:--- | :---
![resize_textarea](https://user-images.githubusercontent.com/76758720/138098101-a4f68fba-fbf2-4691-838f-2bf25a4e7203.gif) | ![tag_incremental_search](https://user-images.githubusercontent.com/76758720/138098114-855c8159-5a48-46c9-b68e-464c71b4cd1f.gif)
アップロードする画像のプレビューが表示でき、文字数がカウントされ、テキストエリアはリサイズされます。 | タグを入力すると**サジェスト**されます。レシピに紐付けられるタグの数のバリデーションも設定しています。

通知一覧ページ | タグの詳細ページ
:--- | :---
![notifications_index](https://user-images.githubusercontent.com/76758720/138219276-caa52016-f53f-421c-92fe-90e2e51f0a4d.png) | ![tags_show](https://user-images.githubusercontent.com/76758720/138096550-f540d180-9170-47c9-a607-97b8d6e04ed8.png)
投稿したレシピにいいねまたはコメントがついたとき、フォローされたときに通知が作成されます。コメントしたレシピに他のユーザーがコメントしたときにも通知が作成されます。 | タグ付けされているレシピが一覧で表示され、無限スクロールできます。**URLのパラメーターにはidではなくnameカラムを使用**していて、**日本語にも対応**しています。

レシピ名の検索結果ページ | レシピ名の検索結果をいいねが多い順でソートしたときのページ
:--- | :---
![search_recipe_title](https://user-images.githubusercontent.com/76758720/138096361-46570a1b-854f-4ee1-8229-e053d6d9571d.png) | ![search_recipe_title_sorted_by_favorite_count](https://user-images.githubusercontent.com/76758720/138096470-66da07d5-c1bf-424d-82ba-957de5dc3b5f.png)
**一度に複数のテーブルのカラムを検索**できます。 | レシピ名と作り方の検索結果はいいねの多い順やコメントの多い順でソートできます。

ニックネームの検索結果ページ | ニックネームの検索結果をフォロワーが多い順でソートしたときのページ
:--- | :---
![search_user_nickname](https://user-images.githubusercontent.com/76758720/138218887-f94197ca-29d0-4df4-bf44-f09262d7b890.png) | ![search_user_nickname_sorted_by_follower_count](https://user-images.githubusercontent.com/76758720/138218901-caeae842-c88b-4fb0-92ce-10549675169e.png)
ページが遷移しても検索ワードがリセットされないようになっています。 | ニックネームとプロフィールの検索結果はフォロワーの多い順や投稿したレシピが多い順にソートできます。

## 拡張、工夫したこと

### 実際のSNSにある機能を追加

実際のSNSにある**通知**、**検索**、**無限スクロール**、**タグ**、コメント、いいね、フォロー機能を実装しています。<br>
無限スクロール、いいね、フォロー機能はAJAXで動きます。

### 通知機能

**ポリモーフィック関連付け**を使用しています。<br>
投稿したレシピにいいね、コメントされたとき、コメントしたレシピに他のユーザーがコメントしたとき、フォローされたときに通知が作成されます。<br>
Notificationsテーブルを作成するメソッドはNotificationモデルにクラスメソッドとして定義しています。<br>
自身のレシピにコメントやいいねをした場合は、通知が作成されないようにもしてあります。

### 検索機能

Ransackを使用しています。<br>
ユーザーとレシピとタグを検索できます。<br>
GitHubの検索機能を参考にし、GitHubの検索機能のように**一度に複数のテーブルのカラムを検索**できます。<br>
半角または全角スペース区切りでAND検索することもできます。<br>
いいねの多い順やフォロワーの多い順といった、**関連付けられているレコードの数で検索結果をソート**することもできます。<br>
ページが遷移しても検索対象のカラムとキーワードがリセットされないようになっています。

### 無限スクロール機能

ユーザーとレシピが複数表示されるページでは無限スクロールすることができます。<br>
**AJAX**で動き、読込中はアニメーションが表示されます。

### タグ機能

ActsAsTaggableOnとTagifyを使用しています。<br>
タグの入力時にサジェストされます。<br>
タグのnameカラムをURLのパラメーターに使用していて、そのためのバリデーションを設定し、日本語にも対応しています。<br>
レシピに紐付けられるタグの数のバリデーションも設定しています。

### ユーザーのURLのパラメーターにusernameカラムを使用

実際のSNSのように、**ユーザーのURLのパラメーターにはidではなくusernameカラムを使用**するようにしています。<br>
usernameは他のルーティングと一致しないように、使用できない単語のバリデーションを設定してあります。<br>
ワンクリックで既存のusernameと一致しないように自動生成することもできます。AJAXで動きます。<br>

### RSpecでテストをコード化

**RSpecでテストコード**が書いてあり、Model specが92件、Request specが197件、System specが58件、その他25件の**合計372件のexample**があります。<br>
Model specではバリデーションと定義したメソッドをテストしています。
Request specではHTTPレスポンスステータスやボディ内容、レコード数の増減と更新、アクセス権限をテストしています。
System specでは正常に一連の操作をした場合のテストをしています。
他にはCarrierWaveのUploaderもテストしています。

### 実際のSNSのように導線を追加

レシピの詳細ページでは投稿者の他のレシピも表示されます。<br>
トップページではInstagramのようにフィードの他に、まだフォローしていないユーザーが表示されます。<br>
無限スクロールでフィードを全て読み込み終えてしまった場合はランダムな投稿が読み込まれるようにしています。

### UXの向上

入力中のパスワードを表示することができます。<br>
入力中の文字数がカウントされます。<br>
テキストエリアが自動でリサイズされます。<br>
アップロードする画像のプレビューを見ることができます。<br>
レシピが複数表示されているページでは、Instagramのように画像の上にマウスカーソルを重ねると、いいねとコメント数が表示されます。<br>
アイコンだけのリンクや末尾が省略されている文字のリンクはtitle属性を付与してリンク先がわかるようになっています。<br>
バリデーションエラーが発生したカラムの入力欄は赤く囲われ、その下にエラーメッセージが表示されます。

### その他

他ユーザーの詳細ページではTwitterのように、他ユーザーのフォロワーの内、自身がフォローしているユーザーが表示されます。<br>
Deviseをカスタマイズして、**アカウントを削除するのにパスワードの入力を求める**ようにしています。<br>
各フォームで文字が入力されていないときや空文字だけのときはサブミットボタンを押すことができないようにしています。<br>
Cloudinaryの使用容量を減らすために、画像が更新されるときは更新前の画像をCloudinaryから削除した後に新しい画像がアップロードされるようにしています。<br>
Cloudinaryによってブラウザごとに最適なフォーマットの画像が表示されます。<br>
各ページでN+1問題に配慮しています。<br>
全てのページがレスポンシブ対応しています。<br>
開発環境に**Dockerを使用**しています。<br>
HerokuのDynoがスリープして初回アクセスの表示に時間がかからないようにGASで定期的にアクセスがされるようにしています。<br>
Googleフォームでお問い合わせフォームを作成しています。<br>
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
* 主要モジュール
  * Bulma
  * Tagify

### バックエンド

* Ruby 2.7.3
* Ruby on Rails 6.1.3.1
* 主要Gem
  * ActsAsTaggableOn
  * Bullet
  * CarrierWave
  * Devise
  * Kaminari
  * Ransack
  * RSpec
  * RuboCop

### DB、インフラなど

* Cloudinary
* Heroku
* PostgreSQL 13.3
* Puma
* Redis 6.2.6
