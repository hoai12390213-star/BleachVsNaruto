/*
 * Copyright (C) 2021-2024, 5DPLAY Game Studio
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

package {

/**
 * 从实例动态读取属性，或调用无参方法。
 *
 * <p><code>elementName</code> 以 <code>()</code> 结尾时视为方法名并调用；否则按属性名读取。</p>
 *
 * @param instance 目标实例；为 <code>null</code> 时返回 <code>null</code>。
 * @param elementName 属性名，或带括号的方法名（如 <code>toString()</code>）。
 * @return 属性值或方法返回值；失败时返回 <code>null</code>。
 * @example
 * <listing version="3.0">
 * GetElement(fighter, 'hp');
 * GetElement(vo, 'toString()');
 * </listing>
 */
public function GetElement(instance:*, elementName:String):* {
    if (!instance) {
        return null;
    }

    var result:* = null;

    try {
        const BRACKET:String = '()';

        if (elementName.indexOf(BRACKET) != -1) {
            // 方法：去掉括号后调用
            elementName = elementName.substr(0, elementName.length - BRACKET.length);
            result      = instance[elementName]();
        }
        else {
            result = instance[elementName];
        }
    }
    catch (e:Error) {
        ThrowError(e, 'Invalid property value!');
    }

    return result;
}
}
