// Makes an async request without caring about a response
function execute(url)
{
    iframe = document.createElement("iframe");
    iframe.setAttribute("src", url);
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
}

Array.prototype.last = function() {
    return this[this.length-1];
}