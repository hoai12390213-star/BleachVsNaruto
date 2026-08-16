package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;

    [SWF(width='1000', height='600', frameRate='30', backgroundColor='#000000')]
    public class FighterTesterIOS extends Sprite {
        public function FighterTesterIOS() {
            if (stage) {
                init();
            }
            else {
                addEventListener(Event.ADDED_TO_STAGE, init);
            }
        }

        private function init(event:Event = null):void {
            if (event) {
                removeEventListener(Event.ADDED_TO_STAGE, init);
            }

            graphics.beginFill(0x111111, 1);
            graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
            graphics.endFill();

            var label:TextField = new TextField();
            label.text = 'BleachVsNaruto iOS shell ready';
            label.selectable = false;
            label.width = 400;
            label.x = 50;
            label.y = 50;
            addChild(label);
        }
    }
}
