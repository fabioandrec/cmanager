function $(aid)
{
	return document.getElementById(aid)
}

function toggleVisible(aid)
{
	element = $(aid)
	if (element.style.visibility == "hidden")
	{
		element.style.visibility = "visible"
	}
	else
	{
		element.style.visibility = "hidden"
	}
}

function toggleWait()
{
	toggleVisible("waitMarker")
}

function makeHighlited(aelement)
{
	aelement.className = "clickableHighlited"
}

function makeNormalized(aelement)
{
	aelement.className = "clickableNormalized"
}

function makeClickable(aname)
{
	element = $(aname)
	element.onmouseover = function(){makeHighlited(this);}
	element.onmouseout = function(){makeNormalized(this);}
	makeNormalized(element)
}