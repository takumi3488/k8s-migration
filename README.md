# k8s-migration

単一のPostgreSQLサーバ上に複数のDBを作る際に、複数DBに対応したマイグレーションツールがなかったので作りました。

## 使い方

以下のコマンドが使用できる必要があります。

- docker
- task
- bun

.envに以下を指定

```
DOCKER_IMAGE_NAME="example/k8s-migration"
```

以下のコマンドでmigrationファイルを作成

```
$ task add
```

以下のコマンドでDockerイメージをpush

```
$ task push
```

pushしたDockerイメージを実行する際には以下のような環境変数を設定

```
$ DATABASE_URL_BASE: postgresql://postgres:postgres@db:5432
```
