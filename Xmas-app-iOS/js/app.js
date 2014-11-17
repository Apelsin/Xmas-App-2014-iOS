//// App functions ////
App = {
    // Makes an async request without caring about a response
    Execute: function(url)
    {
        //alert(url);
        iframe = document.createElement("iframe");
        iframe.setAttribute("src", url);
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
    },
    // Returns a curried event handler
    ClickNavPush: function(arguments)
    {
        // Tells the app to push a Flat Page to the navigation controller
        // Expects jQuery click event object as first argument
        function self(e, href)
        {
            arguments = {};
            if(!href) // If there's no override href, get it from the tag
                href = e.currentTarget.getAttribute('href'); // Verbatim href attribute
            
            if(href[0] == '#')
            {
                p = window.location.pathname;
                var filename = p.substring(p.lastIndexOf('/') + 1);
                href = filename + href;
            }
            
            arguments.Location = href;
            
            arg_str = JSON.stringify(arguments);
            // Tell the app to seque to the next view controller (i.e. navigate the app)
            App.Execute('app://nav/push:' + arg_str);
            // Don't navigate in the webView
            return false;
        }
        href = arguments.href;
        return function(e) { return self(e, href); };
    },
    EachApplyClickNavPush: function(arguments)
    {
        _arguments = arguments;
        function self(index, element)
        {
            if(App.IsLocalUrl(element.href))
            {
                $(element).click(App.ClickNavPush(_arguments));
            }
        }
        return self;
    },
    RemoveDataDetectors: function(selection)
    {
        last_detector_count = 0;
        function remove_data_detectors()
        {
            tags = $("a[href^='x-apple-data-detectors']", selection);
            count = tags.length;
            if(count)
            {
                tags.removeAttr('href');
                last_detector_count = count;
                setTimeout(remove_data_detectors, 50);
            }
            else
            {
                // Try again until some are available for the first time
                // Otherwise, callback
                if(last_detector_count == 0)
                    setTimeout(remove_data_detectors, 50);
            }
        }
        last_detector_count = 0;
        remove_data_detectors();
    },
    IsLocalUrl: function(url)
    {
        local_link = url.indexOf('file:') == 0;
        if(local_link)
            return true;
        protocol_relative = url.indexOf('//') == 0;
        protocol_specitic = url.indexOf('://') != -1;
        if(!protocol_relative && !protocol_specitic)
            return true;
        return false;
    },
    FragmentChanged: function()
    {
        // Stub
    }
};

//// Javascript prototype functions ////
Array.prototype.last = function() {
    return this[this.length-1];
}

//// JQuery functions ////
$.fn.fixBackground = function()
{
    return this.each(function(index, element) {
        j = $(element);
        j_pos = j.offset();
        value = (-j_pos.left) + "px " + (-j_pos.top) + "px";
        j.css('background-position', value);
    });
}