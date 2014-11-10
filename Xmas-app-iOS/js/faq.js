function ready()
{
    list_elements = $('ol#table-of-contents li')
    a_tags = $('a', list_elements);
    function ea(index, element)
    {
        function click(e)
        {
            href = e.currentTarget.href;
            //anchor = href.substring(href.lastIndexOf("#"));
            //anchor_elem = $(anchor);
            arguments = { URLString: href, Title: ''};
            execute('app://nav/push:' + JSON.stringify(arguments));
            return false;
        }
        j = $(element);
        j.on('click', click);
        $('<div class="blurme blur-toc"></div>').insertAfter(j);
        j.wrapInner('<a>');
    }
    a_tags.each(ea);
    $('.blurme', list_elements).blurjs({
                                    source: 'html',
                                    radius: 7,
                                    });
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

$(ready);