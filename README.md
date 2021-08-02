# Recipegram

Instagramのクローンアプリです。

Instagramの他に、TwitterやZenn、GitHub、DEV、Qiitaを参考にしている箇所もあります。

<br>

ユーザー登録、レシピ投稿、コメント投稿、いいね、フォロー、検索、通知機能があります。

検索機能はZennやGitHub、DEVのように**一度に複数のテーブルのカラム内容から検索、関連付け先のレコード数でソート**をすることができます。

通知機能はポリモーフィック関連付けを用いて実装しています。

各ページでN+1問題に配慮しています。

<br>

各機能の一覧ページでは**無限スクロール**することができます。

全てのページがレスポンシブ対応しています。

<br>

各機能の**E2Eテストのコード**もあります。

<br>

各機能とテストコードの詳細は後述の[各機能の詳細](#各機能の詳細)と[テストコードの詳細](#テストコードの詳細)を御覧ください。

<br>

アプリのURLはこちらになります。ゲストログインというボタンから**簡単にログイン**することが可能です。

GASで定期的にアクセスをしているので起動も早いです。

https://recipegram-kwtuku.herokuapp.com/

<br>
<br>

# 使用技術

## 開発環境

* Windows 10 Home

* Docker

* Docker Compose

<br>

## フロントエンド

* HTML

* SCSS

* Bulma

* JavaScript

* jQuery($.ajaxメソッドでのみ使用)

<br>

## バックエンド

* Ruby 2.7.3

* Ruby on Rails 6.1.3.1

<br>

## テスト

* RSpec 5.0.1

* Factory Bot 6.2.0

* Capybara 3.35.3

<br>

## データベース

* PostgreSQL 13.3

<br>

## インフラストラクチャ

* Puma 5.3.2

* Heroku 7.52.0

* Cloudinary

<br>
<br>

# ER図

![ER図](er_diagram.drawio.svg)

<br>
<br>

# 各機能の詳細

## ユーザー

* deviseを使用しています。

* 新規登録、ログイン、ログアウト、編集、削除ができます。

* パスワードの入力フォームで目のアイコンをクリックすることで表示することができます。

  目のアイコンまたはパスワードフォーム外をクリック、あるいは画面をスクロールするとマスクされた表示に戻ります。


* ワンクリックでログインができるゲストログイン機能があります。

* 自分自身とフォローしているユーザーの投稿を含むフィードを持っています。フィードはホーム画面で見ることができます。

* ホーム画面ではInstagramのようにまだフォローしていないユーザーが最大で5人まで表示されます。

* ユーザー一覧、フィード、投稿したレシピ一覧、コメントしたレシピ一覧、いいねしたレシピ一覧、フォロー中一覧、フォロワー一覧ページでAjaxにより無限スクロールができます。

  読込中はアニメーションが表示されます。

* Twitterのように他ユーザーの詳細ページで、他ユーザーのフォロワーの内、自身がフォローしているユーザーが表示されます。

<br>

## レシピ

* 投稿、編集、削除ができます。

* carrierwaveにより画像をアップロードできます。

* 画像をアップロードする際にプレビューを見ることができます。

* レシピ一覧ページでAjaxにより無限スクロールができます。

* レシピの詳細ページでレシピ画像をクリックするとモーダルで画像が大きく表示されます。

* レシピの詳細ページでコメントを1件もしくは全件の表示に切り替えることができます。

* レシピの詳細ページで投稿者の他のレシピが最大で6件まで表示されます。

* レシピが複数表示されているページでは、Instagramのように画像の上にマウスカーソルを重ねるといいねとコメント数が表示されます。

<br>

## コメント

* 投稿、削除ができます。

<br>

## いいね

* レシピに対していいねができます。

* いいねを取り消すこともできます。

* Ajaxを使用しています。

<br>

## フォロー

* ユーザーをフォローすることができます。

* フォローを解除することもできます。

* Ajaxを使用しています。

* フォロー中の場合はマウスオーバーでフォローボタンの色とテキストが変化します。

<br>

## 検索

* ransackを使用しています。

* レシピ名、レシピ内容、ユーザー名、またはユーザープロフィール文からキーワード検索できます。

* GitHubやZennのように一度にすべての検索対象から検索をすることができます。

* 更新日、いいね数、コメント数、投稿数、フォロワー数、またはフォローしている人の数で検索結果がソートできます。

* 半角または全角スペースで区切ることでAND検索ができます。

* 検索対象を引き継いだまま、キーワードを変更して検索し直すことができます。

* kaminariによりページを分割して検索結果を表示しています。

<br>

## 通知

* ポリモーフィック関連付けを使用しています。

* フォローされたとき、投稿したレシピがいいねされたとき、投稿したレシピにコメントされたとき、またはコメントしたレシピに他のユーザーがコメントしたときに通知が作成されます。

* 通知の既読管理ができます。

* kaminariによりページを分割して通知内容の一覧を表示しています。

* 未読の通知がある場合はヘッダーのベルアイコンの右上にバッジが表示されます。

<br>

## js

* 各フォームで空欄、空文字の場合はボタンが動作しません。

* 各テキストエリアは改行でリサイズされます。

* フラッシュメッセージはXボタンをクリックすると非表示になります。

* ミートボールメニューをクリックするとドロップダウンリストが表示されます。

  ミートボールメニューまたはドロップダウンリスト外をクリック、あるいは画面をスクロールするとドロップダウンリストが非表示になります。

<br>

## マークアップ

* 文章を1行から最大で15行までに省略し、末尾に3点リーダーをつけて表示することができます。

* 要素の横幅に収まりきらない長い文字列は改行されるようにし、レイアウトが崩れないようにしています。

<br>

## その他

* プロフィール画像もしくはレシピ画像が更新されるときは更新前の画像をCloudinaryから削除してから新しい画像をアップロードするようにしています。

* seeds.rbでユーザーやレシピ、コメント、いいね、フォロー関係、通知のデモデータを作成できます。

<br>
<br>

# テストコードの詳細

## Model specs

* User.feed がフォローしているユーザーと自身の投稿のみを含んでいること

* User.followers_you_follow(current_user) が他ユーザーのフォロワーの中で自身がフォローしているユーザーのみを含んでいること

<br>

* Notification.create_comment_notification(comment) でコメントに関する通知が作成されること

* Notification.comment_notification_receiver_ids(comment) でコメントに関する通知が作成されるユーザーが正しいこと

* Notification.create_favorite_notification(favorite) でいいねに関する通知が作成されること

* Notification.create_relationship_notification(relationship) でフォローに関する通知が作成されること

<br>

* レシピタイトルの検索結果をコメント数でソートしたときに正しく並び替えられていること

* レシピタイトルの検索結果をいいね数でソートしたときに正しく並び替えられていること

* レシピタイトルの検索結果を更新日でソートしたときに正しく並び替えられていること

* レシピ内容の検索結果をコメント数でソートしたときに正しく並び替えられていること

* レシピ内容の検索結果をいいね数でソートしたときに正しく並び替えられていること

* レシピ内容の検索結果を更新日でソートしたときに正しく並び替えられていること

* ユーザー名の検索結果をフォロワー数でソートしたときに正しく並び替えられていること

* ユーザー名の検索結果をフォローしている人の数でソートしたときに正しく並び替えられていること

* ユーザー名の検索結果を投稿数でソートしたときに正しく並び替えられていること

* プロフィールの検索結果をフォロワー数でソートしたときに正しく並び替えられていること

* プロフィールの検索結果をフォローしている人の数でソートしたときに正しく並び替えられていること

* プロフィールの検索結果を投稿数でソートしたときに正しく並び替えられていること

<br>

## Request specs

* ユーザー一覧と詳細ページはログインしていなくてもアクセスできること

* ユーザー情報の編集ページには本人しかアクセスできないこと

* ユーザー情報の更新は本人しか実行できない、正常に更新できること

<br>

* レシピ一覧と詳細ページはログインしていなくてもアクセスできること

* ログイン時のみレシピを投稿できること

* レシピの編集ページには本人しかアクセスできないこと

* レシピの更新は本人しか実行できない、正常に更新できること

* レシピの削除は本人しか実行できない、正常に削除できること

<br>

* ログイン時のみコメントを投稿できること

* コメントの削除は本人しか実行できない、正常に削除できること

<br>

## System specs

* 新規登録できること

* ログインできること

* ゲストログインできること

* ユーザー情報の編集ページには本人しかアクセスできないこと

* メールアドレス、ユーザー名、プロフィール、プロフィール画像を更新できること

<br>

* ログイン時にレシピを投稿できること

* レシピの編集ページには本人しかアクセスできないこと

* 本人ならレシピの編集ページからレシピを更新できること

<br>

* ログイン時にコメントを投稿できること

<br>

* Ajaxでレシピにいいねできること

* Ajaxでいいねを取り消すことができること

<br>

* Ajaxでユーザーをフォローできること

* Ajaxでフォローを解除することができること

<br>

* 検索結果がない場合はその旨を表示すること

* 検索結果の合計数が各検索対象で正しいこと

* ページを更新しても検索キーワードがフォームに残ること

* 半角スペース、または全角スペース区切りでAND検索できること

* 選択している検索対象の検索結果のみが表示されること

* 検索対象を引き継いだまま、キーワードを変更して検索し直すことができること

<br>

* コメントが作成されたときにその人以外のコメントした人全員とレシピの作成者に通知が作成されること

* レシピ作成者がコメントしたときはその人以外のコメントした人全員に通知が作成されること

* コメントをした人には通知が作成されないこと

* レシピにいいねされたときに通知が作成されること

* レシピの作成者といいねをした人が同じ時は通知が作成されないこと

* フォローされたときに通知が作成されること

<br>

## その他

* テスト時間を短縮するためにModel specsではバリデーション以外のテストでバリデーションをスキップした画像がないインスタンスを使用するようにしています。
