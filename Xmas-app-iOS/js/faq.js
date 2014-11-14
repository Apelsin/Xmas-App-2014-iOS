function ready()
{
    // Select each listing in the table of contents
    list_elements = $('ol#table-of-contents li')
    // Get all the a tags inside those listings
    list_elements__a_tags = $('a', list_elements);
    function prepare__list_element__a_tag(index, element)
    {
        function click(e)
        {
            // Blank navigation title because it's
            // generally too long to fit in the native view
            arguments = { URLString: e.currentTarget.href, Title: ''};
            // Tell the app to seque to the next view controller
            execute('app://nav/push:' + JSON.stringify(arguments));
            // Prevent navigating in this view
            return false;
        }
        // jQuery of element
        j = $(element);
        // Set click event handler
        j.on('click', click);
        // Insert blur underlay and clip container
        $('<div class="fill blur-container"><div class="blur-me"></div></div>').insertAfter(j);
        // Wrap the contents of the a tag in another
        // a tag for vertical-align property to work
        j.wrapInner('<a>');
    }
    // Prepare all of the a tags
    list_elements__a_tags.each(prepare__list_element__a_tag);
    
    blur_me = $('.blur-me', list_elements);
    blur_me.fixBackground(); // common.js
    //blur_me.blurjs({source: 'body', radius: 12 });
    //list_elements.addClass('gloss');
}

function hashChanged()
{
    // Start at the header tag and work down until reaching
    // another header tag; collect elements along the way and
    // "solo" those elements.
    if(window.location.hash != '#table-of-contents')
    {
        list = [$(window.location.hash)]; // Get header from anchor
        contents = $('#contents'); // Get contents area
        while(true)
        {
            last = list.last(); // last() helper defined in common.js
            next = last.next(':not(h1, h2, h3)', contents);
            if(typeof next[0] == 'undefined')
                break; // Break if next tag doesn't match h1, h2 or h3
            list.push(next);
        }
        contents.siblings().hide(); // Hide everything outside contents
        $('>', contents).hide(); // Hide everything in contents
        function unhide(element, index, array)
        {
            element.show();
        }
        list.forEach(unhide); // Un-hide (show) collected elements
        window.scrollTo(0, 0); // Scroll to top
    } else {
        $('#table-of-contents').siblings().hide(); // Table of Contents view
    }
}

$(window).load(ready);