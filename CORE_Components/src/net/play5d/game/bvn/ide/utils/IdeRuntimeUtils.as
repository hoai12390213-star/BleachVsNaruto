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

package net.play5d.game.bvn.ide.utils {
import flash.display.DisplayObject;

/**
 * Animate IDE 组件运行时解析工具。
 *
 * <p>沿显示树查找角色 MC 经 <code>initFighter</code> 注入的 <code>$effect_ctrler</code>。</p>
 */
public class IdeRuntimeUtils {

    /**
     * 效果控制器属性名（角色 main_mc 注入契约）。
     *
     * @default $effect_ctrler
     */
    public static const EFFECT_CTRLER_PROP:String = '$effect_ctrler';

    /**
     * 沿 parent 链查找已注入的效果控制器。
     *
     * @param from 起始显示对象（通常为组件自身）。
     * @return 效果控制器；未找到时返回 <code>null</code>。
     *
     * @example
     * <listing version="3.0">
     * var ctrler:* = IdeRuntimeUtils.findEffectCtrler(this);
     * if (ctrler) {
     *     ctrler.shine(0xffffff);
     * }
     * </listing>
     *
     * @see #EFFECT_CTRLER_PROP
     */
    public static function findEffectCtrler(from:DisplayObject):* {
        var node:DisplayObject = from;

        while (node) {
            try {
                if (EFFECT_CTRLER_PROP in node) {
                    var ctrler:* = node[EFFECT_CTRLER_PROP];
                    if (ctrler) {
                        return ctrler;
                    }
                }
            }
            catch (e:Error) {
            }

            node = node.parent;
        }

        return null;
    }
}
}
