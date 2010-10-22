package com.playfish.rpc.island
{
	import com.playfish.rpc.island.bean.Tile;
	import com.playfish.rpc.island.message.response.ChatReceived;
	import com.playfish.rpc.island.message.response.CreateArena;
	import com.playfish.rpc.island.message.response.JoinGame;
    import com.playfish.rpc.island.message.response.JoinArena;
	import com.playfish.rpc.share.RpcResponseBase;
    import com.playfish.rpc.island.bean.Arena;
    import com.playfish.rpc.island.bean.UserInfoArena;
    import com.playfish.rpc.island.bean.Unity;

	internal class RpcResponse extends RpcResponseBase
	{
        internal function readShortArena(): Arena
        {
			trace("Read Short Arena");
			var arena:Arena = new Arena();
            arena.id = readString();
			arena.userId = readNetworkUid();
			return arena;
        }

        internal function readLongArena(): Arena
        {
            trace("read Long Arena");
            var arena:Arena = new Arena();
            arena.id = readString();
            arena.playerOne = readUserInfoArena();
            arena.playerTwo = readUserInfoArena();
            arena.tiles = readArray(readTile);

            return arena;
        }

        internal function readUserInfoArena():UserInfoArena
        {
            trace("read User Info Arena");
            var user:UserInfoArena = new UserInfoArena();
            user.networkUid = readNetworkUid();
            user.life= readUintvar31();
            user.unityInHand = readArray(readUnity);
            return user;
        }

        internal function readUnity():Unity
        {
           trace("read Unity");
           var unity:Unity = new Unity();
           unity.unityId = readUintvar31();
           unity.typeId = readUintvar31();
           unity.currentLife = readUintvar31();
           return unity;
        }

		internal function readJoinGame (): JoinGame
		{
			trace("Read Join Game");
			var join: JoinGame = new JoinGame();
            join.userId = readNetworkUid();
            join.usersId = readArray(readNetworkUid);
			return join;
		}

		internal function readJoinArena (): JoinArena
		{
			trace("Read Join Arena");
			var join:JoinArena = new JoinArena();

            if(readBoolean()){
                join.arena = readLongArena();
            }
			return join;
		}

		internal function readChatReceived ():ChatReceived
		{
			trace ("CHAT RECEIVED");
			var chatReceived:ChatReceived = new ChatReceived();
			chatReceived.message = readString();
			chatReceived.userId = readNetworkUid();
			trace ("Message: "+chatReceived.message);
			return chatReceived;
		}
		
		internal function readCreateArena():CreateArena
		{
			trace("Create Arena");
			var createArena:CreateArena = new CreateArena();
			createArena.uid = readNetworkUid();
			createArena.uuid = readString();
			return createArena;
		}
		
		/*internal function readFriendMove ():FriendMove
		{
			trace ("Move RECEIVED");
			var moveReceived:FriendMove = new FriendMove();
			moveReceived.userId = readNetworkUid();
			trace ("Message: "+moveReceived.toString());
			return moveReceived;
		}*/
		

		internal function readPlayer():Player
		{
			trace("Read Player");
			var player:Player = new Player();
			player.uid = readUintvar32();
			return player;
		}

		internal function readTile():Tile
		{
			trace("ReadTile");
            var tile:Tile = new Tile();

            if(readBoolean()){
                tile.unity = readUnity();
            }
			return tile;
		}
	}
	
	
}
