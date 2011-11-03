
console.log("start");

// if has subject
console.log(document.getElementById(":qi"));
console.log(document.getElementById(":qc"));
console.log(document.getElementById(":pz"));


var path = [1, 1, 0, 0, 2,
			0, 1, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0];

var element = document.documentElement;
for(var i = 0; i < path.length; ++i)
{
	var index = path[i];
	console.log(i + " index:" + index);
	
	var children = element.childNodes;
	console.log("children" + children);
	console.log(children.length);
	
	element = children[index];
}

console.log(element);
//console.log(document.documentElement.children[1])