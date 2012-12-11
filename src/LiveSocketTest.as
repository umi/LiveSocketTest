package
{
	import flash.display.Sprite;
	import flash.net.Socket;
	import flash.text.TextField;
	
	import server.Server;
	
[SWF(width="620", height="220", backgroundColor="0xFFCC00", frameRate="30")]
	
	public class LiveSocketTest extends Sprite
	{
		private var txt:TextField;
		private var server:Server;
		
		public function LiveSocketTest(){
			txt = _createText();
			addChild(txt);
			
			server = new Server(_log);
		}
		
		private function _createText():TextField{
			var text:TextField = new TextField();
			text.x = 10;
			text.y = 10;
			text.width = 600;
			text.height = 200;
			text.background = true;
			text.backgroundColor = 0xFFFF99;
			text.border = true;
			
			return text;
		}
		
		private function _log(t:String):void{
			txt.appendText(t + "\n");
			txt.scrollV++;
		}
	}
}