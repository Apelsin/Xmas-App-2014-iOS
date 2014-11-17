function ready()
{
    // Remove iOS Data Detectors for date
    // information and replace with our
    // own special sauce
    // UIWebView leaves them enabled
    // for fault tolerance!
    App.RemoveDataDetectors($('ul#event-list li.event span.line'));
    
    // Make the click event for each element
    // issue a calendar message to the app
    list_elements = $('ul#event-list li.event');
    function apply_click(index, element)
    {
        function click(e)
        {
            title = $('.title .text', e.currentTarget).text();
            where = $('.where .text', e.currentTarget).text();
            when = $('.when .text', e.currentTarget).text();
            
            // Is it really wise to add this here?
            when += " 2014"; // Big assumption!!!
            when_parsed = moment(when, "MMM DD [at] hA YYYY"); // moment.js
            
            arguments = {title: title, where: where, when: when_parsed}
            json_string = JSON.stringify(arguments);
            App.Execute('app://calendar:' + json_string);
            //alert(json_string);
        }
        $(element).click(click);
    }
    list_elements.each(apply_click);
    
    $('<div class="fill blur-container"><div class="blur-me"></div></div>').appendTo(list_elements);
    blur_me = $('.blur-me', list_elements);
    blur_me.fixBackground();
}

$(ready);