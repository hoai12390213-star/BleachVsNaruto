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
import flash.utils.ByteArray;

/**
 * UDP 收包封装：来源地址与按类型取出的载荷。
 *
 * @see UdpDataType
 */
public class UDPDataVO {
    /**
     * 构造空 VO。
     */
    public function UDPDataVO() {
    }

    /** 载荷类型，见 <code>UdpDataType</code>。 */
    public var dataType:int;

    /** 发送方 IP。 */
    public var fromIP:String;
    /** 发送方端口。 */
    public var fromPort:int;

    /** @private */
    private var _data:Object;

    /**
     * 取出二进制载荷；读取前将 <code>position</code> 置 0。
     * @return 二进制数据，类型不匹配时为 <code>null</code>。
     */
    public function getDataByteArray():ByteArray {
        if (dataType == UdpDataType.BYTEARRAY) {
            (_data as ByteArray).position = 0;

            return _data as ByteArray;
        }

        return null;
    }

    /**
     * 取出字符串载荷。
     * @return 字符串，类型不匹配时为 <code>null</code>。
     */
    public function getDataString():String {
        return dataType == UdpDataType.STRING ? _data as String : null;
    }

    /**
     * 取出对象载荷。
     * @return 对象，类型不匹配时为 <code>null</code>。
     */
    public function getDataObject():Object {
        return dataType == UdpDataType.OBJECT ? _data : null;
    }

    /**
     * 写入载荷本体。
     * @param v 与 <code>dataType</code> 对应的数据。
     */
    public function setData(v:Object):void {
        _data = v;
    }
}
}
