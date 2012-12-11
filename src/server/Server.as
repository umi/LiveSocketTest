package server
{
	import flash.events.Event;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;

	public class Server
	{
		private var serverSocket:ServerSocket;
		private var clientSockets:Array;
		private var log:Function;
		
		public function Server(l:Function){
			log = l;
			clientSockets = new Array();
			try{
				serverSocket = new ServerSocket();
				serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, _onConnectHandler);
				serverSocket.addEventListener(Event.CLOSE, _onCloseHandler);
				serverSocket.bind(8888, "127.0.0.1");
				serverSocket.listen();
				log(serverSocket.localPort + " port listening.");
			}catch(e:Error){
				log(e);
			}
		}
		
		private function _onConnectHandler(e:ServerSocketConnectEvent):void{
			var socketService:SocketService = new SocketService(e.socket, log);
			socketService.addEventListener(Event.CLOSE, _onClientClose);
			clientSockets.push(socketService);
		}
		
		private function _onClientClose(e:Event):void{
			for each(var service:SocketService in clientSockets){
				if(service.closed) service = null;
			}
		}
		
		private function _onCloseHandler(e:Event):void{
			log("socket closed.");
		}
	}
}