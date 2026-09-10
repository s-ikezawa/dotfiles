// ビルド定義。kotlin-lsp はこれを読んでプロジェクトを組み立てる。
// settings.gradle.kts だけだと LSP は起動して補完も返すが、型が解決されず
// 診断が出ないことを実測した（隣の Main.kt の型不一致に何も出なかった）。
//
// Gradle 本体も wrapper も置いていないが、**LSP が自前の Gradle を走らせる**。
// 開くとこの隣に .gradle/9.6.0/ が生える（ロックとハッシュのキャッシュ）。
// chezmoi は宣言したファイルしか見ないので apply には影響しないが、
// 設定ディレクトリに生成物が残ることは承知しておくこと。
plugins {
    kotlin("jvm") version "2.4.20"
}

repositories {
    mavenCentral()
}
