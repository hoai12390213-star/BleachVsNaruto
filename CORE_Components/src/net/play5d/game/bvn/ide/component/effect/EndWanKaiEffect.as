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
 * 结束万解 IDE 组件。
 *
 * <p>FighterMain 时间轴组件：调用 <code>$effect_ctrler.endWanKai</code>。配对 <code>WanKaiEffect</code>。</p>
 *
 * @see net.play5d.game.bvn.ide.component.effect.WanKaiEffect
 * @see net.play5d.game.bvn.ide.component.BaseEffect
 */
public class EndWanKaiEffect extends BaseEffect {

    /**
     * 构造方法。
     */
    public function EndWanKaiEffect() {
        super.title = '效果_结束万解';
        updateCallPreview('endWanKai');
    }

    /**
     * @inheritDoc
     */
    override public function doAction():void {
        invokeEffect('endWanKai');
    }
}
}
