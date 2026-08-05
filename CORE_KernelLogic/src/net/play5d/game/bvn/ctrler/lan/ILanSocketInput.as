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
 * 锁帧用的 Socket 输入通道（壳层 <code>GameSocketInput</code> 实现）。
 *
 * @see LockFrameClientLogic
 * @see LockFrameServerLogic
 */
public interface ILanSocketInput {
    /**
     * 采集本机按键到内部缓冲。
     */
    function renderInput():void;

    /**
     * 取出当前缓冲键值。
     * @return 键位打包值。
     */
    function getSocketData():int;

    /**
     * 清空缓冲。
     */
    function resetInput():void;

    /**
     * 写入远端/缓存键值。
     * @param v 键位打包值。
     */
    function setSocketData(v:int):void;
}
}
