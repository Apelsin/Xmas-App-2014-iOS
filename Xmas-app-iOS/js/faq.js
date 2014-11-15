function ready()
{
    // Select each listing in the table of contents
    list_elements = $('ol#table-of-contents li')
    // Get all the a tags inside those listings
    list_elements__a_tags = $('a', list_elements);
    function prepare__list_element__a_tag(index, element)
    {
        // jQuery of element
        j = $(element);
        // Local is false because fragment URIs include full path because magic
        j.on('click', App.ClickNavPush({ local: false }));
        // Insert blur underlay and clip container
        $('<div class="fill blur-container"><div class="blur-me"></div></div>').insertAfter(j);
        // Wrap the contents of the a tag in another a tag for vertical-align property to work
        j.wrapInner('<a>');
    }
    // Prepare all of the a tags
    list_elements__a_tags.each(prepare__list_element__a_tag);
    
    blur_me = $('.blur-me', list_elements);
    blur_me.fixBackground();
}

App.FragmentChanged = function()
{
    if(window.location.hash != '#table-of-contents')
    {
        $('#table-of-contents, #contents>:not(' + window.location.hash + ')').hide();
        window.scrollTo(0, 0); // Scroll to top
    }
    else
    {
        $('#table-of-contents').siblings().hide(); // Table of Contents view
    }
}

$(window).load(ready);