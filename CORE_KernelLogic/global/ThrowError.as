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
 * 抛出或仅打印错误（调试版可真正 throw）。
 *
 * <p><code>errorParam</code> 可为 <code>Error</code> 实例或其子类的
 * <code>Class</code>。非调试环境或 <code>isThrow</code> 为
 * <code>false</code> 时只打印堆栈，不抛出。</p>
 *
 * @param errorParam <code>Error</code> 实例，或可 <code>new</code> 出
 *                   <code>Error</code> 的类。
 * @param message 写入 <code>error.message</code> 的文案；默认空串。
 * @param isThrow 为 <code>true</code>（默认）且 <code>IsDebugger()</code> 时真正抛出。
 * @throws Error 调试环境且 <code>isThrow</code> 为真时抛出。
 * @example
 * <listing version="3.0">
 * ThrowError(Error, '测试错误1');
 * ThrowError(new ArgumentError(), '测试错误2');
 * ThrowError(Error, '仅打印', false);
 * </listing>
 * @see IsDebugger
 * @see Printf
 */
public function ThrowError(errorParam:*, message:String = '', isThrow:Boolean = true):void {
    if (!errorParam) {
        Printf('Error parameter is invalid');
        return;
    }

    var error:Error = null;

    if (errorParam is Error) {
        error = errorParam as Error;
    }
    else if (errorParam is Class) {
        try {
            error = new errorParam() as Error;
        }
        catch (e:Error) {
            ThrowError(e, 'Failed to throw Error');
            return;
        }
        if (!error) {
            Printf('Error class is not instantiated or is of wrong type');
            return;
        }
    }
    else {
        Printf('Error parameter is invalid');
        return;
    }

    error.message = message;
    Printf(error.getStackTrace());

    if (IsDebugger() && isThrow) {
        throw error;
    }
}
}
