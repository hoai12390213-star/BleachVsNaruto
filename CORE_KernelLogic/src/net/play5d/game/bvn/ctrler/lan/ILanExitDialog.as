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

package net.play5d.game.bvn.ctrler.lan {
/**
 * 联机退出确认对话框（壳层实现并注入 <code>LanGameMenuCtrl</code>）。
 *
 * @see LanGameMenuCtrl
 */
public interface ILanExitDialog {
    /**
     * 显示对话框。
     */
    function show():void;

    /**
     * 隐藏对话框。
     */
    function hide():void;

    /**
     * 是否正在显示。
     * @return 显示中为 <code>true</code>。
     */
    function isShowing():Boolean;

    /**
     * 销毁内部资源。
     */
    function destroy():void;
}
}
