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

$.fn.fixBackground = function()
{
    return this.each(function(index, element) {
        j = $(element);
        j_pos = j.offset();
        value = (-j_pos.left) + "px " + (-j_pos.top) + "px";
        console.log(value);
        j.css('background-position', value);
    });
}