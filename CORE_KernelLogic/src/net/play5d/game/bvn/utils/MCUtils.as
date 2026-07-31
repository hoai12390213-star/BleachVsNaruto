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

package net.play5d.game.bvn.utils {
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.geom.ColorTransform;

import net.play5d.game.bvn.ctrler.game_ctrls.GameCtrl;
import net.play5d.game.bvn.data.TeamID;
import net.play5d.game.bvn.fighter.Assister;
import net.play5d.game.bvn.fighter.Bullet;
import net.play5d.game.bvn.fighter.FighterAttacker;
import net.play5d.game.bvn.fighter.FighterMain;
import net.play5d.game.bvn.interfaces.IGameSprite;
import net.play5d.game.bvn.stage.GameStage;
import net.play5d.game.bvn.views.effects.FollowEffectView;
import net.play5d.kyo.utils.KyoUtils;

/**
 * 影片剪辑与游戏 Sprite 实用工具。
 *
 * <p>通用 MC 能力委托 <code>KyoUtils</code>；染色与遍历依赖游戏运行时。</p>
 *
 * @see net.play5d.kyo.utils.KyoUtils#hasFrameLabel()
 * @see net.play5d.kyo.utils.KyoUtils#setHue()
 * @see net.play5d.kyo.utils.KyoUtils#stopAllMovieClips()
 */
public class MCUtils {

    /**
     * 影片剪辑是否具有指定名称帧。
     *
     * @param mc 指定影片剪辑
     * @param label 帧名称
     *
     * @return 影片剪辑是否具有某个帧
     * @see net.play5d.kyo.utils.KyoUtils#hasFrameLabel()
     */
    public static function hasFrameLabel(mc:MovieClip, label:String):Boolean {
        return KyoUtils.hasFrameLabel(mc, label);
    }

    /**
     * 设置显示对象色相滤镜（-180 - 180）
     *
     * @param display
     * @param hue 色相值（-180 - 180）
     * @see net.play5d.kyo.utils.KyoUtils#setHue()
     */
    public static function setHue(display:DisplayObject, hue:Number = 0):void {
        KyoUtils.setHue(display, hue);
    }

    /**
     * 停止指定影片剪辑以及其子影片剪辑的播放
     *
     * @param mc 指定影片剪辑
     * @see net.play5d.kyo.utils.KyoUtils#stopAllMovieClips()
     */
    public static function stopAllMovieClips(mc:MovieClip):void {
        KyoUtils.stopAllMovieClips(mc);
    }

    /**
     * 使用回调方式渲染游戏元件
     *
     * @param back 回调函数，需要一个参数 sp，类型为 IGameSprite
     */
    public static function renderGameSpritesCB(back:Function):void {
        var gameStage:GameStage = GameCtrl.I.gameState;
        if (!gameStage) {
            return;
        }

        var gameSprites:Vector.<IGameSprite> = gameStage.getGameSprites();
        if (!gameSprites || gameSprites.length == 0) {
            return;
        }

        for (var i:int = 0; i < gameSprites.length; i++) {
            var sp:IGameSprite = gameSprites[i] as IGameSprite;

            if (back != null) {
                back(sp);
            }

            if (!sp || sp.isDestroyed()) {
                i--;
            }
        }
    }

    /**
     * 更改游戏 Sprite 颜色，默认绿色偏移 -85
     *
     * @param sp 指定 IGameSprite
     * @param ct 颜色变换通道
     */
    public static function changeSpColor(sp:IGameSprite, ct:ColorTransform = null):void {
        if (!sp) {
            return;
        }

        ct ||= new ColorTransform(
                1, 1, 1, 1,
                0, -85, 0, 0
        );

        sp.colorTransform = ct;
    }

    /**
     * 自动更改游戏 Sprite 颜色，默认绿色偏移 -85
     *
     * @param sp 指定 IGameSprite
     * @param owner 指定初始所有者
     * @param ct 颜色变换通道
     */
    public static function autoChangeSpColor(
            sp:IGameSprite,
            owner:IGameSprite = null,
            ct:ColorTransform = null):void
    {
        if (!sp) {
            return;
        }

        if (!owner) {
            changeSpColor(sp, ct);
            return;
        }

        // 检查是否为 P2 所属元件
        if (TeamID.TEAM_2 != owner.team.id) {
            return;
        }

        // 当前场景下是否是相同人物
        var isSameFighter:Boolean = GameCtrl.I.gameRunData.isSameFighter;
        // 当前场景下是否是相同辅助
        var isSameAssister:Boolean = GameCtrl.I.gameRunData.isSameAssister;

        if (sp is Assister) {
            if (isSameAssister) {
                changeSpColor(sp, ct);
            }
        }
        else if (sp is FighterAttacker) {
            if (owner is FighterMain && isSameFighter ||
                owner is Assister && isSameAssister)
            {
                changeSpColor(sp, ct);
            }
        }
        else if (sp is Bullet || sp is FollowEffectView) {
            if (owner is FighterMain && isSameFighter ||
                owner is Assister && isSameAssister)
            {
                changeSpColor(sp, ct);
            }
            else if (owner is FighterAttacker) {
                owner = (owner as FighterAttacker).getOwner();
                autoChangeSpColor(sp, owner, ct);
            }
        }
    }
}
}
