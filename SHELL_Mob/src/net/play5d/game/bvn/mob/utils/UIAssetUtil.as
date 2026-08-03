package net.play5d.game.bvn.mob.utils {
import flash.display.BitmapData;
import flash.utils.Dictionary;
import flash.utils.describeType;

import net.play5d.game.bvn.utils.EmbedSwf;

public class UIAssetUtil {

    private static var _i:UIAssetUtil;

    public static function get I():UIAssetUtil {
        _i ||= new UIAssetUtil();
        return _i;
    }

    public function UIAssetUtil() {
    }
    [Embed(source='/../../shared/lib/swf/mob_ui.swf')]
    public var win_ui:Class;
    private var _swfPool:Dictionary;
    private var _initBack:Function;
    private var _inited:Boolean;
    private var _initing:Boolean;

    public function initalize(back:Function = null):void {

        if (_initing) {
            throw new Error('正在初始化过程中，不能再次初始化！');
        }

        if (_inited) {
            if (back != null) {
                back();
            }
            return;
        }

        _inited  = true;
        _initing = true;

        _swfPool = new Dictionary();

        _initBack = back;

        var xml:XML = describeType(this);

        for each(var j:XML in xml.variable) {
            var k:String  = j.@name;
            var cls:Class = this[k];

            var swf:EmbedSwf = new EmbedSwf(cls);
            swf.ready        = swfReadyBack;
            _swfPool[cls]    = swf;

        }

    }

    public function createDisplayObject(itemName:String):* {
        var cls:Class = getItemClass(itemName);
        if (cls) {
            return new cls();
        }
    }

    public function createBitmapData(itemName:String, width:int, height:int):BitmapData {
        var cls:Class = getItemClass(itemName);
        if (!cls) {
            return null;
        }
        var bd:BitmapData = new cls(width, height);
        return bd;
    }

    public function getItemClass(itemName:String):Class {

        if (!_swfPool) {
            throw new Error('未进行初始化！');
        }

        var swf:EmbedSwf = _swfPool[win_ui];
        if (!swf) {
            throw new Error('swf is undefined!');
        }
        return swf.getClass(itemName);
    }

    private function swfReadyBack(target:EmbedSwf):void {
        for each(var i:EmbedSwf in _swfPool) {
            if (!i.isReady) {
                return;
            }
        }
        finish();
    }

    private function finish():void {

        _initing = false;

        if (_initBack != null) {
            _initBack();
            _initBack = null;
        }
    }

}
}
