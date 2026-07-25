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
 * <p>沿显示树查找 FighterMain 经 <code>initFighter</code> 注入的控制器引用。</p>
 * <p>角色 main_mc 契约：</p>
 * <listing version="3.0">
 * var $fighter_ctrler:*;
 * var $mc_ctrler:*;
 * var $effect_ctrler:*;
 * var $camera_ctrler:*;
 * function initFighter(param:Object):void {
 *     $fighter_ctrler = param.fighter_ctrler;
 *     $mc_ctrler      = param.mc_ctrler;
 *     $effect_ctrler  = param.effect_ctrler;
 *     $camera_ctrler  = param.camera_ctrler;
 * }
 * </listing>
 */
public class IdeRuntimeUtils {

    /**
     * 角色主控制器属性名。
     *
     * @default $fighter_ctrler
     */
    public static const FIGHTER_CTRLER_PROP:String = '$fighter_ctrler';
    /**
     * MC / 动作控制器属性名。
     *
     * @default $mc_ctrler
     */
    public static const MC_CTRLER_PROP:String = '$mc_ctrler';
    /**
     * 效果控制器属性名。
     *
     * @default $effect_ctrler
     */
    public static const EFFECT_CTRLER_PROP:String = '$effect_ctrler';
    /**
     * 镜头控制器属性名。
     *
     * @default $camera_ctrler
     */
    public static const CAMERA_CTRLER_PROP:String = '$camera_ctrler';

    /**
     * 沿 parent 链查找已注入的角色主控制器。
     *
     * @param from 起始显示对象（通常为组件自身）。
     * @return 角色主控制器；未找到时返回 <code>null</code>。
     *
     * @example
     * <listing version="3.0">
     * var ctrler:* = IdeRuntimeUtils.findFighterCtrler(this);
     * </listing>
     *
     * @see #FIGHTER_CTRLER_PROP
     */
    public static function findFighterCtrler(from:DisplayObject):* {
        return findInjected(from, FIGHTER_CTRLER_PROP);
    }

    /**
     * 沿 parent 链查找已注入的 MC 控制器。
     *
     * <p>对应时间轴用法 <code>parent.$mc_ctrler</code>。</p>
     *
     * @param from 起始显示对象（通常为组件自身）。
     * @return MC 控制器（FighterMcCtrler）；未找到时返回 <code>null</code>。
     *
     * @example
     * <listing version="3.0">
     * var mcCtrler:* = IdeRuntimeUtils.findMcCtrler(this);
     * if (mcCtrler) {
     *     mcCtrler.idle();
     * }
     * </listing>
     *
     * @see #MC_CTRLER_PROP
     */
    public static function findMcCtrler(from:DisplayObject):* {
        return findInjected(from, MC_CTRLER_PROP);
    }

    /**
     * 沿 parent 链查找已注入的效果控制器。
     *
     * <p>对应时间轴用法 <code>parent.$effect_ctrler</code>。</p>
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
        return findInjected(from, EFFECT_CTRLER_PROP);
    }

    /**
     * 沿 parent 链查找已注入的镜头控制器。
     *
     * <p>对应时间轴用法 <code>parent.$camera_ctrler</code>。</p>
     *
     * @param from 起始显示对象（通常为组件自身）。
     * @return 镜头控制器（FighterCameraCtrler）；未找到时返回 <code>null</code>。
     *
     * @example
     * <listing version="3.0">
     * var cam:* = IdeRuntimeUtils.findCameraCtrler(this);
     * if (cam) {
     *     cam.focusSelf();
     * }
     * </listing>
     *
     * @see #CAMERA_CTRLER_PROP
     */
    public static function findCameraCtrler(from:DisplayObject):* {
        return findInjected(from, CAMERA_CTRLER_PROP);
    }

    /**
     * @private 沿 parent 链查找指定注入属性。
     */
    private static function findInjected(from:DisplayObject, prop:String):* {
        var node:DisplayObject = from;

        while (node) {
            try {
                if (prop in node) {
                    var value:* = node[prop];
                    if (value) {
                        return value;
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
