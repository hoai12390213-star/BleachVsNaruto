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
 * 跨平台一致的局域网 Object/JSON 消息工厂。
 *
 * <p>寻主机（FIND_HOST）因 Pc/Mob 线格式不同，仍由各壳消息工厂实现。</p>
 *
 * @see LanMsgType
 */
public class LanSocketMsgFactory {
    include '../../../../../../../include/ImportVersion.as';

    /**
     * 加入游戏。
     * @param name 玩家名。
     * @return 消息对象。
     * @example
     * <listing version="3.0">
     * LanSocketMsgFactory.createJoinMsg('player1');
     * </listing>
     */
    public static function createJoinMsg(name:String):Object {
        var o:Object = {};
        o.type       = LanMsgType.JOIN;
        o.name       = name;

        return o;
    }

    /**
     * 加入游戏成功。
     * @return 消息对象。
     * @example
     * <listing version="3.0">
     * LanSocketMsgFactory.createJoinSuccMsg();
     * </listing>
     */
    public static function createJoinSuccMsg():Object {
        var o:Object = {};
        o.type       = LanMsgType.JOIN_BACK;
        o.success    = true;

        return o;
    }

    /**
     * 加入房间通知。
     * @param name 玩家名。
     * @return 消息对象。
     * @example
     * <listing version="3.0">
     * LanSocketMsgFactory.createJoinInMsg('player1');
     * </listing>
     */
    public static function createJoinInMsg(name:String):Object {
        var o:Object = {};
        o.type       = LanMsgType.JOIN_IN;
        o.name       = name;

        return o;
    }

    /**
     * 加入游戏失败。
     * @param msg 失败原因。
     * @return 消息对象。
     * @example
     * <listing version="3.0">
     * LanSocketMsgFactory.createJoinFailMsg('room full');
     * </listing>
     */
    public static function createJoinFailMsg(msg:String = null):Object {
        var o:Object = {};
        o.type       = LanMsgType.JOIN_BACK;
        o.success    = false;
        o.msg        = msg;

        return o;
    }

    /**
     * 踢出房间。
     * @param msg 原因。
     * @return 消息对象。
     * @example
     * <listing version="3.0">
     * LanSocketMsgFactory.createKickOutMsg('timeout');
     * </listing>
     */
    public static function createKickOutMsg(msg:String = null):Object {
        var o:Object = {};
        o.type       = LanMsgType.KICK_OUT;
        o.msg        = msg;

        return o;
    }

    /**
     * 聊天。
     * @param chart 内容。
     * @param name 发送者名。
     * @return 消息对象。
     * @example
     * <listing version="3.0">
     * LanSocketMsgFactory.createChart('hello', 'player1');
     * </listing>
     */
    public static function createChart(chart:String, name:String):Object {
        var o:Object = {};
        o.type       = LanMsgType.CHART;
        o.msg        = chart;
        o.name       = name;

        return o;
    }

    /**
     * 开始游戏。
     * @return 消息对象。
     * @example
     * <listing version="3.0">
     * LanSocketMsgFactory.createStartGame();
     * </listing>
     */
    public static function createStartGame():Object {
        var o:Object = {};
        o.type       = LanMsgType.START_GAME;

        return o;
    }
}
}
