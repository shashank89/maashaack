package com.ggshily.game.monsters.map.event
{
	import com.ggshily.game.monsters.map.GameMap;
	import com.ggshily.game.monsters.map.ObjectConstructionMonsterHatchery;
	import com.ggshily.game.monsters.map.ObjectConstructionMonsterHousing;
	import com.ggshily.game.monsters.user.UserManager;

	public class ObjectConstructionEventProducedMonster extends ObjectConstructionEventBase
	{
		private var _monsterTypdId : int;
		private var _hatchery : ObjectConstructionMonsterHatchery;
		
		public function ObjectConstructionEventProducedMonster(monsterTypdId : int, hatchery : ObjectConstructionMonsterHatchery)
		{
			super(PRODUCED_MONSTER);
			
			_monsterTypdId = monsterTypdId;
			_hatchery = hatchery;
		}
		
		override public function process(gameMap:GameMap):void
		{
			var housing : ObjectConstructionMonsterHousing = gameMap.produceMonster(_monsterTypdId, _hatchery);
			
			UserManager.instance.currentUser.addMonster(_monsterTypdId, housing.instanceId);
		}
	}
}