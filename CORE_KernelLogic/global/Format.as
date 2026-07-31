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

package {

/**
 * 使用命名占位符 <code>{name}</code> 格式化字符串。
 *
 * <p>字面量大括号写作 <code>{{</code> 与 <code>}}</code>。
 * 占位符名须符合 <code>[A-Za-z_][A-Za-z0-9_]*</code>；个数不限，单次线性扫描。</p>
 *
 * @param format 源字符串；空或无 <code>{</code> 时原样返回。
 * @param params 占位符名到替换值的映射；可为 <code>null</code>（视为空对象）。
 * @return 格式化后的字符串。
 * @throws ArgumentError 模板含命名占位符而 <code>params</code> 缺对应键。
 * @example
 * <listing version="3.0">
 * var out:String = Format('今天是星期{weekday}，天气：{weather}', {weekday: 1, weather: '晴'});
 * // "今天是星期1，天气：晴"
 * Format('字面量 {{ 与 }}'); // "字面量 { 与 }"
 * </listing>
 * @see Printf
 * @see GetLang
 * @see Trace
 */
public function Format(format:String, params:Object = null):String {
    if (!format) {
        return format;
    }

    var len:int = format.length;
    // 无 "{" 则不可能含命名占位符，直接返回避免后续分配
    if (len == 0 || format.indexOf('{') == -1) {
        return format;
    }

    params ||= {};

    // 是否含字面量转义 "{{" / "}}"（与占位符个数无关，仅决定是否走转义分支）
    var hasEscape:Boolean = format.indexOf('{{') != -1 || format.indexOf('}}') != -1;

    // parts        — 输出片段（字面量段 + 替换值），随占位符数量增长
    // missing      — 懒分配：缺失的占位符名，扫描结束后统一抛错
    // literalStart — 尚未写入 parts 的字面量区间起点
    // replaced     — 是否发生过替换或转义展开；为 false 时可原样返回
    var parts:Array      = [];
    var missing:Array    = null;
    var i:int            = 0;
    var literalStart:int = 0;
    var replaced:Boolean = false;

    // 单次线性扫描：顺序处理字面量、转义大括号、命名占位符
    while (i < len) {
        var c:int = format.charCodeAt(i);

        // 字面量 "}}" → 输出单个 "}"
        if (hasEscape && c == 0x7D) { // '}'
            if (i + 1 < len && format.charCodeAt(i + 1) == 0x7D) {
                parts[parts.length] = format.substring(literalStart, i);
                parts[parts.length] = '}';
                i                  += 2;
                literalStart        = i;
                replaced            = true;
                continue;
            }
        }

        // 非 "{" 继续扫描
        if (c != 0x7B) { // '{'
            i++;
            continue;
        }

        // 字面量 "{{" → 输出单个 "{"
        if (hasEscape && i + 1 < len && format.charCodeAt(i + 1) == 0x7B) {
            parts[parts.length] = format.substring(literalStart, i);
            parts[parts.length] = '{';
            i                  += 2;
            literalStart        = i;
            replaced            = true;
            continue;
        }

        // 尝试解析 "{name}"，name 须符合 [A-Za-z_][A-Za-z0-9_]*
        var nameStart:int = i + 1;
        if (nameStart >= len) {
            i++;
            continue;
        }

        // 标识符首字符：_ / A–Z / a–z
        var nc:int = format.charCodeAt(nameStart);
        if (nc != 95 && (nc < 65 || nc > 90) && (nc < 97 || nc > 122)) {
            i++;
            continue;
        }

        // 标识符后续：首字符规则 + 0–9
        var j:int = nameStart + 1;
        var cc:int;
        while (j < len) {
            cc = format.charCodeAt(j);
            if (cc == 95 || (cc >= 65 && cc <= 90) || (cc >= 97 && cc <= 122) || (cc >= 48 && cc <= 57)) {
                j++;
            }
            else {
                break;
            }
        }

        // 未以 "}" 闭合则视为普通字符
        if (j >= len || format.charCodeAt(j) != 0x7D) { // '}'
            i++;
            continue;
        }

        var name:String     = format.substring(nameStart, j);
        parts[parts.length] = format.substring(literalStart, i);
        replaced            = true;

        if (!(name in params)) {
            if (!missing) {
                missing = [];
            }
            missing[missing.length] = name;
            // 暂保留 "{name}" 原文，便于抛错前仍得到可读中间结果
            parts[parts.length] = '{' + name + '}';
        }
        else {
            var val:*           = params[name];
            parts[parts.length] = val is String ? val as String : String(val);
        }

        i            = j + 1;
        literalStart = i;
    }

    if (!replaced) {
        return format;
    }

    parts[parts.length] = format.substring(literalStart);

    if (missing != null && missing.length > 0) {
        throw new ArgumentError(
            'Format: missing parameter(s): ' + missing.join(', ')
        );
    }

    return parts.join('');
}
}
