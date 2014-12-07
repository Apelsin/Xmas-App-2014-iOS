//// App functions ////
App = {
    // Makes an async request without caring about a response
    Execute: function(url)
    {
        //alert(url);
        iframe = document.createElement('iframe');
        iframe.setAttribute('src', 'app://' + url);
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
            App.Execute('nav/push:' + arg_str);
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
    Paddy: function(n, p, c)
    {
        var pad_char = typeof c !== 'undefined' ? c : '0';
        var pad = new Array(1 + p).join(pad_char);
        return (pad + n).slice(-pad.length);
    },
    Log: function(message)
    {
        console.log(message);
        App.Execute('log:' + message);
    },
    AlertInfo: function(message)
    {
        message['alert-type'] = 'info';
        App.Execute('alert:' + JSON.stringify(message));
    },
    AlertWarn: function(message)
    {
        message['alert-type'] = 'warn';
        App.Execute('alert:' + JSON.stringify(message));
    },
};

//// Javascript prototype functions ////
Array.prototype.last = function() {
    return this[this.length-1];
}

function NoClickDelay(el) {
    this.element = el;
    if( window.Touch )
        this.element.addEventListener('touchstart', this, false);
}

NoClickDelay.prototype = {
    handleEvent: function(e) {
        switch(e.type) {
            case 'touchstart': this.onTouchStart(e); break;
            case 'touchmove': this.onTouchMove(e); break;
            case 'touchend': this.onTouchEnd(e); break;
        }
    },
        
    onTouchStart: function(e) {
        e.preventDefault();
        this.moved = false;
        
        this.element.addEventListener('touchmove', this, false);
        this.element.addEventListener('touchend', this, false);
    },
        
    onTouchMove: function(e) {
        this.moved = true;
    },
        
    onTouchEnd: function(e) {
        this.element.removeEventListener('touchmove', this, false);
        this.element.removeEventListener('touchend', this, false);
        
        if( !this.moved ) {
            // Place your code here or use the click simulation below
            var theTarget = document.elementFromPoint(e.changedTouches[0].clientX, e.changedTouches[0].clientY);
            if(theTarget.nodeType == 3) theTarget = theTarget.parentNode;
            
            var theEvent = document.createEvent('MouseEvents');
            theEvent.initEvent('click', true, true);
            theTarget.dispatchEvent(theEvent);
        }
    }
};

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

$.fn.scrollHint = function()
{
    base = this;
    this.wrapInner('<div class="contents">');
    
    this.append('<div class="indicator up">&#x2C4;</div>');
    this.append('<div class="indicator down">&#x2C5;</div>');
    
    this.wrapInner('<div class="scroll-hint">');
    
    contents = $('.contents', this);
    
    function scrolled(from, to)
    {
        scroll = contents[0].scrollHeight > contents[0].clientHeight;
        if(scroll)
        {
            last_zero = from == 0;
            at_zero = to == 0;
            if(at_zero)
            {
                $('.scroll-hint .indicator.down', base).fadeIn();
                $('.scroll-hint .indicator.up', base).fadeOut();
            }
            else if(last_zero)
            {
                $('.scroll-hint .indicator.down', base).fadeOut();
                $('.scroll-hint .indicator.up', base).fadeIn();
            }
        }
        else
        {
            $('.scroll-hint .indicator', base).fadeOut();
        }
    }
    function scroll_handler()
    {
        scroll = contents.scrollTop();
        last_scroll = contents[0].getAttribute('lastScroll') || 0;
        scrolled(last_scroll, scroll);
        contents[0].setAttribute('last-scroll', scroll);
    }
    scrolled(0,0);
    contents.scroll(scroll_handler);
}