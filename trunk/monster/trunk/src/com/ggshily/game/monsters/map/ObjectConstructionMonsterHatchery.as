package com.ggshily.game.monsters.map
{
	import com.ggshily.game.geom.Grid;
	import com.ggshily.game.monsters.bean.Building;
	import com.ggshily.game.monsters.bean.BuildingHatchery;
	import com.ggshily.game.monsters.bean.MonsterProduceQueneElement;
	import com.ggshily.game.monsters.config.ConfigBase;
	import com.ggshily.game.monsters.config.ConfigConstruction;
	import com.ggshily.game.monsters.config.ConfigLevelInfoMonster;
	import com.ggshily.game.monsters.config.ConfigLevelInfoMonsterHatchery;
	import com.ggshily.game.monsters.config.ConfigMain;
	import com.ggshily.game.monsters.config.ConfigMonster;
	import com.ggshily.game.monsters.core.CONSTANT;
	import com.ggshily.game.monsters.map.event.ObjectConstructionEventBase;
	import com.ggshily.game.monsters.map.event.ObjectConstructionEventProducedMonster;
	import com.ggshily.game.monsters.user.User;
	import com.ggshily.game.monsters.user.UserManager;
	import com.ggshily.game.monsters.world.WorldOwnCity;
	
	import flash.utils.getTimer;
	
	public class ObjectConstructionMonsterHatchery extends ObjectConstruction
	{
		private var _isProducing : Boolean;
		private var _startProduceTime : Number;
		private var _quene : Vector.<MonsterProduceQueneElement>;
		
		public function ObjectConstructionMonsterHatchery(config:ConfigConstruction)
		{
			super(config);
			
			
		}
		
		override protected function buildComplete(currentTime : Number):void
		{
			super.buildComplete(currentTime);
			_startProduceTime = currentTime;
			_state = Building.STATE_IDLE;
			
			_quene = new Vector.<MonsterProduceQueneElement>();
			
			produceMonster(3000000);
			produceMonster(3000000);
			produceMonster(3000001);
		}
		
		override public function initFromBuilding(building:Building, gameMap : GameMap):void
		{
			super.initFromBuilding(building, gameMap);
			
			_startProduceTime = (building as BuildingHatchery).startProduceTime;
			_quene = (building as BuildingHatchery).produceQuene;
			
			
		}
		
		override public function initEvent(gameMap:GameMap):void
		{
			gameMap.addEvent(this, ObjectConstructionEventBase.PRODUCED_MONSTER);
		}
		
		public function produceMonster(typeId : int) : void
		{
			var element : MonsterProduceQueneElement;
			if(_quene.length == 0)
			{
				_startProduceTime = getTimer();
				element = new MonsterProduceQueneElement();
				element.typeId = typeId;
				element.amount = 1;
				_quene.push(element);
			}
			else
			{
				var exsit : Boolean = false;
				for each(element in _quene)
				{
					if(element.typeId == typeId)
					{
						element.amount++;
						exsit = true;
					}
				}
				if(!exsit && _quene.length < (config.getLevelInfo(_level) as ConfigLevelInfoMonsterHatchery).queneNumber)
				{
					element = new MonsterProduceQueneElement();
					element.typeId = typeId;
					element.amount = 1;
					_quene.push(element);
				}
			}
			
		}
		
		override public function tick(currentTime : Number):void
		{
			super.tick(currentTime);
			
			if(_state == Building.STATE_IDLE && _quene.length > 0)
			{
				var config : ConfigMonster = ConfigMain.instance.getConfigByTypeId(_quene[0].typeId) as ConfigMonster;
				var level : int = UserManager.instance.currentUser.getMonsterLevel(_quene[0].typeId);
				
				checkCanProduce(_quene[0].typeId);
				if(_isProducing && currentTime > _startProduceTime + config.getLevelInfo(level).time * 1000)
				{
					// produced:
					Debug.TRACE("produced a monster:" + _quene[0].typeId + "!!!" + currentTime);
					
					_quene[0].amount--;
					if(_quene[0].amount == 0)
					{
						_quene.shift();
					}
					_isProducing = false;
				}
			}
		}
		
		private function checkCanProduce(typeId : int) : void
		{
			
			var totalHousing : int = UserManager.instance.currentUser.getTotalMonsterHousing();
			var currentHousing : int = UserManager.instance.currentUser.getCurrentMonsterHousing();
			
			if(!_isProducing && currentHousing + ((ConfigMain.instance.getConfigByTypeId(typeId) as ConfigMonster)
				.getLevelInfo(UserManager.instance.currentUser.getMonsterLevel(typeId)) as ConfigLevelInfoMonster).housing
				<= totalHousing)
			{
				_isProducing = true;
				_startProduceTime = getTimer();
				
				dispatchEvent(new ObjectConstructionEventProducedMonster(typeId, this));
				
			}
		}
	}
}