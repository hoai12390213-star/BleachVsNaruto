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

/**
 * 颜色相关实用工具。
 */
public class ColorUtils {

    /**
     * 十进制颜色转十六进制字符串。
     *
     * @param color 颜色十进制数值。
     * @return 形如 <code>#RRGGBB</code> 的字符串。
     *
     * @example
     * <listing version="3.0">
     * ColorUtils.dec2hex(0xff0000); // '#FF0000'
     * </listing>
     */
    public static function dec2hex(color:uint):String {
        var hex:String = color.toString(16).toUpperCase();
        while (hex.length < 6) {
            hex = '0' + hex;
        }
        return '#' + hex;
    }
}
}
