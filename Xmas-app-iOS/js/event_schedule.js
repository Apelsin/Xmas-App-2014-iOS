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
                span = $('<span>').html(element.innerHTML);
                j_element = $(element);
                event = j_element.closest('li');
                j_element.replaceWith(span);
                
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
                // $.click handled here
                event.click(click);
            }
            tags.each(ea);
            window.last_detector_count = count;
            setTimeout(remove_data_detectors, 100)
        }
        else
        {
            if(window.last_detector_count == 0)
                setTimeout(remove_data_detectors, 100);
        }
    }
    
    window.last_detector_count = 0;
    remove_data_detectors();
}

$(ready);