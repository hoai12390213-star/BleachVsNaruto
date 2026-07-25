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

package net.play5d.game.bvn.ide.interfaces {
import flash.display.MovieClip;

import net.play5d.game.bvn.ide.entity.GameSpriteEntity;
import net.play5d.game.bvn.interfaces.IComponents;

/**
 * Animate IDE 组件基类（类，非 interface）。
 *
 * <p>生命周期：构造挂接第 0 帧 → <code>init</code>（隐藏 → <code>doAction</code> → <code>destroy</code>）。</p>
 * <p><code>$self</code> / <code>$target</code> / <code>$owner</code> 在 <code>init</code> 时懒绑定。</p>
 */
public class BaseComponent extends MovieClip implements IComponents {

    /////////////// 静态方法 ///////////////

    ///////////////////////////////////////


    /////////////// 构造方法 ///////////////

    /**
     * 构造方法。
     */
    public function BaseComponent() {
        if (!root) {
            return;
        }

        _gameSpriteEntity = new GameSpriteEntity(this);
        addFrameScript(0, init);
    }

    ///////////////////////////////////////


    /////////////// 实现接口 ///////////////

    /**
     * 销毁自身。
     */
    public function destroy():void {
        try {
            if (parent) {
                parent.removeChild(this);
            }
        }
        catch (e:Error) {
        }

        $self   = null;
        $target = null;
        $owner  = null;

        if (_gameSpriteEntity) {
            _gameSpriteEntity.destroy();
            _gameSpriteEntity = null;
        }
    }

    ///////////////////////////////////////


    /////////////// 公有属性 ///////////////

    ///////////////////////////////////////


    /////////////// 私有属性 ///////////////

    /**
     * @private 游戏元件实体。
     */
    protected var _gameSpriteEntity:GameSpriteEntity;

    /**
     * @private 自身类引用。
     */
    protected var $self:* = null;
    /**
     * @private 对手主人类引用，类型 FighterMain。
     */
    protected var $target:* = null;
    /**
     * @private 最顶主人类引用，类型 FighterMain。
     */
    protected var $owner:* = null;

    ///////////////////////////////////////


    /////////// Getter & Setter ///////////

    ///////////////////////////////////////


    /////////////// 公有方法 ///////////////

    /**
     * 初始化。
     *
     * <p>第一帧执行：绑定上下文 → 隐藏 → 动作 → 销毁。</p>
     */
    public function init():void {
        bindContext();
        hidden();
        doAction();
        destroy();
    }

    /**
     * 要详细执行的动作。
     *
     * <p>子类覆盖实现具体逻辑。</p>
     */
    public function doAction():void {
    }

    ///////////////////////////////////////


    /////////////// 私有方法 ///////////////

    /**
     * 绑定游戏上下文引用。
     */
    protected function bindContext():void {
        if (!_gameSpriteEntity) {
            return;
        }

        $self   = _gameSpriteEntity.self;
        $target = _gameSpriteEntity.target;
        $owner  = _gameSpriteEntity.owner;
    }

    /**
     * 隐藏自身。
     */
    protected function hidden():void {
        visible = false;
    }

    ///////////////////////////////////////
}
}

