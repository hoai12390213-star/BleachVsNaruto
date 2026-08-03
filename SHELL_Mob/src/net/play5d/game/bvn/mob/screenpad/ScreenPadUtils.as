package net.play5d.game.bvn.mob.screenpad {
import flash.display.Bitmap;
import flash.geom.Point;

import net.play5d.game.bvn.mob.GameInterfaceManager;
import net.play5d.kyo.utils.KyoDisplayUtils;

public class ScreenPadUtils {
    public static function getArrow(cls:Class, size:Point):ScreenPadArrow {
        var arrow:ScreenPadArrow = new ScreenPadArrow();
        var bp:Bitmap            = new cls();
        arrow.display            = bp;
        arrow.display.alpha      = GameInterfaceManager.config.screenPadConfig.joyAlpha;
        arrow.init(size);
        return arrow;
    }

    public static function getButton(cls:Class, size:Point):ScreenPadBtn {
        var btn:ScreenPadBtn = new ScreenPadBtn();
        var bp:Bitmap        = new cls();
        btn.display          = bp;
        btn.display.alpha    = GameInterfaceManager.config.screenPadConfig.joyAlpha;
        btn.init(size);
        return btn;
    }

    public static function getPointByCM(cmX:Number = 0, cmY:Number = 0):Point {
        return KyoDisplayUtils.getPointByCM(cmX, cmY);
    }

    public static function cm2pixel(cm:Number):Number {
        return KyoDisplayUtils.cm2pixel(cm);
    }

    public function ScreenPadUtils() {
    }

}
}
