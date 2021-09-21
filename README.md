# [Recipegram](https://recipegram-kwtuku.herokuapp.com/)

<p>
  <img alt="ruby version" src="https://img.shields.io/badge/Ruby-v2.7.3-green">
  <img alt="rails version" src="https://img.shields.io/badge/Rails-v6.1.3.1-brightgreen">
  <img alt="Lines of code" src="https://img.shields.io/tokei/lines/github/kwtuku/recipegram">
  <img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/m/kwtuku/recipegram">
  <img alt="GitHub deployments" src="https://img.shields.io/github/deployments/kwtuku/recipegram/recipegram-kwtuku">
</p>

# 概要

Instagramのクローンアプリで、画像付きのレシピを投稿するSNSです。

アプリのURLはこちらです。ゲストログインというボタンから**ワンクリックでログイン**することができます。Herokuにデプロイしていますが、GASで定期的にアクセスをしているので、**表示は早い**です。

https://recipegram-kwtuku.herokuapp.com/

TwitterやZenn、GitHub、DEV、Qiitaも参考にし、**実際のSNSに近づけ、テストもコード化**しました。

[【プログラミング入門】Ruby on Rails でウェブアプリを作ってみよう](https://youtube.com/playlist?list=PL7dhNz439lnRzd3hEZLrwCGe9gO6Y4oMG)で作成したアプリを拡張しました。

拡張前のアプリにはユーザーとレシピのCRUD機能のみしかなく、ローカル環境でのみ動くものでした。

拡張前のアプリの[デモ動画](https://youtu.be/auLih2TFwio?t=65)と[GitHubリポジトリ](https://github.com/Farstep/recipegram_demo)

# 拡張、工夫したこと

## 実際のSNSにある機能を追加

実際のSNSにあるような機能を追加しました。

**通知**機能、**検索**機能、**無限スクロール**機能、コメント機能、いいね機能、フォロー機能を追加しました。

無限スクロール機能、いいね機能、フォロー機能はAJAXで動きます。

## 通知機能

投稿したレシピにいいねまたはコメントされたときとフォローされたときに通知が作成されます。

コメントしたレシピに他のユーザーがコメントしたときにも通知が作成されます。

拡張しやすいように**ポリモーフィック関連付け**を用いて実装しました。

Comments, Favorites, RelationshipsテーブルがnotifiableとしてNotificationsテーブルと関連付けられています。

Notificationsテーブルを作成するメソッドはNotificationモデルにクラスメソッドとして定義しました。

自身のレシピにコメントやいいねをした場合は、通知が作成されないようにもしてあります。

## 検索機能

ユーザーとレシピを検索することができます。

Ransackを用いて実装しました。

GitHubの検索機能を参考にし、GitHubの検索機能のように**一度に複数テーブルのカラムを検索**できます。

半角または全角スペース区切りでAND検索することもできます。

いいねの多い順やフォロワーの多い順といった、**関連付けられているレコードの数で検索結果をソート**することもできます。

ページが遷移しても検索対象のカラムとキーワードがリセットされないようになっています。

## 無限スクロール機能

ユーザーとレシピが複数表示されるページでは無限スクロールすることができます。

AJAXで動きます。

読込中はアニメーションが表示されます。

## ユーザーのURLのパラメーターにはidではなくusernameカラムを使用

実際のSNSのように、**ユーザーのURLのパラメーターにはidではなくusernameカラムを使用**するようにしました。

usernameは他のルーティングと一致してしまわないように、使用できない単語のバリデーションを定義してあります。

ワンクリックで既存のusernameと一致しないように自動生成することもできます。AJAXで動きます。

## RSpecでテストをコード化

**RSpecでテストコード**が書いてあり、Model specが84件、Request specが160件、System specが45件、その他25件の**合計314件のexample**があります。

Model specではバリデーションと定義したメソッドをテストしています。具体的には、ユーザーのURLのパラメーターに使用しているusernameカラムが一意であり、登録できない単語を設定できているかや、通知を作成するメソッドで通知が送られるユーザーが正しいかなどについてです。

Request specではHTTPレスポンスステータスやボディ内容、レコード数の増減と更新、アクセス権限をテストしています。具体的には、投稿者のみがレコードの更新と削除を行うことができるようになっているかなどについてです。

System specでは正常に一連の操作をした場合のテストをしています。具体的には、妥当な情報を入力するとレコードの作成、更新、削除ができるかなどについてです。

他にはcarrierwaveのuploaderのテストもしています。具体的には、画像の保存先のフォルダを環境変数によって分けることができているかやデフォルトの画像が設定できているか、拡張子と容量の制限ができているかなどについてです。

## 導線を追加

実際のSNSのように導線を追加しました。

他ユーザーの詳細ページではTwitterのように、他ユーザーのフォロワーの内、自身がフォローしているユーザーが表示されます。

レシピの詳細ページでは投稿者の他のレシピも表示されます。

トップページではInstagramのようにフィードに加えて、まだフォローしていないユーザーが表示されます。

無限スクロールでフィードを全て読み込み終えてしまった場合はランダムな投稿が読み込まれるようにしました。

## UXの向上

入力中のパスワードを表示することができます。

入力中の文字数がカウントされます。

テキストエリアが自動でリサイズされます。

アップロードする画像のプレビューを見ることができます。

レシピが複数表示されているページでは、Instagramのように画像の上にマウスカーソルを重ねると、いいねとコメント数が表示されます。

アイコンだけのリンクや最後のほうが省略されている文字のリンクにはtitle属性を付与してリンク先がわかるようになっています。

バリデーションエラーが発生したカラムの入力欄は赤く囲われ、その下にエラーメッセージが表示されます。

## その他

deviseをカスタマイズして、**アカウントを削除するのにパスワードの入力を求める**ようにしています。

各フォームで文字が入力されていないときや空文字のときはサブミットボタンを押すことができなくなっています。

Cloudinaryの使用容量を減らすために、画像が更新されるときは更新前の画像をCloudinaryから削除した後に新しい画像がアップロードされます。

Cloudinaryによってブラウザごとに最適なフォーマットの画像が表示されます。

各ページでN+1問題に配慮しています。

全てのページがレスポンシブ対応しています。

簡単に環境構築できるように**Dockerを使用**しています。

HerokuのDynoがスリープして初回アクセスの表示に時間がかからないようにGASで定期的にアクセスがされるようにしています。

Googleフォームでお問い合わせフォームを作成しています。

Googleアナリティクスを導入しています。

# 各ページのスクリーンショット

|ログイン前のトップページ|ログイン後のトップページ|
|:-----------|:------------|
|![root](https://user-images.githubusercontent.com/76758720/134021479-374e6329-a7b7-4f1e-9472-16fd21c259f1.png)|![root_after_signed_in](https://user-images.githubusercontent.com/76758720/132127767-5d43e44a-c370-4dd2-a08a-d0206ac85ad2.png)|
|ログインをしていなくてもフィードとしてランダムなレシピが表示されます。ユーザーもランダムに表示されます。|まだフォローしていないユーザーがランダムで表示されます。表示されたユーザーのフォロワーの内、自身がフォローしているユーザーの数もわかるようになっています。|

|ユーザーの詳細ページ|ユーザー一覧ページ|
|:-----------|:------------|
|![users_show](https://user-images.githubusercontent.com/76758720/132127790-48b6e6ef-7af0-4e72-b6f3-1b9ba663fdae.png)|![users_index](https://user-images.githubusercontent.com/76758720/132127802-97b043a5-2bb3-4083-b833-5f8ca5edc85d.png)|
|ユーザーのURLのパラメーターにはidではなくusernameカラムを使用しています。ユーザーが投稿、コメント、いいねしたレシピは無限スクロールできます。|無限スクロールできます。|

|ユーザーのフォロワー一覧ページ|ユーザーのフォロー中一覧ページ|
|:-----------|:------------|
|![users_followers](https://user-images.githubusercontent.com/76758720/132127850-c3cd6b83-5129-4080-829b-b5def85e78f7.png)|![users_followings](https://user-images.githubusercontent.com/76758720/132127857-ecdc6e7a-b7aa-4c0a-b17c-5d4fa335e33f.png)|
|無限スクロールできます。|無限スクロールできます。|

|プロフィール編集ページ|アカウント編集ページ|
|:-----------|:------------|
|![users_edit](https://user-images.githubusercontent.com/76758720/132127807-a4378b4f-1fc3-4e1d-8890-c717deda50d6.png)|![registrations_edit](https://user-images.githubusercontent.com/76758720/132127818-71980b89-db0f-4edb-9819-e09c9ba2df8f.png)|
|アップロードする画像のプレビューが表示でき、文字数がカウントされ、テキストエリアはリサイズされます。|目のアイコンをクリックすることで入力中のパスワードを表示することができます。|

|アカウント削除確認ページ|通知一覧ページ|
|:-----------|:------------|
|![registrations_confirm_destroy](https://user-images.githubusercontent.com/76758720/132127828-9aa63f18-e2c7-452a-95a6-8b8af297a4b0.png)|![notifications_index](https://user-images.githubusercontent.com/76758720/130972634-ff86041e-1a77-4ef2-a244-d7d5fd650c22.png)|
|アカウント削除するのにパスワードを求めるようになっています。|投稿したレシピにいいねまたはコメントがついときとフォローされたときに通知が作成されます。コメントしたレシピに他のユーザーがコメントしたときにも通知が作成されます。|

|レシピの詳細ページ|レシピの詳細ページのモーダル|
|:-----------|:------------|
|![recipes_show](https://user-images.githubusercontent.com/76758720/130990301-33bea0b1-73c0-4cd0-b35c-58298fabdce9.png)|![recipes_show_modal](https://user-images.githubusercontent.com/76758720/132127916-bcede7e7-9df1-4a5b-9571-26fa68750bba.png)|
|投稿者の他のレシピも表示されます。|画像をクリックするとモーダルで画像だけに注目することができます。|

|レシピの詳細ページのコメント一覧|レシピ一覧ページ|
|:-----------|:------------|
|![recipes_show_comments](https://user-images.githubusercontent.com/76758720/132128141-264d288e-188a-47f1-a386-214d73e83da0.png)|![recipes_index](https://user-images.githubusercontent.com/76758720/132127929-0ecd08ae-eecd-452e-a683-4643bee95c82.png)|
|コメントは1件だけ画面に見えるようになっています。|無限スクロールできます。|

|レシピ投稿ページ|レシピ編集ページ|
|:-----------|:------------|
|![recipes_new](https://user-images.githubusercontent.com/76758720/132127935-4abb9eb7-f6cd-4169-a0d4-052e469f395d.png)|![recipes_edit](https://user-images.githubusercontent.com/76758720/132127942-b0e96548-6f30-4a3b-a07a-81fb5a151847.png)|
|アップロードする画像のプレビューが表示でき、文字数がカウントされ、テキストエリアはリサイズされます。|アップロードする画像のプレビューが表示でき、文字数がカウントされ、テキストエリアはリサイズされます。|

|レシピ名の検索結果ページ|レシピ名の検索結果をいいねが多い順でソートしたときのページ|
|:-----------|:------------|
|![search_recipe_title](https://user-images.githubusercontent.com/76758720/130969389-6a68b760-68fe-4b87-ad5f-62c0d22a7529.png)|![search_recipe_title_sorted_by_favorite_count](https://user-images.githubusercontent.com/76758720/132127885-de722123-39b2-416d-b876-b8a78154fa2f.png)|
|一度に複数テーブルのカラムを検索できます。一つの検索結果だけビューにが表示され、残りは検索結果の数がわかります。|レシピ名と作り方の検索結果はいいねの多い順やコメントの多い順でソートすることができます。|

|ニックネームの検索結果ページ|ニックネームの検索結果をフォロワーが多い順でソートしたときのページ|
|:-----------|:------------|
|![search_user_nickname](https://user-images.githubusercontent.com/76758720/130969395-79d3e4ef-6513-4331-98f9-9d529125e52e.png)|![search_user_nickname_sorted_by_follower_count](https://user-images.githubusercontent.com/76758720/132127890-f7e45bcf-650b-4b57-a242-b1a3b0728e31.png)|
|ページが遷移してもキーワードがリセットされないようになっています。|ニックネームとプロフィールの検索結果はフォロワーの多い順や投稿したレシピが多い順にソートすることができます。|

# ER図

![ER図](er_diagram.drawio.svg)

# 使用技術

## 開発環境

* Windows 10 Home

* Docker

* Docker Compose

## フロントエンド

* HTML

* SCSS

* Bulma

* JavaScript

* jQuery($.ajaxメソッドでのみ使用)

## バックエンド

* Ruby 2.7.3

* Ruby on Rails 6.1.3.1

## テスト

* RSpec 5.0.1

* Factory Bot 6.2.0

* Capybara 3.35.3

## データベース

* PostgreSQL 13.3

## インフラストラクチャ

* Puma 5.3.2

* Heroku 7.52.0

* Cloudinary
