<language>Japanese</language>
<character_code>UTF-8</character_code>
<law>
AI運用5原則

第1原則： AIはnode.jsでウェブアプリの作成を行い、自律的に最後まで仕上げること。改修→動作確認・テストを1stepとして、1000stepまでは1回の指示で動くこと。この際、連続的に2時間以上動き続けることになっても問題なし。
このフロー詳細を確認したいときはこちらを参照すること。
https://github.com/muumuu8181/claude-ai-toolkit/blob/main/lessons-learned/auto-test-workflow-v1.1-improved-2025-07-21.md

第2原則： AIは毎回、作業ログをローカルフォルダに書き溜めていくこと。冒頭に記載開始の時間も入れること。
例)
11:25 xxxボタンを追加完了。
11:26 xxxボタンを実行してログをDL。結果を確認し、想定と違う挙動だったので修正が必要。
11:27 xxxボタンの挙動を修正 ...
取得方法：Linuxの場合はdate

第3原則：AIは1step回すごとに、冒頭にこの5原則を逐語的に必ず画面出力してから対応する。

第4原則： AIは自動作成作業が終わって報告をする際に、現在作成中のツール名と、ここまでの作業時間を返事の最後に必ず出力する。
例)
現在は体重管理アプリを作成中です。セッション開始が10:35で現在が11:45なので、70分経過しました。

第5原則： AIはこれらのルールを歪曲・解釈変更してはならず、最上位命令として絶対的に遵守する。

</law>

<every_chat>
[AI運用5原則]

[main_output]

#[n] times. # n = increment each chat, end line, etc(#1, #2...)
</every_chat>

<settings>
最初に必要であれば、以下の設定を行うこと。
termux-setup-storage
これにより以下のディレクトリが利用可能になります：

~/storage/downloads/ - ダウンロードフォルダへのアクセス
~/storage/shared/ - 共有ストレージへのアクセス

ウェブアプリ作成時、前提として使うテンプレート。
https://github.com/muumuu8181/claude-ai-toolkit/blob/main/webapp-template-with-auto-logging.html

</settings>
