function ready()
{
    function done(data)
    {
        
        // Build event lists from array of event infos
        function build_list(events)
        {
            event_list = $('ul.event-list');
            event_proto = $('#prototype li.event', event_list);
            function ea(element, index, array)
            {
                event = event_proto.clone().appendTo(event_list);
                $('.title .text', event).text(element.title);
                $('.when .text', event).text(element.when);
                $('.where .text', event).text(element.where);
                event.attr('moment-begin', element.moment_begin.toISOString());
                event.attr('moment-end', element.moment_end.toISOString());
                if(element.all_day_event)
                    event.addClass('all-day');
                if(element.oversize)
                {
                    event.addClass('oversize');
                }
            }
            events.forEach(ea);
        }
        // Parse the content of the request
        page_content = data.page.content;
        j_data = $(page_content);
        events = [];
        
        //// Time parsing ////
        
        // Groups: hour, minute, pm
        time_regex = new RegExp('^([0-9]{1,2})(:([0-9]{2}))?\s?(pm)?', 'i')
        moment_parse_format = 'YYYY MMM DD HH:mm';
        moment_readable_format = 'MMM D [from] h:mm A';
        moment_readable_format_all_day = 'MMM D';
        moment_readable_format_brief = 'h:mm A';
        function parse_time(time)
        {
            time = time.toLowerCase();
            if(time == "midnight")
                return "00:00";
            else if(time == "noon")
                return "12:00";
            groups = time_regex.exec(time);
            hour = parseInt(groups[1]);
            minute = parseInt(groups[3] || 0);
            pm = groups[4] != undefined;
            if(pm)
                hour = (hour + 12) % 24;
            return App.Paddy(hour, 2) + ":" + App.Paddy(minute, 2);
        }
        
        function get_parseable_date(date_element)
        {
            return [
            $('.event-year', date_element).text(),
            $('.event-month', date_element).text(),
            $('.event-day', date_element).text(),
            ].join(' ');
        }
        
        //////////////////////
        
        function ea(index, element)
        {
            j_element = $(element);
            
            //// Time parsing ////
            time_text = $('.event-time', j_element).text();
            times = time_text.split('-');
            all_day_event = false;
            oversize = false;
            try
            {
                time_begin = parse_time(times[0].trim());
                try
                {
                    time_end = parse_time(times[1].trim());
                }
                catch(e)
                {
                    time_end = time_begin;
                }
            }
            catch(e)
            {
                all_day_event = true;
                time_begin = time_end = "00:00";
            }
            
            // Apparently this is correct
            start_date_j = $('.start-date', j_element);
            if(!start_date_j[0])
                start_date_j = $('.end-date', j_element)
            
            date_begin = get_parseable_date(start_date_j);
            datetime_begin_str = date_begin + " " + time_begin;
            moment_begin = moment(datetime_begin_str, moment_parse_format);
            date_end_element = $('.end-date', j_element);
            
            delete moment_end;
            if(date_end_element[0] !== undefined)
            {
                date_end = get_parseable_date(date_end_element);
                if(date_begin != date_end)
                {
                    datetime_end_str = date_end + " " + time_end;
                    moment_end = moment(datetime_end_str, moment_parse_format);
                    hours_difference = moment.duration(moment_end - moment_begin).asHours();
                    oversize = hours_difference >= 24;
                        
                    format_a = all_day_event ? moment_readable_format_all_day : moment_readable_format;
                    format_b = format_a;
                    joiner = all_day_event ? " thru " : " to ";
                    
                    when = moment_begin.format(format_a) + joiner + moment_end.format(format_b);
                }
            }
            if(typeof moment_end === 'undefined')
            {
                datetime_end_str = date_begin + " " + time_end;
                moment_end = moment(datetime_end_str, moment_parse_format);
                if(all_day_event)
                    when = moment_begin.format(moment_readable_format_all_day);
                else
                    when = moment_begin.format(moment_readable_format) + " to " + moment_end.format(moment_readable_format_brief);
            }
            //////////////////////
            
            event_info = {
                title: $('.event-title', j_element).text(),
                when: when,
                where: $('.event-location', j_element).text(),
                moment_begin: moment_begin,
                moment_end: moment_end,
                all_day: all_day_event,
                oversize: oversize,
            };
            events.push(event_info);
        }
        
        // Hide the throbber at this point
        $('#page-throbber').hide();
        
        $('.event', j_data).each(ea);
        build_list(events);
        
        // Enable this if you need to remove data detectors (fault tolerance)
        // App.RemoveDataDetectors($('ul.event-list li.event span.line'));
        
        // Make the click event for each element
        // issue a calendar message to the app
        list_elements = $('ul.event-list li.event');
        function apply_click(index, element)
        {
            function click(e)
            {
                j_currentTarget = $(e.currentTarget);
                if(j_currentTarget.hasClass('oversize'))
                {
                    App.AlertWarn({message: "Event duration too long for calendar.", detail: ""});
                }
                else
                {
                    title = $('.title .text', e.currentTarget).text();
                    where = $('.where .text', e.currentTarget).text();
                    begin = j_currentTarget.attr('moment-begin');
                    end = j_currentTarget.attr('moment-end');
                    
                    arguments = {
                        title: title,
                        where: where,
                        begin: begin,
                        end: end,
                    };
                    json_string = JSON.stringify(arguments);
                    App.Execute('calendar:' + json_string);
                }
            }
            $(element).on("tap", click);
        }
        list_elements.each(apply_click);
        
        $('<div class="fill blur-container"><div class="blur-me"></div></div>').appendTo(list_elements);
        blur_me = $('.blur-me', list_elements);
        blur_me.fixBackground();
    }

    function fail(a)
    {
        alert('There was a problem while loading the event schedule.');
        throw JSON.stringify(a);
    }
    // callback=? invokes JSONP (required for CORS)
    URLCalendar = 'http://christmasinthepark.com/calendar.html?json=1&callback=?';
    $.ajax({
        url: URLCalendar,
        dataType: 'json',
        success: done,
        error: fail
    });
}

$(ready);