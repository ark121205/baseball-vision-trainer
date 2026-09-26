Pitch Analyzer v3.1 動画選択修正パッチ

目的
====
iOS 18.5 Simulatorで、
動画に青いチェックが付いても選択が確定せず、
アプリへ戻らない問題を修正します。

このZIPに入っているもの
======================
Views/VideoPickerView.swift
NEW_ANALYSIS_EDIT.txt

Xcodeで行うこと
================
1. ZIPを展開する
2. Views/VideoPickerView.swift を
   Xcode左側の Views フォルダへドラッグ
3. Copy files to destination = ON
4. Target: PitchAnalyzer = ON
5. Finish

次に既存の NewAnalysisView.swift を3か所だけ変更します。
NEW_ANALYSIS_EDIT.txt の通りに変更してください。

変更後:
Command + B
→ Build Succeeded
→ Run

期待する動作
============
「スロー動画を選択」
→ 動画を1本タップ
→ 自動で写真ピッカーが閉じる
→ アプリへ戻る
→ 「解析中…」
→ 投球区間 / リリース候補 / 到達候補
