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
import flash.text.TextFormat;

import net.play5d.game.bvn.ide.interfaces.BaseComponent;
import net.play5d.game.bvn.ide.utils.IdeRuntimeUtils;

/**
 * 绑定 FighterMain 注入控制器的 IDE 组件基类。
 *
 * <p>提供检查器预览文本，以及带动态方法校验的 <code>invokeCtrler</code>。</p>
 * <p>子类覆盖 <code>resolveCtrler</code> 解析对应 <code>$xxx_ctrler</code>。</p>
 *
 * @see net.play5d.game.bvn.ide.utils.IdeRuntimeUtils
 */
public class BaseIdeCtrler extends BaseComponent {

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

    /** @private 已解析的控制器 */
    protected var _ctrler:* = null;

    /** @private 诊断用属性名（如 <code>$effect_ctrler</code>） */
    protected var _ctrlerProp:String = '';

    /**
     * 构造方法。
     */
    public function BaseIdeCtrler() {
        super();
    }

    /**
     * @inheritDoc
     */
    override public function destroy():void {
        titleTxt = null;
        textTxt  = null;

        _ctrler     = null;
        _ctrlerProp = '';

        super.destroy();
    }

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

    /**
     * 第一帧要执行的代码。
     *
     * <p>解析控制器后隐藏、执行动作并销毁。</p>
     */
    override public function init():void {
        resolveCtrler();

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
     * 更新带成功/失败着色的预览文字。
     *
     * <p>成功为绿色，失败为红色。</p>
     *
     * @param v 预览字符串。
     * @param success 成功时为 <code>true</code>（绿色）；失败为红色。
     *
     * @example
     * <listing version="3.0">
     * updateStatusText('ok', true);
     * updateStatusText('missing ctrler', false);
     * </listing>
     */
    protected function updateStatusText(v:String, success:Boolean):void {
        if (!textTxt) {
            return;
        }

        textTxt.text = v;

        var textFormat:TextFormat = new TextFormat();
        textFormat.color          = success ? 0x00aa00 : 0xff0000;
        textTxt.setTextFormat(textFormat);
    }

    /**
     * 校验参数是否符合预期。
     *
     * <p>失败时仅将参数名标红显示；通过时不改预览文字，由调用方继续更新。</p>
     * <p><code>expected</code> 为 <code>null</code>：校验非空（非 <code>null</code>、非空串）。
     * 为 <code>Array</code>：值须为其中之一；其它：值须与期望相等。</p>
     *
     * @param name 参数名（失败时标红显示）。
     * @param value 实际值。
     * @param expected 期望；默认 <code>null</code> 表示非空校验。
     * @return 通过返回 <code>true</code>。
     *
     * @example
     * <listing version="3.0">
     * validateParam('face', _face);
     * validateParam('type', _type, [0, 1, 2]);
     * validateParam('mode', _mode, 'hard');
     * </listing>
     */
    protected function validateParam(name:String, value:*, expected:* = null):Boolean {
        var ok:Boolean;

        if (expected == null) {
            ok = !isBlankParam(value);
        }
        else if (expected is Array) {
            ok = (expected as Array).indexOf(value) != -1;
        }
        else {
            ok = value == expected;
        }

        if (ok) {
            return true;
        }

        updateStatusText(name, false);
        trace('[BaseIdeCtrler] invalid param:', name, 'value=', value, 'expected=', expected, this);
        return false;
    }

    /**
     * 解析注入控制器。
     *
     * <p>子类覆盖：调用对应 <code>IdeRuntimeUtils.findXxxCtrler</code>，并设置 <code>_ctrlerProp</code>。</p>
     */
    protected function resolveCtrler():void {
    }

    /**
     * 安全调用已解析控制器的方法。
     *
     * @param methodName 方法名。
     * @param args 参数列表。
     * @return 调用成功返回 <code>true</code>。
     *
     * @example
     * <listing version="3.0">
     * invokeCtrler('shine', [0xffffff]);
     * </listing>
     */
    protected function invokeCtrler(methodName:String, args:Array = null):Boolean {
        if (!_ctrler) {
            return false;
        }

        if (!IdeRuntimeUtils.hasMethod(_ctrler, methodName)) {
            trace('[BaseIdeCtrler] method missing on', _ctrlerProp || '(ctrler)', ':', methodName, this);
            return false;
        }

        try {
            var fn:Function = _ctrler[methodName] as Function;
            fn.apply(_ctrler, args);
            return true;
        }
        catch (e:Error) {
            trace('[BaseIdeCtrler] invoke failed:', _ctrlerProp, methodName, e.message, this);
        }
        return false;
    }

    /** @private 是否视为空参数（null / 空串） */
    private function isBlankParam(value:*):Boolean {
        if (value == null) {
            return true;
        }
        if (value is String) {
            return String(value).length == 0;
        }
        return false;
    }
}
}
