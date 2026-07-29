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
 * 向实例动态写入属性。
 *
 * @param instance 目标实例；为 <code>null</code> 时直接返回。
 * @param elementName 属性名。
 * @param value 要写入的值。
 * @example
 * <listing version="3.0">
 * SetElement(fighter, 'hp', 100);
 * </listing>
 */
public function SetElement(instance:*, elementName:String, value:*):void {
    if (!instance) {
        return;
    }

    try {
        instance[elementName] = value;
    }
    catch (e:Error) {
        ThrowError(e, 'Invalid property value!');
    }
}
}
