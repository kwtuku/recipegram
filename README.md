# [Recipegram](https://recipegram-kwtuku.herokuapp.com/)

<p>
  <img alt="ruby version" src="https://img.shields.io/badge/Ruby-v2.7.3-green">
  <img alt="rails version" src="https://img.shields.io/badge/Rails-v6.1.3.1-brightgreen">
  <img alt="Lines of code" src="https://img.shields.io/tokei/lines/github/kwtuku/recipegram">
  <img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/m/kwtuku/recipegram">
  <img alt="GitHub deployments" src="https://img.shields.io/github/deployments/kwtuku/recipegram/recipegram-kwtuku">
</p>

# 概要

Instagramのクローンアプリです。TwitterやZenn、GitHub、DEV、Qiitaも参考にしています。

[【プログラミング入門】Ruby on Rails でウェブアプリを作ってみよう](https://youtube.com/playlist?list=PL7dhNz439lnRzd3hEZLrwCGe9gO6Y4oMG)で作成した、ローカル環境で動くユーザーとレシピに関してのCRUD機能があるアプリを拡張しました。

拡張前のアプリの[デモ](https://youtu.be/auLih2TFwio?t=65)と[GitHubリポジトリ](https://github.com/Farstep/recipegram_demo)

<br>

拡張後のアプリには、ユーザー登録、レシピ投稿、コメント投稿、いいね、フォロー、**検索**、**通知**機能があります。

検索機能はZennやGitHub、DEVのように**一度に複数のテーブルのカラムから検索、関連付け先のレコード数でソート**をすることなどができます。

通知機能は**ポリモーフィック関連付け**を用いて実装しています。

ユーザーのURLのパラメーターにはidではなく**一意なusernameというカラムを使用**しています。既存のURLと一致しないように、usernameには使用できない**予約語を設定**してあり、**AJAXで**既存のusernameと一致しないように**自動生成**することもできます。

<br>

JavaScriptによる機能もあります。

各機能の一覧ページでは**無限スクロール**することができます。読み込み時にはアニメーションが表示されます。

入力中のパスワードを表示させたり、文字数をカウントしたり、アップロードする画像のプレビューを見ることなどもできます。

上記の機能とその他の機能の詳細は後述の[各機能の詳細](#各機能の詳細)を御覧ください。

<br>

各ページでN+1問題に配慮しています。

全てのページがレスポンシブ対応しています。

<br>

**RSpecでテストコード**が書いてあり、Model specが84件、Request specが160件、System specが45件、その他25件の**合計314件のexample**があります。

テストコードの詳細は後述の[テストコードの詳細](#テストコードの詳細)を御覧ください。

<br>

開発環境には**Docker**を使用しています。

Herokuにデプロイしていますが、GASで定期的にアクセスをしているので、**起動は早い**です。

アプリのURLはこちらです。ゲストログインというボタンから**簡単にログイン**することができます。

https://recipegram-kwtuku.herokuapp.com/

各ページのスクリーンショットは後述の[各ページのスクリーンショット](#各ページのスクリーンショット)を御覧ください。

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

# ER図

![ER図](er_diagram.drawio.svg)

# 各機能の詳細

## ユーザー

* deviseを使用しています。

* 新規登録、ログイン、ログアウト、編集、削除ができます。

* **パスワードを入力しないとアカウントが削除できない**ようになっています。

* パスワードの入力フォームでは目のアイコンをクリックすることで**パスワードを表示**することができます。

  目のアイコンまたはパスワードフォーム外をクリックするとマスクされた表示に戻ります。

* **ワンクリックでログインができる**ゲストログイン機能があります。

* 自分自身とフォローしているユーザーの投稿を含むフィードを持っています。フィードはホーム画面で見ることができます。

* ホーム画面ではInstagramのように**まだフォローしていないユーザーが最大で5人まで表示**されます。

* Twitterのように他ユーザーの詳細ページで、**他ユーザーのフォロワーの内、自身がフォローしているユーザーが表示**されます。

* idではなく一意な**usernameというカラムをUserのURLに使用**しています。

  既存のURLと一致しないように、usernameには使用できない**予約語を設定**しています。

  新規登録ページでは円弧の矢印ボタンをクリックすると、**AJAXで既存のものと一致しないようなusernameが生成**されフォームに入力されます。

## レシピ

* 投稿、編集、削除ができます。

* carrierwaveにより画像をアップロードできます。

* 画像をアップロードする際に**プレビュー**を見ることができます。

* レシピの詳細ページでレシピ画像をクリックするとモーダルで画像が大きく表示されます。

* レシピの詳細ページでコメントを1件もしくは全件の表示に切り替えることができます。

* レシピの詳細ページで**投稿者の他のレシピが最大で3件まで表示**されます。

* レシピが複数表示されているページでは、Instagramのように画像の上にマウスカーソルを重ねるといいねとコメント数が表示されます。

## コメント

* 投稿、削除ができます。

## いいね

* レシピに対していいねができます。

* いいねを取り消すこともできます。

* **Ajax**を使用しています。

## フォロー

* ユーザーをフォローすることができます。

* フォローを解除することもできます。

* **Ajax**を使用しています。

* フォロー中の場合はマウスオーバーでフォローボタンの色とテキストが変化します。

## 検索

* ransackを使用しています。

* レシピ名、レシピ内容、ユーザー名、またはユーザープロフィール文からキーワード検索できます。

* GitHubやZennのように**一度にすべての検索対象から検索**をすることができます。

* いいね数やコメント数、投稿数、フォロワー数、フォローしている人の数といった**関連付けられているレコードの数で検索結果がソート**できます。

* 半角または全角スペースで区切ることでAND検索ができます。

* 検索結果を表示するために**ページが遷移しても、検索対象とキーワードがリセットされません**。

* kaminariによりページを分割して検索結果を表示しています。

## 通知

* **ポリモーフィック関連付け**を使用しています。

* フォローされたとき、投稿したレシピがいいねされたとき、投稿したレシピにコメントされたとき、またはコメントしたレシピに他のユーザーがコメントしたときに通知が作成されます。

* 通知の既読管理ができます。

* kaminariによりページを分割して通知内容の一覧を表示しています。

* 未読の通知がある場合はヘッダーのベルアイコンの右上にバッジが表示されます。

## 無限スクロール

* ユーザー一覧、レシピ一覧、フィード、ユーザーが投稿、コメント、いいねしたレシピ一覧、フォロー中一覧、フォロワー一覧ページで**Ajaxにより無限スクロール**ができます。

* 読込中はアニメーションが表示されます。

## js

* ログインしていないときにフォローボタンやいいねボタンをクリックすると、ログインと新規登録するためのリンクがあるモーダルが表示されます。

* 各フォームで空欄、空文字の場合はボタンが動作しません。

* 各フォームで入力した文字数がカウントされます。

* 各テキストエリアは改行でリサイズされます。

* フラッシュメッセージはXボタンをクリックすると非表示になります。

* ミートボールメニューをクリックするとドロップダウンリストが表示されます。

  ミートボールメニューまたはドロップダウンリスト外をクリックするとドロップダウンリストが非表示になります。

## マークアップ

* 文章を1行から最大で15行までに省略し、末尾に3点リーダーをつけて表示することができます。

* 要素の横幅に収まりきらない長い文字列は改行され、レイアウトが崩れないようにしています。

## その他

* プロフィール画像もしくはレシピ画像が更新されるときは、更新前の画像をCloudinaryから削除後に新しい画像がアップロードされます。

* ブラウザによって最適なフォーマットの画像が表示されます。

* seeds.rbでユーザーやレシピ、コメント、いいね、フォロー関係、通知のデモデータを作成できます。

* Googleフォームでお問い合わせフォームを作成しています。

* Googleアナリティクスを使用しています。

# テストコードの詳細

**RSpecでテストコード**が書いてあり、Model specが84件、Request specが160件、System specが45件、その他25件の**合計314件のexample**があります。

Model specではバリデーションと定義したメソッドをテストしています。具体的には、UserのURLのパラメーターに使用しているusernameというカラムが一意であり、登録できない単語を設定できているかなどや、通知を作成するメソッドで通知が送られるユーザーが正しいかなどについてです。

Request specではHTTPレスポンスステータスやボディ、レコード数の増減と更新、権限をテストしています。具体的には、投稿者のみがレコードの更新と削除を行うことができるようになっているかなどについてです。

System specでは一連の操作の正常系のテストをしています。具体的には、妥当な情報を入力するとレコードの作成、更新、削除ができるかなどについてです。

他にはcarrierwaveのuploaderのテストもしています。具体的には、画像の保存先のフォルダを環境変数によって分けることができているかやデフォルトの画像が設定できているか、拡張子と容量の制限ができているかなどについてです。

# 各ページのスクリーンショット

|トップページ（ログイン前）|トップページ（ログイン後）|
|:-----------|:------------|
|![root](https://user-images.githubusercontent.com/76758720/130969347-7e4fe48d-7d07-4187-9470-e72fa3a5d3a9.png)|![root_after_signed_in](https://user-images.githubusercontent.com/76758720/132127767-5d43e44a-c370-4dd2-a08a-d0206ac85ad2.png)|

|ユーザーの詳細ページ|ユーザー一覧ページ|
|:-----------|:------------|
|![users_show](https://user-images.githubusercontent.com/76758720/132127790-48b6e6ef-7af0-4e72-b6f3-1b9ba663fdae.png)|![users_index](https://user-images.githubusercontent.com/76758720/132127802-97b043a5-2bb3-4083-b833-5f8ca5edc85d.png)|

|ユーザーのフォロワー一覧ページ|ユーザーのフォロー中一覧ページ|
|:-----------|:------------|
|![users_followers](https://user-images.githubusercontent.com/76758720/132127850-c3cd6b83-5129-4080-829b-b5def85e78f7.png)|![users_followings](https://user-images.githubusercontent.com/76758720/132127857-ecdc6e7a-b7aa-4c0a-b17c-5d4fa335e33f.png)|

|プロフィール編集ページ|アカウント編集ページ|
|:-----------|:------------|
|![users_edit](https://user-images.githubusercontent.com/76758720/132127807-a4378b4f-1fc3-4e1d-8890-c717deda50d6.png)|![registrations_edit](https://user-images.githubusercontent.com/76758720/132127818-71980b89-db0f-4edb-9819-e09c9ba2df8f.png)|

|アカウント削除確認ページ|通知一覧ページ|
|:-----------|:------------|
|![registrations_confirm_destroy](https://user-images.githubusercontent.com/76758720/132127828-9aa63f18-e2c7-452a-95a6-8b8af297a4b0.png)|![notifications_index](https://user-images.githubusercontent.com/76758720/130972634-ff86041e-1a77-4ef2-a244-d7d5fd650c22.png)|

|レシピの詳細ページ|レシピの詳細ページのモーダル|
|:-----------|:------------|
|![recipes_show](https://user-images.githubusercontent.com/76758720/130990301-33bea0b1-73c0-4cd0-b35c-58298fabdce9.png)|![recipes_show_modal](https://user-images.githubusercontent.com/76758720/132127916-bcede7e7-9df1-4a5b-9571-26fa68750bba.png)|

|レシピの詳細ページのコメント一覧|レシピ一覧ページ|
|:-----------|:------------|
|![recipes_show_comments](https://user-images.githubusercontent.com/76758720/132128141-264d288e-188a-47f1-a386-214d73e83da0.png)|![recipes_index](https://user-images.githubusercontent.com/76758720/132127929-0ecd08ae-eecd-452e-a683-4643bee95c82.png)|

|レシピ投稿ページ|レシピ編集ページ|
|:-----------|:------------|
|![recipes_new](https://user-images.githubusercontent.com/76758720/132127935-4abb9eb7-f6cd-4169-a0d4-052e469f395d.png)|![recipes_edit](https://user-images.githubusercontent.com/76758720/132127942-b0e96548-6f30-4a3b-a07a-81fb5a151847.png)|

|レシピ名の検索結果ページ|レシピ名の検索結果をいいねが多い順でソートしたときのページ|
|:-----------|:------------|
|![search_recipe_title](https://user-images.githubusercontent.com/76758720/130969389-6a68b760-68fe-4b87-ad5f-62c0d22a7529.png)|![search_recipe_title_sorted_by_favorite_count](https://user-images.githubusercontent.com/76758720/132127885-de722123-39b2-416d-b876-b8a78154fa2f.png)|

|ニックネームの検索結果ページ|ニックネームの検索結果をフォロワーが多い順でソートしたときのページ|
|:-----------|:------------|
|![search_user_nickname](https://user-images.githubusercontent.com/76758720/130969395-79d3e4ef-6513-4331-98f9-9d529125e52e.png)|![search_user_nickname_sorted_by_follower_count](https://user-images.githubusercontent.com/76758720/132127890-f7e45bcf-650b-4b57-a242-b1a3b0728e31.png)|
