/*
 * Copyright (C) 2021-2026, 5DPLAY Game Studio
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package net.play5d.game.bvn.ide.component {
import flash.text.TextField;

import net.play5d.game.bvn.ide.interfaces.BaseComponent;
import net.play5d.game.bvn.ide.utils.IdeRuntimeUtils;

/**
 * 效果类 IDE 组件基类。
 *
 * <p>优先沿显示树读取 <code>$effect_ctrler</code>；找不到时回退到 <code>$owner</code> 控制器。</p>
 */
public class BaseEffect extends BaseComponent {

    /////////////// 静态方法 ///////////////

    ///////////////////////////////////////


    /////////////// 构造方法 ///////////////

    /**
     * 构造方法。
     */
    public function BaseEffect() {
        super();
    }

    ///////////////////////////////////////


    /////////////// 实现接口 ///////////////

    /**
     * 销毁自身。
     */
    override public function destroy():void {
        titleTxt = null;
        textTxt  = null;

        _effectCtrler = null;

        super.destroy();
    }

    ///////////////////////////////////////


    /////////////// 公有属性 ///////////////

    /**
     * 标题文本。
     */
    public var titleTxt:TextField = getChildByName('titleTxt') as TextField;
    /**
     * 文字文本。
     */
    public var textTxt:TextField = getChildByName('textTxt') as TextField;

    ///////////////////////////////////////


    /////////////// 私有属性 ///////////////

    /**
     * @private 特效控制器。
     */
    protected var _effectCtrler:* = null;

    ///////////////////////////////////////


    /////////// Getter & Setter ///////////

    /**
     * 标题文本内容。
     */
    public function get title():String {
        return titleTxt ? titleTxt.text : '';
    }
    /**
     * @private
     */
    public function set title(v:String):void {
        if (titleTxt) {
            titleTxt.text = v;
        }
    }

    /**
     * 预览文字内容。
     */
    public function get text():String {
        return textTxt ? textTxt.text : '';
    }
    /**
     * @private
     */
    public function set text(v:String):void {
        updatePreviewText(v);
    }

    ///////////////////////////////////////


    /////////////// 公有方法 ///////////////

    /**
     * 第一帧要执行的代码。
     */
    override public function init():void {
        initEffectCtrler();

        hidden();
        doAction();
        destroy();
    }

    /**
     * 要详细执行的动作。
     */
    override public function doAction():void {
        super.doAction();
    }

    ///////////////////////////////////////


    /////////////// 私有方法 ///////////////

    /**
     * 更新检查器预览文字。
     *
     * @param v 预览字符串。
     */
    protected function updatePreviewText(v:String):void {
        if (textTxt) {
            textTxt.text = v;
        }
    }

    /**
     * 初始化特效控制器。
     *
     * <p>优先 parent 链上的 <code>$effect_ctrler</code>；否则用 <code>$owner</code> fallback。</p>
     */
    private function initEffectCtrler():void {
        _effectCtrler = IdeRuntimeUtils.findEffectCtrler(this);
        if (_effectCtrler) {
            return;
        }

        bindContext();

        try {
            if ($owner) {
                _effectCtrler = $owner.getCtrler().getEffectCtrl();
            }
        }
        catch (e:Error) {
            _effectCtrler = null;
        }

        if (!_effectCtrler) {
            trace('[BaseEffect] effect ctrler not found:', this);
        }
    }

    ///////////////////////////////////////
}
}

