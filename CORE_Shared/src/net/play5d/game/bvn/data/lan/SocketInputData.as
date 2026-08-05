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

package net.play5d.game.bvn.data.lan {
/**
 * Socket 同步用按键缓冲（Pc/Mob 共用；Mob 额外使用 select/back）。
 */
public class SocketInputData {
    include '../../../../../../../include/ImportVersion.as';

    /**
     * 构造空缓冲。
     */
    public function SocketInputData() {
    }

    /** 上 */
    public var up:Boolean;
    /** 下 */
    public var down:Boolean;
    /** 左 */
    public var left:Boolean;
    /** 右 */
    public var right:Boolean;
    /** 攻击 */
    public var attack:Boolean;
    /** 跳跃 */
    public var jump:Boolean;
    /** 冲刺 */
    public var dash:Boolean;
    /** 技能 */
    public var skill:Boolean;
    /** 大招 */
    public var superSkill:Boolean;
    /** 特殊 */
    public var special:Boolean;
    /** 确认/选择（主要 Mob） */
    public var select:Boolean;
    /** 返回（主要 Mob） */
    public var back:Boolean;

    /**
     * 清空全部按键标记。
     */
    public function clear():void {
        up    = false;
        down  = false;
        left  = false;
        right = false;

        attack     = false;
        jump       = false;
        dash       = false;
        skill      = false;
        superSkill = false;
        special    = false;

        select = false;
        back   = false;
    }
}
}
