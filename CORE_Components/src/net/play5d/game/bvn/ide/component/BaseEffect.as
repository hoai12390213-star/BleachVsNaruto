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
 * <p>仅面向 FighterMain 时间轴：读取 <code>$effect_ctrler</code>，并对动态对象做方法存在性检查。</p>
 *
 * @see net.play5d.game.bvn.ide.utils.IdeRuntimeUtils#findEffectCtrler()
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
     * @inheritDoc
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
     *
     * @default null
     */
    public var titleTxt:TextField = getChildByName('titleTxt') as TextField;
    /**
     * 预览文字文本。
     *
     * @default null
     */
    public var textTxt:TextField = getChildByName('textTxt') as TextField;

    ///////////////////////////////////////


    /////////////// 私有属性 ///////////////

    /** @private 特效控制器（$effect_ctrler） */
    protected var _effectCtrler:* = null;

    ///////////////////////////////////////


    /////////// Getter & Setter ///////////

    /**
     * 标题文本内容。
     *
     * @return 标题字符串；无文本框时返回空串。
     */
    public function get title():String {
        return titleTxt ? titleTxt.text : '';
    }
    /** @private */
    public function set title(v:String):void {
        if (titleTxt) {
            titleTxt.text = v;
        }
    }

    /**
     * 预览文字内容。
     *
     * @return 预览字符串；无文本框时返回空串。
     */
    public function get text():String {
        return textTxt ? textTxt.text : '';
    }
    /** @private */
    public function set text(v:String):void {
        updatePreviewText(v);
    }

    ///////////////////////////////////////


    /////////////// 公有方法 ///////////////

    /**
     * 第一帧要执行的代码。
     *
     * <p>解析特效控制器后隐藏、执行动作并销毁。</p>
     */
    override public function init():void {
        initEffectCtrler();

        hidden();
        doAction();
        destroy();
    }

    /**
     * @inheritDoc
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
     * 安全调用效果控制器方法（动态属性能力检查）。
     *
     * @param methodName 方法名。
     * @param args 参数列表。
     * @return 调用成功返回 <code>true</code>。
     *
     * @example
     * <listing version="3.0">
     * invokeEffect('shine', [0xffffff]);
     * </listing>
     */
    protected function invokeEffect(methodName:String, args:Array = null):Boolean {
        if (!_effectCtrler) {
            return false;
        }

        if (!IdeRuntimeUtils.hasMethod(_effectCtrler, methodName)) {
            trace('[BaseEffect] method missing on $effect_ctrler:', methodName, this);
            return false;
        }

        try {
            var fn:Function = _effectCtrler[methodName] as Function;
            fn.apply(_effectCtrler, args);
            return true;
        }
        catch (e:Error) {
            trace('[BaseEffect] invoke failed:', methodName, e.message, this);
        }
        return false;
    }

    /**
     * @private 解析 FighterMain 的 $effect_ctrler。
     */
    private function initEffectCtrler():void {
        _effectCtrler = IdeRuntimeUtils.findEffectCtrler(this);
    }

    ///////////////////////////////////////
}
}
