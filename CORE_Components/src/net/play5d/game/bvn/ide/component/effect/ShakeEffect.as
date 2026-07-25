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

package net.play5d.game.bvn.ide.component.effect {
import net.play5d.game.bvn.ide.component.BaseEffect;

/**
 * 震动特效 IDE 组件。
 *
 * <p>调用效果控制器的 <code>shake</code> 方法。</p>
 *
 * @see net.play5d.game.bvn.ide.component.BaseEffect
 */
public class ShakeEffect extends BaseEffect {

    /////////////// 静态方法 ///////////////

    ///////////////////////////////////////


    /////////////// 构造方法 ///////////////

    /**
     * 构造方法。
     */
    public function ShakeEffect() {
        super.title = '效果_震动';
    }

    ///////////////////////////////////////


    /////////////// 实现接口 ///////////////

    ///////////////////////////////////////


    /////////////// 公有属性 ///////////////

    ///////////////////////////////////////


    /////////////// 私有属性 ///////////////

    /** @private X 轴震动幅度 */
    private var _powX:Number = 0;
    /** @private Y 轴震动幅度 */
    private var _powY:Number = 0;

    ///////////////////////////////////////


    /////////// Getter & Setter ///////////

    /**
     * X 轴震动幅度。
     *
     * @return X 幅度。
     * @default 0
     */
    public function get powX():Number {
        return _powX;
    }
    /** @private */
    [Inspectable(name='powX', type='Number', defaultValue=0)]
    public function set powX(v:Number):void {
        _powX = v;
        refreshPreview();
    }

    /**
     * Y 轴震动幅度。
     *
     * @return Y 幅度。
     * @default 0
     */
    public function get powY():Number {
        return _powY;
    }
    /** @private */
    [Inspectable(name='powY', type='Number', defaultValue=0)]
    public function set powY(v:Number):void {
        _powY = v;
        refreshPreview();
    }

    ///////////////////////////////////////


    /////////////// 公有方法 ///////////////

    /**
     * @inheritDoc
     */
    override public function doAction():void {
        shake();
    }

    ///////////////////////////////////////


    /////////////// 私有方法 ///////////////

    /** @private 刷新检查器预览文字 */
    private function refreshPreview():void {
        updatePreviewText('(' + _powX + ', ' + _powY + ')');
    }

    /** @private 执行震动 */
    private function shake():void {
        if (!_effectCtrler) {
            return;
        }

        _effectCtrler.shake(_powX, _powY);
    }

    ///////////////////////////////////////

}
}
