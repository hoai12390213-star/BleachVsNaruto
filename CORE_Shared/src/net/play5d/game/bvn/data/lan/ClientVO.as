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
import flash.net.Socket;

/**
 * 局域网已连接客户端描述。
 */
public class ClientVO {
    /**
     * 构造空客户端 VO。
     */
    public function ClientVO() {
    }

    /** 客户端 IP。 */
    public var ip:String;
    /** 客户端端口。 */
    public var port:int;
    /** 显示名。 */
    public var name:String;
    /** TCP 套接字。 */
    public var socket:Socket;

    /**
     * 客户端标识（当前为 IP）。
     * @return 标识字符串。
     */
    public function get id():String {
        return ip;
    }
}
}
