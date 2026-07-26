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
 * 击落地特效 IDE 组件。
 *
 * <p>FighterMain 时间轴组件：调用 <code>$effect_ctrler.hitFloor</code>。</p>
 * <p><code>type</code>：0=弹，1=正常落地，2=重落地。</p>
 *
 * @see net.play5d.game.bvn.ide.component.BaseEffect
 */
public class HitFloorEffect extends BaseEffect {

    /** @private 落地类型 */
    private var _type:int = 1;

    /** @private 震动幅度 */
    private var _shakePow:Number = 0;

    /**
     * 构造方法。
     */
    public function HitFloorEffect() {
        super.title = '效果_击落地';
        refreshPreview();
    }

    /**
     * 落地类型。
     *
     * <p>0=弹，1=正常落地，2=重落地。</p>
     *
     * @return 类型值。
     * @default 1
     */
    public function get type():int {
        return _type;
    }

    /** @private */
    [Inspectable(name='落地类型（0=弹，1=正常落地，2=重落地）', type='Number', defaultValue=1)]
    public function set type(v:int):void {
        _type = v;
        refreshPreview();
    }

    /**
     * 震动幅度。
     *
     * @return 震动大小。
     * @default 0
     */
    public function get shakePow():Number {
        return _shakePow;
    }

    /** @private */
    [Inspectable(name='震动幅度', type='Number', defaultValue=0)]
    public function set shakePow(v:Number):void {
        _shakePow = v;
        refreshPreview();
    }

    /**
     * @inheritDoc
     */
    override public function doAction():void {
        if (!validateParam('落地类型', _type, [0, 1, 2])) {
            return;
        }

        invokeEffect('hitFloor', [_type, _shakePow]);
    }

    /** @private */
    private function refreshPreview():void {
        if (!validateParam('落地类型', _type, [0, 1, 2])) {
            return;
        }

        updateCallPreview('hitFloor', [_type, _shakePow]);
    }
}
}
