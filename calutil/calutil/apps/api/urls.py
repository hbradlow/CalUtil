from django.conf.urls.defaults import *
urlpatterns = patterns('api.views',
    url(r'^bus_stop/predictions/(?P<stop_id>([\d\w]+))/(?P<line_tag>[\w\._-]+)/$',"predictions",name="bus_predictions"),

    url(r'^bus_stop/predictions_p/(?P<line>(\w+))/(?P<stop>[\w\._-]+)/$',"perimeter_predictions",name="bus_predictions_p"),

    url(r'^personal_schedule/(?P<semester>(\w+))?/?$',"personal_schedule",name="personal_schedule"),
    url(r'^personal_schedule_waitlist/(?P<semester>(\w+))?/?$',"personal_schedule_waitlist",name="personal_schedule"),
    url(r'^balance/$',"cal1card_balance",name="balance"),
    url(r'^nutrition/(?P<item_id>(\d+))/$',"nutrition",name="nutrition"),
    url(r'^dailycal/(?P<entries>(\d+))?/?$',"dailycal",name="dailycal"),
    url(r'^dailycal/(?P<entries>(\d+))?/?$',"dailycal",name="dailycal"),
    url(r'^library_hours/$',"library_hours",name="library_hours"),
    url(r'^cal1card_hours/$',"cal1card_hours",name="cal1card_hours"),
    url(r'^library_hours/(?P<library_id>(\d+))/$',"library_hours",name="library_hours_with_id"),
    url(r'^active_sessions/$',"active_sessions",name="active_sessions"),
)
