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
        j.on('click', App.TapNavPush({ local: true }));
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

window.FragmentChanged = function()
{
    $('#page-throbber').hide();
    $(window.location.hash).removeClass('hidden');
}

$(window).load(ready);