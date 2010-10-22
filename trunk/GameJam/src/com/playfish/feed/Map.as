package com.playfish.feed
{

    import flash.utils.Dictionary;

    public class Map

    {
        private var keysList:Array = new Array();
        private var entries:Object = new Object();

        public function get length():uint
        {
            return keysList.length;
        }

        public function get(key:Object):Object
        {
            return entries[key];
        }

        public function getKeyAt(index:uint):Object
        {
            return keysList[index];
        }

        public function getKeysList():Array
        {
            return keysList.slice();
        }

        public function getValueAt(index:uint):Object
        {
            return entries[index];
        }
		
        /*public function getValuesList():Array
        {
            return valuesList.slice();
        }*/

        public function put(key:String, value:String):void
        {
			if ( entries[key] != null)
			{
				 entries[key] = value;
			}
			else
			{
				entries[key] = value;
				keysList.push(key);
			}

        }
		
        /*public function remove(key:String):void
        {
            delete entries[key];
            var index:int = keysList.indexOf(key);

            if (index > -1)
            {
                keysList.splice(index, 1);
                valuesList.splice(index, 1);
            }
        }*/

    }

} 