function ready()
{
    function execute(url)
    {
        iframe = document.createElement("iframe");
        iframe.setAttribute("src", url);
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
    }
    
    // Remove iOS Data Detectors for date
    // information and replace with our
    // own special sauce
    // UIWebView leaves them enabled
    // for fault tolerance!
    function remove_data_detectors()
    {
        tags = $('ul#event-list li.event span.line a');
        count = tags.length;
        if(count)
        {
            function ea(index, element)
            {
                href = element.href;
                if(href.indexOf('x-apple-data-detectors') == 0)
                {
                    span = $('<span>').html(element.innerHTML);
                    j_element = $(element);
                    j_element.replaceWith(span);
                }
            }
            
            tags.each(ea);
            window.last_detector_count = count;
            setTimeout(remove_data_detectors, 50);
        }
        else
        {
            // Try again until some are available for the first time
            // Otherwise, callback
            if(window.last_detector_count == 0)
                setTimeout(remove_data_detectors, 50);
            else
            {
                callback();
            }
        }
    }
    
    window.last_detector_count = 0;
    
    remove_data_detectors();
    
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
            when += " 2014";
            when_parsed = moment(when, "MMM DD [at] hA YYYY"); // Moment.js
            
            arguments = {title: title, where: where, when: when_parsed}
            execute('app://calendar:' + JSON.stringify(arguments));
        }
        $(element).click(click);
    }
    list_elements.each(apply_click);
    
    $('<div class="fill blur-container"><div class="blur-me"></div></div>').appendTo(list_elements);
    blur_me = $('.blur-me', list_elements);
    blur_me.fixBackground(); // common.js
    //blur_me.blurjs({source: 'body', radius: 12 });

    
}

$(ready);