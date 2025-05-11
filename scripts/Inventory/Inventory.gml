// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Inventory() constructor {

	_inventory_items=[];
	
	item_set = function(_name, _quantity, _sprite){
		array_push(_inventory_items, {
			name : _name,
			quantity: _quantity,
			sprite: _sprite,
		});
	}
	
	item_find = function(_name){
		for (var i=0;i<array_length(_inventory_items);i++){
			if(_name==_inventory_items[i].name){
				return i;
			}
		}
		
		return -1;
	}
	
	item_add = function(_name, _quantity, _sprite){
		var index = item_find(_name);
		
		if(index>=0){
			_inventory_items[index].quantity += _quantity;
		} else {
			item_set(_name,_quantity,_sprite);
		}
	}
	
	toString = function(){
		return json_stringify(_inventory_items);
	}
	
}