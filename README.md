## Dependencies
- [qb-menu] (https://github.com/qbcore-framework/qb-menu)

## Credits
* Thanks To Jim For Letting Me Use Images On qb-menu


## If you dont already have "vending_machine.ogg" then add it into "interact-sound/client/html/sounds"
## Make you have the below items in qb-core/shared/items.lua

* ['tosti'] 						 = {['name'] = 'tosti', 		
* ['twerks_candy'] 				 	 = {['name'] = 'twerks_candy', 
* ['snikkel_candy'] 				 = {['name'] = 'snikkel_candy',
* ['sandwich'] 				 	 	 = {['name'] = 'sandwich', 		
* ['coffee'] 				 		 = {['name'] = 'coffee', 	
* ['kurkakola'] 				 	 = {['name'] = 'kurkakola', 
* ['sprunk'] 				 	 	 = {['name'] = 'sprunk', 	

## qb-core/shared/items.lua
```
	['sprunk'] 				 	 	 = {['name'] = 'sprunk', 			  	  		['label'] = 'Sprunk', 					['weight'] = 500, 		['type'] = 'item', 		['image'] = 'sprunk.png', 				['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'For all the thirsty out there'},

```