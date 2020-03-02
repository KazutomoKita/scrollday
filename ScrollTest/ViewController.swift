//
//  ViewController.swift
//  ScrollTest
//
//  Created by Kazutomo Kita on 2020/03/02.
//  Copyright © 2020 Kazutomo Kita. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    //一度だけメニュー作成をするためのフラグ
    var didPrepareMenu = false

    //タブの横幅
    let tabLabelWidth:CGFloat = 100

    //viewDidLoad等で処理を行うと
    //scrollViewの正しいサイズが取得出来ません
    override func viewDidLayoutSubviews() {

        //viewDidLayoutSubviewsはviewDidLoadと違い
        //何度も呼ばれてしまうメソッドなので
        //一度だけメニュー作成を行うようにします
        if didPrepareMenu { return }
        didPrepareMenu = true

        //scrollViewのDelegateを指定
        scrollView.delegate = self

        //タブのタイトル
        let titles = ["月","火","水","木","金","土","日"] //タブのタイトル

        //タブの縦幅(UIScrollViewと一緒にします)
        let tabLabelHeight:CGFloat = scrollView.frame.height

        //右端にダミーのUILabelを置くことで
        //一番右のタブもセンターに持ってくることが出来ます
        let dummyLabelWidth = scrollView.frame.size.width/2 - tabLabelWidth/2
        let headDummyLabel = UILabel()
        headDummyLabel.frame = CGRect(x:0, y:0, width:dummyLabelWidth, height:tabLabelHeight)
        scrollView.addSubview(headDummyLabel)

        //タブのx座標．
        //ダミーLabel分，はじめからずらしてあげましょう．
        var originX:CGFloat = dummyLabelWidth
        //titlesで定義したタブを1つずつ用意していく
        for title in titles {
            //タブになるUILabelを作る
            let label = UILabel()
            label.textAlignment = .center
            label.frame = CGRect(x:originX, y:0, width:tabLabelWidth, height:tabLabelHeight)
            label.text = title

            //scrollViewにぺたっとする
            scrollView.addSubview(label)

            //次のタブのx座標を用意する
            originX += tabLabelWidth
        }

        //左端にダミーのUILabelを置くことで
        //一番左のタブもセンターに持ってくることが出来ます
        let tailLabel = UILabel()
        tailLabel.frame = CGRect(x:originX, y:0, width:dummyLabelWidth, height:tabLabelHeight)
        scrollView.addSubview(tailLabel)

        //ダミーLabel分を足して上げましょう
        originX += dummyLabelWidth

        //scrollViewのcontentSizeを，タブ全体のサイズに合わせてあげる(ここ重要！)
        //最終的なoriginX = タブ全体の横幅 になります
        scrollView.contentSize = CGSize(width:originX, height:tabLabelHeight)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == self.scrollView else { return }

        //微妙なスクロール位置でスクロールをやめた場合に
        //ちょうどいいタブをセンターに持ってくるためのアニメーションです

        //現在のスクロールの位置(scrollView.contentOffset.x)から
        //どこのタブを表示させたいか計算します
        let index = Int((scrollView.contentOffset.x + tabLabelWidth/2) / tabLabelWidth)
        let x = index * 100
        UIView.animate(withDuration: 0.3, animations: {
            scrollView.contentOffset = CGPoint(x:x, y:0)
        })
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }

        //これも上と同様に

        let index = Int((scrollView.contentOffset.x + tabLabelWidth/2) / tabLabelWidth)
        let x = index * 100
        UIView.animate(withDuration: 1.0, animations: {
            scrollView.contentOffset = CGPoint(x:x, y:0)
        })
    }
}   


