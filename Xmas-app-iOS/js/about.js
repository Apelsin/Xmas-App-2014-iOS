function ready()
{
    $('a.flatpage').each(App.EachApplyClickNavPush({ local: true }));
}

$(ready);