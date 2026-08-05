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
 * 锁帧客户端对壳层会话的依赖（发送 / 延时 / 同步错误）。
 *
 * @see LockFrameClientLogic
 */
public interface ILanClientLockLink {
    /**
     * 发送 UDP 载荷。
     * @param data 通常为 <code>ByteArray</code>。
     */
    function sendUDP(data:Object):void;

    /**
     * 更新显示用延迟。
     * @param v 毫秒。
     */
    function updateDelay(v:int):void;

    /**
     * 报告同步错误。
     * @param wait 是否进入等待态。
     */
    function syncError(wait:Boolean = false):void;

    /**
     * 清除同步错误标记。
     */
    function resetSyncError():void;
}
}
