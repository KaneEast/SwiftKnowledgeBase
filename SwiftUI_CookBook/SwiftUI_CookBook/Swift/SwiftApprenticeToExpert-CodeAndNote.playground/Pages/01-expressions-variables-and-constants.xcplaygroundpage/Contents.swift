/*:
 コンピュータの中心となるのは中央処理装置( CPU ) です。
 
 CPU は、ランダム アクセス メモリ( RAM ) として知られるコンピュータのメイン メモリからレジスタに数値を読み取ることができます。レジスタに保存されている数値を RAM に書き戻すこともできます。この機能により、CPU はレジスターバンクに収まらない大量のデータを処理できるようになります。
 
 ![computer](computer.png)
 
 ### 遊び場の概要
 ![playground](playground.png)
 
1. ソース エディター
2. 結果サイドバー
3. リソース ツリー
4. 実行コントロール\
  再実行を強制するには、実行制御ボタンを 2 回クリックします。
5. アクティビティビューア
6. 左側のパネル コントロール
7. 右パネルコントロール
8. ボトムパネルコントロール
 */





import Foundation
// PRINT
print("Hello, Swift Apprentice reader!")


// ARITHMETIC
2 + 6
10 - 2
2 * 4
24 / 3
2+6
22 / 7
22.0 / 7.0
28 % 10
(28.0).truncatingRemainder(dividingBy: 10.0)

1 << 3
32 >> 2

((8000 / (5 * 10)) - 32) >> (29 % 5)
350 / 5 + 2
350 / (5 + 2)


// MATH FUNCTIONS
sin(45 * Double.pi / 180)
cos(135 * Double.pi / 180)
(2.0).squareRoot()
max(5, 10)
min(-5, -10)
max((2.0).squareRoot(), Double.pi / 2)

// VARIABLES & CONSTANTS
let number: Int = 10
//number = 0 /* Cannot assign to value: 'constantNumber' is a 'let' constant */

let pi: Double = 3.14159

var variableNumber: Int = 42
variableNumber = 0
variableNumber = 1_000_000

var 🐶💩: Int = -1


// ARITHMETIC WITH VARIABLES
var counter: Int = 0
counter += 1
counter -= 1

counter = 10
counter *= 3
counter /= 2


