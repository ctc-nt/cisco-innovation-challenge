- sqlite3 >= 3.35.0 is required

    download and build -> https://www.sqlite.org/download.html


とりあえずベータ版

base-knowledge に前提情報として入れたい情報を記載した markdown とかを投入すると、
それを loader が読み込んで、vectorstore にしてくれて、embedding までしてくれる。

それをもとに chat OpenAI API でチャット形式の質問に答えてくれる


例えば、
- target-device.md
- ctc-network-op.md

という二つの情報を与えて、
障害リンクの両端の対象機と迂回手順を教えた

そのとき
「今回の障害の対象機は？」みたいに質問すると答えてくれるし、
「経路迂回の手順は？」も教えてくれる