package server
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;

	public class SocketService extends EventDispatcher
	{
		private var socket:Socket;
		private var log:Function;
		
		public function SocketService(s:Socket, l:Function){
			socket = s;
			log = l;
			socket.addEventListener(ProgressEvent.SOCKET_DATA, _socketDataHandler);
			socket.addEventListener(Event.CLOSE, _onClientClose);
			socket.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
			log("connect " + socket.remoteAddress + ":" + socket.remotePort);
		}
		
		private function _socketDataHandler(e:ProgressEvent):void{
			var socket:Socket = e.target as Socket;
			var msg:String = socket.readUTFBytes(socket.bytesAvailable);
			log("receive " + msg);
			if(msg == "<policy-file-request/>"){
				var policy:String = '<cross-domain-policy><allow-access-from domain="*" to-ports="8888" /></cross-domain-policy>\x00';
				socket.writeUTFBytes(policy);
				socket.flush();
			}
		}
		
		private function _onClientClose(e:Event):void{
			var socket:Socket = e.target as Socket;
			log("close " + socket.remoteAddress + ":" + socket.remotePort);
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function _onIOError(e:IOErrorEvent):void{
			log("IOError: " + e.text);
			socket.close();
		}
		
		public function get closed():Boolean{
			return socket.connected;
		}
	}
}