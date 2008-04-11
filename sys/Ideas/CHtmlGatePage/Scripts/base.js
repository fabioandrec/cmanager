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
    element = $("logo")
    if (element != null)
    {
        element.src = "Images/wait.gif"
        element.id = "wait"
    }
    else
    {
        element = $("wait")
        if (element != null)
        {
            element.src = "Images/logo.jpg"
            element.id = "logo"            
        }
    }    
}

function makeHighlited(aelement)
{
	aelement.className = "clickableTextHighlited"
}

function makeNormalized(aelement)
{
	aelement.className = "clickableTextNormalized"
}

function makeClickable(aname)
{
	element = $(aname)
	element.onmouseover = function(){makeHighlited(this);}
	element.onmouseout = function(){makeNormalized(this);}
	makeNormalized(element)
}